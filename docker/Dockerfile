FROM debian:sid-slim

ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    LANGUAGE=en_US:en

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -x && \
    KEPT_PACKAGES=() && \
    # Packages kept in the image
    KEPT_PACKAGES+=(bash) && \
    KEPT_PACKAGES+=(ca-certificates) && \
    KEPT_PACKAGES+=(locales) && \
    KEPT_PACKAGES+=(locales-all) && \
    KEPT_PACKAGES+=(python3) && \
    KEPT_PACKAGES+=(python-is-python3) && \
    KEPT_PACKAGES+=(python3-pip) && \
    KEPT_PACKAGES+=(python3-pyxattr) && \
    KEPT_PACKAGES+=(adduser) && \
    # Install packages
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
        ${KEPT_PACKAGES[@]} \
        && \
    # Create /config directory
    mkdir -p /config && \
    # Clean-up
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/*
RUN rm -rf /usr/lib/python3.*/EXTERNALLY-MANAGED && \
      pip3 install --no-cache tvnamer

# # Copy init script, set workdir, set configdir & entrypoint
COPY init /init
WORKDIR /workdir
ENTRYPOINT ["/init"]
