# collect_yaml_lists <file.yaml> [--print] [--prefix PREFIX]
# Creates:
#   categories : array of created variable names (sanitized, with optional PREFIX)
#   orig_keys  : array of original YAML keys (same order as categories)
#   One array per YAML key, e.g. "pip3" -> $pip3 (or $PREFIXpip3)
#
# Notes:
# - Works in bash (3.2+) and zsh.
# - zsh arrays are 1-based; bash arrays are 0-based. (Printing here handles both.)
# - Detects yq flavor (mikefarah vs kislyuk) automatically.

collect_yaml_lists() {
  # ---- args ----
  if [ $# -lt 1 ]; then
    echo "usage: collect_yaml_lists <file.yaml> [--print] [--prefix PREFIX]" >&2
    return 2
  fi
  local file="$1"; shift
  local do_print=0 prefix=""
  while [ $# -gt 0 ]; do
    case "$1" in
      --print)  do_print=1; shift ;;
      --prefix) prefix="$2"; [ -n "$prefix" ] || { echo "--prefix requires a value" >&2; return 2; }; shift 2 ;;
      *) echo "unknown option: $1" >&2; return 2 ;;
    esac
  done
  [ -f "$file" ] || { echo "File not found: $file" >&2; return 1; }

  # ---- shell detection ----
  local is_zsh=0
  [ -n "${ZSH_VERSION:-}" ] && is_zsh=1

  # ---- declare globals as arrays (zsh needs explicit types) ----
  if [ "$is_zsh" -eq 1 ]; then
    typeset -ga categories
    typeset -ga orig_keys
  fi
  categories=()
  orig_keys=()

  # ---- yq flavor detection ----
  local ver_out KEY_FILTER ITEM_FILTER
  ver_out="$( (yq -V 2>/dev/null || yq --version 2>/dev/null || true) )"
  if printf %s "$ver_out" | grep -qi 'mikefarah'; then
    KEY_FILTER='to_entries[] | select(.value | type=="!!seq") | .key'
    ITEM_FILTER='.[$k] | select(type=="!!seq")[] | tostring'
  else
    KEY_FILTER='to_entries[] | select(.value | type=="array") | .key'
    ITEM_FILTER='.[$k] | select(type=="array")[] | tostring'
  fi

  # ---- helpers ----
  _sanitize() { local s="$1"; s="${s//[^a-zA-Z0-9_]/_}"; case "$s" in [0-9]*) s="_$s";; esac; printf '%s' "$s"; }
  _name_in_use() { local n; for n in "${categories[@]}"; do [ "$n" = "$1" ] && return 0; done; return 1; }
  _assign_array() { # _assign_array <varname> <elements...>  (portable via printf %q + eval)
    local v="$1"; shift
    local assign="$v=(" x
    for x in "$@"; do assign="$assign $(printf '%q' "$x")"; done
    assign="$assign )"
    eval "$assign"
  }

  # ---- read keys ----
  # (split into lines in a shell-appropriate way)
  local -a keys
  if [ "$is_zsh" -eq 1 ]; then
    keys=("${(f)$(yq -r "$KEY_FILTER" "$file" 2>/dev/null || true)}")
  else
    keys=()
    while IFS= read -r line; do [ -n "$line" ] && keys+=("$line"); done < <(yq -r "$KEY_FILTER" "$file" 2>/dev/null || true)
  fi
  [ "${#keys[@]}" -gt 0 ] || { echo "No top-level list categories found in: $file" >&2; return 0; }

  # ---- build arrays ----
  local key safe base n
  for key in "${keys[@]}"; do
    safe="$(_sanitize "$key")"; safe="${prefix}${safe}"
    base="$safe"; n=1; while _name_in_use "$safe"; do n=$((n+1)); safe="${base}_$n"; done

    categories+=("$safe")
    orig_keys+=("$key")

    # gather items for this key
    local -a items
    if [ "$is_zsh" -eq 1 ]; then
      items=("${(f)$(yq -r --arg k "$key" "$ITEM_FILTER" "$file" 2>/dev/null || true)}")
    else
      items=()
      while IFS= read -r line; do items+=("$line"); done < <(yq -r --arg k "$key" "$ITEM_FILTER" "$file" 2>/dev/null || true)
    fi

    _assign_array "$safe" "${items[@]}"
  done

  # ---- optional pretty print (handles zsh 1-based vs bash 0-based) ----
  if [ "$do_print" -eq 1 ]; then
    if [ "$is_zsh" -eq 1 ]; then
      local i=1 max=${#categories[@]} name orig
      while [ $i -le $max ]; do
        name="${categories[$i]}"; orig="${orig_keys[$i]}"
        printf '%s:\n' "$orig"
        eval 'for __it in "${'"$name"'[@]}"; do printf "  - %s\n" "$__it"; done'
        i=$((i+1))
      done
    else
      local i name orig
      for i in "${!categories[@]}"; do
        name="${categories[$i]}"; orig="${orig_keys[$i]}"
        printf '%s:\n' "$orig"
        eval 'for __it in "${'"$name"'[@]}"; do printf "  - %s\n" "$__it"; done'
      done
    fi
  fi
}

