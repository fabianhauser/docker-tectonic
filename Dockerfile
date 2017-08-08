FROM alpine:3.6

ARG UID=1000
ARG GID=1000
ARG MOUNTDIR=/tectonic

RUN mkdir -p /home/tectonic/.cache && addgroup -g ${GID} tectonic && adduser -D -h /home/tectonic -u ${UID} -G tectonic tectonic && chown -R tectonic:tectonic /home/tectonic
RUN mkdir /tectonic && chown tectonic:tectonic /tectonic

RUN apk add --no-cache rust cargo openssl openssl-dev make g++
RUN apk add --no-cache fontconfig-dev harfbuzz-dev harfbuzz-icu icu-dev freetype-dev graphite2-dev libpng-dev zlib-dev

USER tectonic

RUN cargo install tectonic

ENV PATH="/home/tectonic/.cargo/bin:${PATH}"

VOLUME [ "${MOUNTDIR}" ]
VOLUME [ "/home/tectonic/.cache" ]

WORKDIR ${MOUNTDIR}

ENTRYPOINT [ "tectonic" ]
