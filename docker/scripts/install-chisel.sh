#!/bin/sh

set -ex

target_platform=$1
install_target=$2

chisel_version=v0.10.0
archive_sha256=""

chisel_arch=""
case $target_platform in
    linux/arm/v7 )
        chisel_arch=arm
        archive_sha256=6fccafbd91f35d35a50d49e7e7dc0f46495411a98cd6dce2be5b9d3b9c9eb100
        ;;
    linux/arm64 )
        chisel_arch=arm64
        archive_sha256=5e85f77014cc823255ba17ee9a338a91d4e296a32e4a9ea6abac35f7d7e349b9
        ;;
    linux/amd64 )
        chisel_arch=amd64
        archive_sha256=052c4846c57756aadce10024b6cc40ce65c8c7306ad1f458751a05c929e503bf
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

