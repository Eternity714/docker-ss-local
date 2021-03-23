#
# Dockerfile for shadowsocks-libev
#

FROM alpine
LABEL maintainer="Eternity <372929104@qq.com>"

ENV SERVER_ADDR=
ENV LOCAL_ADDR 0.0.0.0
ENV SERVER_PORT 8388
ENV LOCAL_PORT 1080
ENV PASSWORD=
ENV METHOD      aes-256-cfb
ENV TIMEOUT     300

COPY . /tmp/repo
RUN set -ex \
 # Build environment setup
 && apk add --no-cache --virtual .build-deps \
      autoconf \
      automake \
      build-base \
      c-ares-dev \
      libcap \
      libev-dev \
      libtool \
      libsodium-dev \
      linux-headers \
      mbedtls-dev \
      pcre-dev \
 # Build & install
 && cd /tmp/repo \
 && ./autogen.sh \
 && ./configure --prefix=/usr --disable-documentation \
 && make install \
 && ls /usr/bin/ss-* | xargs -n1 setcap cap_net_bind_service+ep \
 && apk del .build-deps \
 # Runtime dependencies setup
 && apk add --no-cache \
      ca-certificates \
      rng-tools \
      tzdata \
      $(scanelf --needed --nobanner /usr/bin/ss-* \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u) \
 && rm -rf /tmp/repo

USER nobody

COPY ./entrypoint.sh /entrypoint.sh

CMD /entrypoint.sh