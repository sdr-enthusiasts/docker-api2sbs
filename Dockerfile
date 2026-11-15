FROM ghcr.io/sdr-enthusiasts/docker-baseimage:base

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ARG VERSION_SHA
# hadolint ignore=SC2068
RUN set -xe && \
   # define packages needed for installation and general management of the container:
   TEMP_PACKAGES=() && \
   KEPT_PACKAGES=() && \
   KEPT_PACKAGES+=(jq) && \
   #
   # Install all the apt, pip3, and packages:
   apt-get update -q && \
   apt-get install -q -o APT::Autoremove::RecommendsImportant=0 -o APT::Autoremove::SuggestsImportant=0 -o Dpkg::Options::="--force-confold" -y --no-install-recommends  --no-install-suggests ${TEMP_PACKAGES[@]} ${KEPT_PACKAGES[@]} && \
   #
   # Add version to container:
   branch="#main#" && \
   SHA="${VERSION_SHA:-local}" && SHA="${SHA:0:7}" && \
   [[ -n "$SHA" ]] && \
   echo "${branch//#/}_(${SHA})_$(date +%y-%m-%d-%T%Z)" | tee /.VERSION && \
   #
   # Add some aliases to make debugging easier:
   echo "alias dir=\"ls -alsv\"" >> /root/.bashrc && \
   echo "alias nano=\"nano -l\"" >> /root/.bashrc && \
   # Clean up
   echo Uninstalling $TEMP_PACKAGES && \
   apt-get remove -y -q ${TEMP_PACKAGES[@]} && \
   apt-get autoremove -q -o APT::Autoremove::RecommendsImportant=0 -o APT::Autoremove::SuggestsImportant=0 -y && \
   apt-get clean -y -q && \
   # remove pycache
   { find /usr | grep -E "/__pycache__$" | xargs rm -rf || true; } && \
   rm -rf \
   /src/* \
   /var/cache/* \
   /tmp/* \
   /var/lib/apt/lists/* \
   /.dockerenv \
   /git

COPY rootfs/ /

EXPOSE 80
