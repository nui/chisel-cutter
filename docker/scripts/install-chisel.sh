#!/bin/sh

set -ex

target_platform=$1
install_target=$2

chisel_version=v1.2.0
archive_sha256=""

go_arch=""
case $target_platform in
    linux/arm/v7 )
        go_arch=arm
        archive_sha256=9032d26bf1fab57d603447ea86167207ea9419309534c2883ef5d2fcdf8df766
        ;;
    linux/arm64 )
        go_arch=arm64
        archive_sha256=c12a73550e0337f3719b74a2e4ed65afcac5dc8a8c324c105f4c829ecb44f615
        ;;
    linux/amd64 )
        go_arch=amd64
        archive_sha256=4cdfd73c1ec5a5c9134453ba4422a000274f04e01435f73ea67da941210e4af5
        ;;
    * )
        >&2 echo "unsupported chisel arch: $target_platform"
        exit 1
esac

tmp_dir=$(mktemp -d)
cd $tmp_dir
file=chisel_${chisel_version}_linux_$go_arch.tar.gz
curl -sSL -o $file https://github.com/canonical/chisel/releases/download/${chisel_version}/$file
echo "$archive_sha256 $file" | sha256sum -c -
tar -xf $file
install chisel "$install_target"
rm -rf $tmp_dir

