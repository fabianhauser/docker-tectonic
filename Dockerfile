FROM alpine:3.8 as build

RUN apk add --no-cache rust cargo openssl openssl-dev make g++
RUN apk add --no-cache fontconfig-dev harfbuzz-dev harfbuzz-icu icu-dev freetype-dev graphite2-dev libpng-dev zlib-dev

ARG UID=1000
ARG GID=1000

RUN mkdir -p /home/tectonic/.cache /home/tectonic/.config/Tectonic /home/tectonic/bin /home/tectonic/man && addgroup -g ${GID} tectonic && adduser -D -h /home/tectonic -u ${UID} -G tectonic tectonic && chown -R tectonic:tectonic /home/tectonic && mkdir /tectonic && chown tectonic:tectonic /tectonic

USER tectonic
RUN cd /tmp && busybox wget http://mirror.switch.ch/ftp/mirror/tex/indexing/makeindex.zip && unzip makeindex.zip && rm makeindex.zip
RUN cd /tmp/makeindex/src/ && make && cp makeindex /home/tectonic/bin/ && chmod 555 /home/tectonic/bin/makeindex && rm -rf /tmp/makeindex
RUN cd /home/tectonic/bin && busybox wget http://mirrors.ctan.org/macros/latex/contrib/glossaries/makeglossaries && chmod +x makeglossaries
RUN cargo install --vers 0.1.8 tectonic

FROM alpine:3.8

ARG UID=1000
ARG GID=1000
ARG MOUNTDIR=/tectonic

RUN apk add --no-cache fontconfig harfbuzz harfbuzz-icu icu freetype graphite2 libpng zlib openssl
RUN mkdir -p /home/tectonic/.cache /home/tectonic/.cargo/bin /home/tectonic/.config/Tectonic /home/tectonic/bin /home/tectonic/man /tectonic && addgroup -g ${GID} tectonic && adduser -D -h /home/tectonic -u ${UID} -G tectonic tectonic && chown -R tectonic:tectonic /home/tectonic /tectonic

USER tectonic

COPY --from=build /home/tectonic/.cargo/bin /home/tectonic/.cargo/bin
COPY --from=build /home/tectonic/bin /home/tectonic/bin

ADD config.toml /home/tectonic/.config/Tectonic/
ENV PATH="/home/tectonic/.cargo/bin:/home/tectonic/bin/:${PATH}"

VOLUME [ "${MOUNTDIR}" ]
VOLUME [ "/home/tectonic/.cache" ]

WORKDIR ${MOUNTDIR}

ENTRYPOINT [ "tectonic" ]
