FROM registry.redhat.io/rhel8/nginx-118:1-46 as downloader

ARG RH_USERNAME
ARG RH_PASSWORD
ARG VIRTIO_VERSION=1.9.19

USER root

RUN subscription-manager register --username=${RH_USERNAME} --password=${RH_PASSWORD} && \
    dnf install -y virtio-win-${VIRTIO_VERSION}

FROM registry.redhat.io/rhel8/nginx-118:1-46

ENV SUMMARY="KVM Paravirtualized (virtio) Drivers Server via a Web Server" \
    DESCRIPTION="Paravirtualized drivers enhance the performance of guests, \
decreasing guest I/O latency and increasing throughput to near bare-metal levels. \
It is recommended to use the paravirtualized drivers for fully virtualized guests \
running I/O heavy tasks and applications.\
\
virtio drivers are KVM's paravirtualized device drivers,\
available for Windows guest virtual machines running on KVM hosts.\
These drivers are included in the virtio package.\
The virtio package supports block (storage) devices and network interface controllers.\
\
This container expose the KVM virtio drivers are via webserver, to be easily be access over the network." \
    VIRTIO_VERSION=1.9.19 \
    NAME="virtio-win"

LABEL summary="${SUMMARY}" \
    description="${DESCRIPTION}" \
    io.k8s.description="${DESCRIPTION}" \
    io.k8s.display-name="Virtio ${VIRTIO_VERSION}" \
    io.openshift.expose-services="8080:http" \
    io.openshift.expose-services="8443:https" \
    io.openshift.tags="builder,${NAME},${NAME}-${VIRTIO_VERSION}" \
    com.redhat.component="${NAME}-${VIRTIO_VERSION}-container" \
    name="ubi8/${NAME}-${VIRTIO_VERSION}" \
    version="1" \
    com.redhat.license_terms="https://www.redhat.com/en/about/red-hat-end-user-license-agreements#UBI" \
    maintainer="Rabin <rabin@redhat.com>" \
    help="For more information visit https://github.com/rabin/${NAME}-container" \
    usage="TBAL...."

COPY --from=downloader /usr/share/virtio-win /opt/app-root/src

EXPOSE 8080

