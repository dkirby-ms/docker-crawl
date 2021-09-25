# Builder image
FROM ubuntu:20.04 AS builder

# Variables
ENV CRAWL_REPO="https://github.com/crawl/crawl.git" \
  APP_DEPS="bzip2 liblua5.1-0-dev python3-minimal python3-pip python3-yaml \
    python-is-python3 ncurses-term locales-all sqlite3 libpcre3 locales \
    lsof sudo libbot-basicbot-perl" \
  BUILD_DEPS="autoconf bison build-essential flex git libncursesw5-dev \
    libsqlite3-dev libz-dev pkg-config binutils-gold libsdl2-image-dev libsdl2-mixer-dev \
    libsdl2-dev libfreetype6-dev libpng-dev ttf-dejavu-core advancecomp pngcrush" \
  DEBIAN_FRONTEND=noninteractive

# Install packages for the build
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y ${BUILD_DEPS} ${APP_DEPS}

# Retrieve crawl
RUN git clone ${CRAWL_REPO} /src/

# Build crawl v26
RUN cd /src && \
    git fetch origin && \
    git checkout stone_soup-0.26 && \
    git pull && \
    cd /src/crawl-ref/source && \
    make install -j4 DESTDIR=/crawl-26/ USE_DGAMELAUNCH=y WEBTILES=y

# Build crawl v27
RUN cd /src && \
    git fetch origin && \
    git checkout stone_soup-0.27 && \
    git pull && \
    cd /src/crawl-ref/source && \
    make install -j4 DESTDIR=/crawl-27/ USE_DGAMELAUNCH=y WEBTILES=y

# Build crawl trunk
RUN cd /src/crawl-ref/source && \
  git fetch origin && \
  git checkout master && \
  make install -j4 DESTDIR=/crawl-git/ USE_DGAMELAUNCH=y WEBTILES=y

# Set up webserver components
RUN cp -r /src/crawl-ref/source/webserver /app/ && \
  cp -r /src/crawl-ref/source/util /app/

# Runtime image
FROM ubuntu:20.04

# Environment Variables
ENV APP_DEPS="bzip2 liblua5.1-0-dev python3-minimal python3-pip python3-yaml \
    python-is-python3 ncurses-term locales-all sqlite3 libpcre3 locales \
    lsof sudo libbot-basicbot-perl" \
  DATA_DIR=/data \
  DEBIAN_FRONTEND=noninteractive

# Supported crawl versions (used by webtiles-init-player.sh)
ENV SUPPORTED_CRAWL_VERSIONS="git 26 27"

# Install packages for the runtime
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y ${APP_DEPS}

# Install Tornado
RUN pip3 install tornado PyYaML azure-identity azure-keyvault-secrets msal torndsession redis

# Copy over the compiled files
COPY --from=builder /crawl-26/ /crawl-26/
COPY --from=builder /crawl-27/ /crawl-27/
COPY --from=builder /crawl-git/ /crawl-git/
COPY --from=builder /app/ /webserver/

# Copy over custom configs
COPY webserver/config.py /webserver/config.py
COPY webserver/games.d/base.yaml /webserver/games.d/base.yaml

# Copy over OAuth code for AAD B2C support
COPY settings/init.txt /webserver/settings/
COPY util/webtiles-init-player.sh /webserver/util/
COPY webserver/aad_b2c.py /webserver/aad_b2c.py
COPY webserver/auth.py /webserver/auth.py
COPY webserver/server.py /webserver/server.py
COPY webserver/games.d/* /webserver/games.d/
COPY webserver/templates/client.html /webserver/templates/client.html
COPY webserver/templates/banner.html /webserver/templates/banner.html
COPY webserver/templates/game_links.html /webserver/templates/game_links.html
RUN chmod 700 /webserver/server.py && \
    mkdir /websockets

# Copy over the entrypoint
COPY scripts/entrypoint-webtiles.sh /webserver/entrypoint.sh

# Install OpenSSH and set the password for root to "Docker!". In this example, "apk add" is the install instruction for an Alpine Linux-based image.
# RUN apt-get install -y openssh-server && \
#   echo "root:Docker!" | chpasswd 

# Clean up unnecessary package lists
RUN rm -rf /var/lib/apt/lists/*

# Expose ports
EXPOSE 8080

# Set the WORKDIR
WORKDIR /webserver

# Copy the sshd_config file to the /etc/ssh/ directory
# COPY sshd_config /etc/ssh/

# Open port 2222 for SSH access
# EXPOSE 80 2222

# Launch WebTiles server
ENTRYPOINT [ "./entrypoint.sh" ]
