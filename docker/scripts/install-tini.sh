#!/bin/sh

set -ex

target_platform=$1
install_target=$2

tini_version=v0.19.0
tini_sha256=""

go_arch=""
case $target_platform in
    linux/arm/v7 )
        go_arch=armhf
        tini_sha256=5a9b35f09ad2fb5d08f11ceb84407803a1deff96cbdc0d1222f9f8323f3f8ad4
        ;;
    linux/arm64 )
        go_arch=arm64
        tini_sha256=07952557df20bfd2a95f9bef198b445e006171969499a1d361bd9e6f8e5e0e81
        ;;
    linux/amd64 )
        go_arch=amd64
        tini_sha256=93dcc18adc78c65a028a84799ecf8ad40c936fdfc5f2a57b1acda5a8117fa82c
        ;;
    * )
        >&2 echo "unsupported tini arch: $target_platform"
        exit 1
esac

tmp_dir=$(mktemp -d)
cd $tmp_dir
file=tini-$go_arch
curl -sSL -o $file https://github.com/krallin/tini/releases/download/$tini_version/$file
echo "$tini_sha256 $file" | sha256sum -c -
install $file "$install_target"
rm -rf $tmp_dir

