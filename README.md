# chisel-cutter

Base image for building `distroless` docker image using [chisel](https://github.com/canonical/chisel)

This is repository for [ghcr.io/nui/chisel-cutter](https://github.com/nui/chisel-cutter/pkgs/container/chisel-cutter) image which you can use as base image as following `Dockerfile`

```Dockerfile
ARG rootfs=/rootfs

# step 1: build root filesystem
FROM ghcr.io/nui/chisel-cutter:main as builder

ARG rootfs
WORKDIR $rootfs
RUN chisel cut \
        --release ubuntu-22.04 \
        --root $rootfs  \
        base-files_base \
        base-files_release-info \
        base-passwd_data \
        busybox_bins \
        libgcc-s1_libs \
        tzdata_etc \
        tzdata_eurasia
# /cutter directory contains help script for working with distroless image
RUN /cutter/add-user-and-group 1000 nonroot

# step 2: copy generated filesystem as a root filesystem for scratch image
FROM scratch
ARG rootfs
# copy everything create by chisel as new root filesystem
COPY --from=builder /rootfs /
```


## How to build this image locally

```sh
docker build -t chisel-cutter --platform linux/amd64 -f docker/Dockerfile .
```
