FROM continuumio/miniconda

ARG UID=1000
ARG GID=1000
ARG MOUNTDIR=/tectonic
ARG VERSION=0.1.5

RUN conda config --add channels conda-forge && conda config --add channels pkgw-forge
RUN conda install -y tectonic=${VERSION}

RUN addgroup --gid ${GID} tectonic && useradd --home ${MOUNTDIR} --uid ${UID} --gid ${GID} tectonic

USER tectonic

VOLUME [ "${MOUNTDIR}" ]
WORKDIR ${MOUNTDIR}

ENTRYPOINT [ "tectonic" ]
