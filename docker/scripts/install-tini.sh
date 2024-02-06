#!/bin/sh

set -ex

target_platform=$1
install_target=$2

tini_version=v0.19.0
tini_sha256=""

tini_arch=""
case $target_platform in
    linux/arm/v7 )
        tini_arch=armhf
        tini_sha256=5a9b35f09ad2fb5d08f11ceb84407803a1deff96cbdc0d1222f9f8323f3f8ad4
        ;;
    linux/arm64 )
        tini_arch=arm64
        tini_sha256=07952557df20bfd2a95f9bef198b445e006171969499a1d361bd9e6f8e5e0e81
        ;;
    linux/amd64 )
        tini_arch=amd64
        tini_sha256=21078849baca8c8fc0b90040d3769bf6fa2ffc7b0eb6b9e42343ed96e1cd734e
        ;;
    * )
        >&2 echo "unsupported tini arch: $target_platform"
        exit 1
esac

tmp_dir=$(mktemp -d)
cd $tmp_dir
file=tini-$tini_arch
curl -sSL -o $file https://github.com/krallin/tini/releases/download/$tini_version/$file
install $file "$install_target"
rm -rf $tmp_dir

