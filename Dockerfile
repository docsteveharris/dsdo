FROM jupyter/datascience-notebook:latest

# Build arguments for proxy settings
ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG NO_PROXY
ARG http_proxy
ARG https_proxy
ARG no_proxy
ARG NB_UID
ARG NB_GID

# Set environment variables for proxy
ENV HTTP_PROXY=${HTTP_PROXY} \
    HTTPS_PROXY=${HTTPS_PROXY} \
    NO_PROXY=${NO_PROXY} \
    http_proxy=${http_proxy} \
    https_proxy=${https_proxy} \
    no_proxy=${no_proxy}

USER root

# Configure apt to use proxy if set
RUN if [ ! -z "$HTTP_PROXY" ]; then \
        echo "Acquire::http::Proxy \"$HTTP_PROXY\";" > /etc/apt/apt.conf.d/proxy.conf; \
    fi && \
    if [ ! -z "$HTTPS_PROXY" ]; then \
        echo "Acquire::https::Proxy \"$HTTPS_PROXY\";" >> /etc/apt/apt.conf.d/proxy.conf; \
    fi

# Install system dependencies
RUN apt-get update && apt-get install -y \
    neovim \
    postgresql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip install visidata

# Ensure user has correct UID/GID
RUN groupmod -g ${NB_GID} jovyan \
    && usermod -u ${NB_UID} -g ${NB_GID} jovyan

# Switch back to non-root user
USER jovyan

# Install Neovim configuration
RUN git clone https://github.com/LazyVim/starter ~/.config/nvim

WORKDIR /workspace
