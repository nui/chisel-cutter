#!/bin/sh

set -ex

target_platform=$1
install_target=$2

gosu_version=1.17
gosu_sha256=""

go_arch=""
case $target_platform in
    linux/arm/v7 )
        go_arch=armhf
        gosu_sha256=e5866286277ff2a2159fb9196fea13e0a59d3f1091ea46ddb985160b94b6841b
        ;;
    linux/arm64 )
        go_arch=arm64
        gosu_sha256=c3805a85d17f4454c23d7059bcb97e1ec1af272b90126e79ed002342de08389b
        ;;
    linux/amd64 )
        go_arch=amd64
        gosu_sha256=bbc4136d03ab138b1ad66fa4fc051bafc6cc7ffae632b069a53657279a450de3
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

