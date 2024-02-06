FROM alpine
ARG TARGETPLATFORM

RUN apk add --update bash curl

RUN --mount=type=bind,source=/docker/scripts/,target=/scripts/ \
    /scripts/install-chisel.sh $TARGETPLATFORM /usr/local/bin/chisel \
    && /scripts/install-tini.sh $TARGETPLATFORM /usr/local/bin/tini

COPY cutter/ /cutter/

