#!/bin/sh

set -ex

target_platform=$1
install_target=$2

gosu_version=1.19
gosu_sha256=""

go_arch=""
case $target_platform in
    linux/arm/v7 )
        go_arch=armhf
        gosu_sha256=8457a0bfd28e016c2c7d8ea6e5f7eed1376033ffbd36491bb455094c8b1dc9fd
        ;;
    linux/arm64 )
        go_arch=arm64
        gosu_sha256=3a8ef022d82c0bc4a98bcb144e77da714c25fcfa64dccc57f6aba7ae47ff1a44
        ;;
    linux/amd64 )
        go_arch=amd64
        gosu_sha256=52c8749d0142edd234e9d6bd5237dff2d81e71f43537e2f4f66f75dd4b243dd0
        ;;
    * )
        >&2 echo "unsupported TARGETPLATFORM: $target_platform"
        exit 1
esac

tmp_dir=$(mktemp -d)
cd $tmp_dir
file=gosu-$go_arch
curl -sSL -o $file https://github.com/tianon/gosu/releases/download/$gosu_version/$file
echo "$gosu_sha256 $file" | sha256sum -c -
install $file "$install_target"
rm -rf $tmp_dir

