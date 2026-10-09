#!/bin/sh

set -ex

target_platform=$1
install_target=$2

chisel_version=v1.5.1
archive_sha256=""

go_arch=""
case $target_platform in
    linux/arm/v7 )
        go_arch=arm
        archive_sha256=38ac5b1525a68474f39f5df47646cb1c055ea0b0180a21366977d0a2fafc460e
        ;;
    linux/arm64 )
        go_arch=arm64
        archive_sha256=081cd2fb438f735cc79a0e6310ffe43f3a06abb312027a7e4b59afa7a2399769
        ;;
    linux/amd64 )
        go_arch=amd64
        archive_sha256=caa1f84ef144c3311d95ee464c1b72dd237e99055a8c58b791a5591abd42d9a1
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

