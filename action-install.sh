#!/usr/bin/env bash

rime_version=1.8.3

rime_archive='rime-a0fceab-macOS.tar.bz2'
rime_download_url="https://github.com/rime/librime/releases/download/${rime_version}/${rime_archive}"

rime_deps_archive='rime-deps-a0fceab-macOS.tar.bz2'
rime_deps_download_url="https://github.com/rime/librime/releases/download/${rime_version}/${rime_deps_archive}"

mkdir -p download && (
    cd download
    curl -LO "${rime_download_url}"
    tar --bzip2 -xf "${rime_archive}"
    curl -LO "${rime_deps_download_url}"
    tar --bzip2 -xf "${rime_deps_archive}"
)

mkdir -p librime/share
cp -R download/dist librime/
cp -R download/share/opencc librime/share/

# skip building librime and opencc-data; use downloaded artifacts
make copy-rime-binaries copy-opencc-data

echo "SQUIRREL_BUNDLED_RECIPES=${SQUIRREL_BUNDLED_RECIPES}"

git submodule update --init plum
# install Rime recipes
rime_dir=plum/output bash plum/rime-install ${SQUIRREL_BUNDLED_RECIPES}
make copy-plum-data
