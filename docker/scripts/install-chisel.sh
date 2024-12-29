#!/bin/sh

set -ex

target_platform=$1
install_target=$2

chisel_version=v1.0.0
archive_sha256=""

go_arch=""
case $target_platform in
    linux/arm/v7 )
        go_arch=arm
        archive_sha256=d70204fa47ec642d98d4b8b1403084e763111255cb845a22660d6948a5cd29fd
        ;;
    linux/arm64 )
        go_arch=arm64
        archive_sha256=c92aa273e63a06e8cbc1d1c398d69cad349af31c5c7e1a555b4d72c9ce0856c8
        ;;
    linux/amd64 )
        go_arch=amd64
        archive_sha256=8bd42198c8d9a5115693a0d42aa79acfd410431d758e98d4b74d39bb94e5743f
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

