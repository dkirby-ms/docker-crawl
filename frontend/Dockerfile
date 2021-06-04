FROM ubuntu:20.04

# Variables
ENV APP_DEPS="python3-minimal python3-pip python3-yaml python-is-python3"
ENV PYTHON_DEPS="requests flask werkzeug flask-session msal azure-keyvault-secrets azure-identity"

# Install packages
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y ${APP_DEPS}

# Install python packages
RUN pip install $PYTHON_DEPS

# Copy source
COPY source/ /app/

# Copy over the entrypoint
COPY scripts/entrypoint-webtiles.sh /app/entrypoint.sh

# Clean up unnecessary package lists
RUN rm -rf /var/lib/apt/lists/*

# Expose port
EXPOSE 80

# Set the WORKDIR
WORKDIR /app

# Launch frontend server
ENTRYPOINT [ "./entrypoint.sh" ]