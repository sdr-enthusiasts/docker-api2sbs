FROM ghcr.io/sdr-enthusiasts/docker-baseimage:base

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
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
   echo "${branch//#/}_($(curl -ssL "https://api.github.com/repos/kx1t/docker-api2sbs/commits/main" |  awk '{if ($1=="\"sha\":") {print substr($2,2,7); exit}}'))_$(date +%y-%m-%d-%T%Z)" | tee /.VERSION && \
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
