#!/bin/bash

# Script name: dsdo.sh

# Get environment variables from current session or set defaults
HOST_UID=$(id -u)
HOST_GID=$(id -g)
HOSTNAME=${HOSTNAME:-localhost}
HTTP_PROXY=${HTTP_PROXY:-""}
HTTPS_PROXY=${HTTPS_PROXY:-""}
NO_PROXY=${HOSTNAME},${HOSTNAME}.xuclh.nhs.uk,localhost,127.0.0.1

# Build command with all necessary arguments
build_container() {
    docker build \
        --build-arg HOST_NAME="${HOSTNAME}" \
        --build-arg HTTP_PROXY="${HTTP_PROXY}" \
        --build-arg HTTPS_PROXY="${HTTPS_PROXY}" \
        --build-arg NO_PROXY="${NO_PROXY}" \
        --build-arg http_proxy="${HTTP_PROXY}" \
        --build-arg https_proxy="${HTTPS_PROXY}" \
        --build-arg no_proxy="${NO_PROXY}" \
        --build-arg NB_UID="${HOST_UID}" \
        --build-arg NB_GID="${HOST_GID}" \
        -t dsdo .
}

# Run command with all necessary environment variables
run_container() {
    docker run -it --rm \
        -e HTTP_PROXY="${HTTP_PROXY}" \
        -e HTTPS_PROXY="${HTTPS_PROXY}" \
        -e NO_PROXY="${NO_PROXY}" \
        -e http_proxy="${HTTP_PROXY}" \
        -e https_proxy="${HTTPS_PROXY}" \
        -e no_proxy="${NO_PROXY}" \
        -e NB_UID="${HOST_UID}" \
        -e NB_GID="${HOST_GID}" \
        -e CHOWN_HOME="yes" \
        -e CHOWN_HOME_OPTS="-R" \
        -v "$(pwd)":/workspace \
        -w /workspace \
        dsdo /bin/bash
}

# Main script logic
case "$1" in
    "build")
        build_container
        ;;
    "run")
        run_container
        ;;
    *)
        echo "Usage: $0 {build|run}"
        echo "  build: Build the container image"
        echo "  run: Run the container with current directory mounted"
        exit 1
        ;;
esac
