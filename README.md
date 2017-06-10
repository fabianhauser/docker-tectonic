# fabianhauser/tectonic

This docker image provides a preinstalled [tectonic](https://tectonic-typesetting.github.io/):

> Tectonic is a modernized, complete, self-contained TeX/LaTeX engine, powered by XeTeX and TeXLive.

## Usage (Linux)
```bash
docker run -ti --rm --volume ~/.cache/docker-tectonic:/home/tectonic/.cache:z --volume `pwd`:/tectonic:z fabianhauser/tectonic YourFile.tex
```
