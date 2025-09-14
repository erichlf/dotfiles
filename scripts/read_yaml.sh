# collect_yaml_lists <file.yaml> [--print] [--prefix PREFIX]
# No yq. Works on mawk/BusyBox/BSD/gawk. Supports top-level:
#   key:
#     - item
#     - "item with spaces"
#   other: [a, b, "c"]
collect_yaml_lists() {
  # ---- args ----
  if [ $# -lt 1 ]; then
    echo "usage: collect_yaml_lists <file.yaml> [--print] [--prefix PREFIX]" >&2
    return 2
  fi
  local file="$1"
  shift
  local do_print=0 prefix=""
  while [ $# -gt 0 ]; do
    case "$1" in
    --print)
      do_print=1
      shift
      ;;
    --prefix)
      prefix="$2"
      [ -n "$prefix" ] || {
        echo "--prefix requires a value" >&2
        return 2
      }
      shift 2
      ;;
    *)
      echo "unknown option: $1" >&2
      return 2
      ;;
    esac
  done
  [ -f "$file" ] || {
    echo "File not found: $file" >&2
    return 1
  }

  # ---- shell detection ----
  local is_zsh=0
  [ -n "${ZSH_VERSION:-}" ] && is_zsh=1
  if [ "$is_zsh" -eq 1 ]; then
    typeset -ga categories
    typeset -ga orig_keys
  fi
  categories=()
  orig_keys=()

  # ---- helpers ----
  _sanitize() {
    local s="$1"
    s="${s//[^a-zA-Z0-9_]/_}"
    case "$s" in [0-9]*) s="_$s" ;; esac
    printf '%s' "$s"
  }
  _name_in_use() {
    local n
    for n in "${categories[@]}"; do [ "$n" = "$1" ] && return 0; done
    return 1
  }
  _assign_array() {
    local v="$1"
    shift
    local assign="$v=(" x
    for x in "$@"; do assign="$assign $(printf '%q' "$x")"; done
    assign="$assign )"
    eval "$assign"
  }

  # ---- awk tokenizer (mawk-safe: only 2-arg match, no functions) ----
  # Emits lines: __KEY__name / __ITEM__value / __END__
  local awk_out
  awk_out="$(
    awk '
      BEGIN { in_list=0; base_indent=0 }
      {
        line=$0

        # remove trailing comments only if a space/tab precedes #
        sub(/[ \t]#[^\n]*$/, "", line)

        # trim both ends (no functions, do it inline)
        t=line; sub(/^[ \t]+/, "", t); sub(/[ \t]+$/, "", t)
        if (t=="") next

        # compute indent = number of leading spaces/tabs
        tmp=line; match(tmp, /^[ \t]*/); indent=RLENGTH

        # detect flow:   key: [ ... ]
        if (line ~ /^[ \t]*[^:# \t][^:]*:[ \t]*\[/) {
          # key = text before first colon
          l2=line; sub(/^[ \t]+/, "", l2)
          cpos=index(l2, ":")
          if (cpos>0) {
            key=substr(l2,1,cpos-1); sub(/^[ \t]+/, "", key); sub(/[ \t]+$/, "", key)
            print "__KEY__" key
            # extract inside brackets from first "[" to last "]"
            bpos=index(l2, "[")
            s=substr(l2, bpos+1)
            sub(/\][ \t]*$/, "", s)
            # split on commas (commas inside quotes not supported)
            n=split(s, A, ",")
            for (i=1; i<=n; i++) {
              val=A[i]; sub(/^[ \t]+/, "", val); sub(/[ \t]+$/, "", val)
              # dequote simple "..." or '...'
              L=length(val)
              if (L>=2) {
                f=substr(val,1,1); e=substr(val,L,1)
                if ((f=="\"" && e=="\"") || (f=="'" && e=="'")) val=substr(val,2,L-2)
              }
              if (val!="") print "__ITEM__" val
            }
            print "__END__"
            in_list=0
            next
          }
        }

        # detect block start:   key:
        if (line ~ /^[ \t]*[^:# \t][^:]*:[ \t]*$/) {
          if (in_list==1) { print "__END__"; in_list=0 }
          l2=line; sub(/^[ \t]+/, "", l2)
          cpos=index(l2, ":")
          key=substr(l2,1,cpos-1); sub(/^[ \t]+/, "", key); sub(/[ \t]+$/, "", key)
          base_indent=indent
          in_list=1
          print "__KEY__" key
          next
        }

        if (in_list==1) {
          # if a new key at same-or-less indent, end the list and re-handle line
          if (line ~ /^[ \t]*[^:# \t][^:]*:/ && indent <= base_indent) {
            print "__END__"
            in_list=0
            # fall through to let the next iterations process this line again
          } else {
            # list item:   - value
            if (line ~ /^[ \t]*-[ \t]*/) {
              item=line
              sub(/^[ \t]*-[ \t]*/, "", item)
              sub(/[ \t]+$/, "", item)
              L=length(item)
              if (L>=2) {
                f=substr(item,1,1); e=substr(item,L,1)
                if ((f=="\"" && e=="\"") || (f=="'" && e=="'")) item=substr(item,2,L-2)
              }
              if (item!="") print "__ITEM__" item
              next
            }
          }
        }
      }
      END { if (in_list==1) print "__END__" }
    ' "$file"
  )"

  # ---- consume tokens and create arrays ----
  if [ -z "$awk_out" ]; then
    echo "No top-level list categories found in: $file" >&2
    return 0
  fi

  local cur_key="" cur_safe="" base="" n=1
  if [ "$is_zsh" -eq 1 ]; then typeset -ga __items; fi
  __items=()

  _finalize_current() {
    [ -z "$cur_key" ] && return 0
    cur_safe="$(_sanitize "$cur_key")"
    cur_safe="${prefix}${cur_safe}"
    base="$cur_safe"
    n=1
    while _name_in_use "$cur_safe"; do
      n=$((n + 1))
      cur_safe="${base}_$n"
    done
    categories+=("$cur_safe")
    orig_keys+=("$cur_key")
    _assign_array "$cur_safe" "${__items[@]}"
    __items=()
    cur_key=""
  }

  while IFS= read -r line; do
    case "$line" in
    __KEY__*)
      _finalize_current
      cur_key="${line#__KEY__}"
      ;;
    __ITEM__*) __items+=("${line#__ITEM__}") ;;
    __END__) _finalize_current ;;
    esac
  done <<EOF
$awk_out
EOF

  # ---- optional pretty print ----
  if [ "$do_print" -eq 1 ]; then
    if [ "$is_zsh" -eq 1 ]; then
      local i=1 max=${#categories[@]} name orig
      while [ $i -le $max ]; do
        name="${categories[$i]}"
        orig="${orig_keys[$i]}"
        printf '%s:\n' "$orig"
        eval 'for __it in "${'"$name"'[@]}"; do printf "  - %s\n" "$__it"; done'
        i=$((i + 1))
      done
    else
      local i name orig
      for i in "${!categories[@]}"; do
        name="${categories[$i]}"
        orig="${orig_keys[$i]}"
        printf '%s:\n' "$orig"
        eval 'for __it in "${'"$name"'[@]}"; do printf "  - %s\n" "$__it"; done'
      done
    fi
  fi
}
