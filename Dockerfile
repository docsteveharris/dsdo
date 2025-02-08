ARG BASE_IMAGE="datascience-notebook:ubuntu-22.04"
FROM quay.io/jupyter/${BASE_IMAGE}

ARG NB_UID
ARG NB_GID

USER root

SHELL ["/bin/bash", "-o", "pipefail", "-e", "-u", "-x", "-c"]

RUN export DEBIAN_FRONTEND=noninteractive && \
    export ACCEPT_EULA=Y && \
    apt-get update && \
    apt-get install --yes --no-install-recommends \
    neovim \
    postgresql-client 

# Clean up after building.
RUN  apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip install visidata

# Create group if it doesn't exist and modify user
RUN groupadd -f -g ${NB_GID} users && \
    usermod -u ${NB_UID} -g ${NB_GID} jovyan

USER jovyan

# Install Neovim configuration
RUN git clone https://github.com/LazyVim/starter ~/.config/nvim

WORKDIR /workspace
