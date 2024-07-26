ARG VERSION=latest
ARG OS=debian
ARG CLI_NAME=parrot
ARG ATMOS_VERSION=1.77.0

FROM cloudposse/geodesic:$VERSION-$OS

# Install Atmos
ARG ATMOS_VERSION
RUN apt-get install -y --allow-downgrades \
    atmos="${ATMOS_VERSION}-*"

# Geodesic message of the Day
ENV MOTD_URL=""

ENV AWS_VAULT_BACKEND=file
ARG GEODESIC_HOST_CWD
ENV GEODESIC_WORKDIR="${GEODESIC_HOST_CWD}"

ENV DOCKER_IMAGE="franciscoprin/parrot-infra"
ENV DOCKER_TAG="latest"

# Geodesic banner
ENV BANNER="parrot"
