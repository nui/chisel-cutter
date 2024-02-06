#!/bin/sh

set -ex

target_platform=$1
install_target=$2

chisel_version=v0.9.0
archive_sha256=""

chisel_arch=""
case $target_platform in
    linux/arm/v7 )
        chisel_arch=arm
        archive_sha256=c6c87940d562e62923c7ad76fef532493762a0c6ffa8c1103a1ec4611238505b
        ;;
    linux/arm64 )
        chisel_arch=arm64
        archive_sha256=8ffb268fb310f0268eaa73141dd3c7efc073864624127ff5238a9bb1d68eb8f3
        ;;
    linux/amd64 )
        chisel_arch=amd64
        archive_sha256=21078849baca8c8fc0b90040d3769bf6fa2ffc7b0eb6b9e42343ed96e1cd734e
        ;;
    * )
        >&2 echo "unsupported chisel arch: $target_platform"
        exit 1
esac

tmp_dir=$(mktemp -d)
cd $tmp_dir

file=chisel_${chisel_version}_linux_$chisel_arch.tar.gz
curl -sSL -o $file https://github.com/canonical/chisel/releases/download/${chisel_version}/$file
echo "$archive_sha256 $file" | sha256sum -c -
tar -xf $file
install chisel "$install_target"
rm -rf $tmp_dir

