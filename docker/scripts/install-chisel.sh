#!/bin/sh

set -ex

target_platform=$1
install_target=$2

chisel_version=v1.4.1
archive_sha256=""

go_arch=""
case $target_platform in
    linux/arm/v7 )
        go_arch=arm
        archive_sha256=f48f1defe0966d4696c32a59ea8ce9a1b319eeaff86857274c30207eca8d0edb
        ;;
    linux/arm64 )
        go_arch=arm64
        archive_sha256=3606a0363ec3ee4f2d5bb5c81ee3892c6b15e8fe776509c012888a33d3953271
        ;;
    linux/amd64 )
        go_arch=amd64
        archive_sha256=a82cbaa4b17af2750d4593312cbdc5afd92573aacefdad08721ccf6a5bdef4f5
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

