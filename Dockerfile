FROM continuumio/miniconda

ARG UID=1000
ARG GID=1000
ARG MOUNTDIR=/tectonic
ARG VERSION=0.1.5

RUN conda config --add channels conda-forge && conda config --add channels pkgw-forge
RUN conda install -y tectonic=${VERSION}

RUN mkdir -p /home/tectonic/.cache && addgroup --gid ${GID} tectonic && useradd --home /home/tectonic --uid ${UID} --gid ${GID} tectonic && chown -R tectonic:tectonic /home/tectonic
RUN mkdir /tectonic && chown tectonic:tectonic /tectonic

USER tectonic

VOLUME [ "${MOUNTDIR}" ]
VOLUME [ "/home/tectonic/.cache" ]

WORKDIR ${MOUNTDIR}

ENTRYPOINT [ "tectonic" ]
