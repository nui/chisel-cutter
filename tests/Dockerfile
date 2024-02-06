ARG rootfs=/rootfs

FROM chisel-cutter as builder
ARG rootfs

WORKDIR $rootfs
RUN chisel cut --release ubuntu-22.04 --root ./ \
    base-files_base \
    base-files_release-info \
    base-passwd_data \
    busybox_bins \
    libgcc-s1_libs \
    tzdata_etc \
    tzdata_eurasia
RUN /cutter/add-user-and-group 1000 nonroot

FROM scratch
ARG rootfs

COPY --from=builder $rootfs /
COPY --from=builder /usr/local/bin/tini /usr/local/bin/tini
RUN ["/bin/busybox", "--install", "-s", "/bin"]
USER nonroot
WORKDIR /home/nonroot
