
# virtio-win Container

This project will guide you how to create a simple container which include the virtio drivers for Windows.
and expose it over `http://` to the cluser.


## Build you own container

* Clone this repo
* You will need to download the `virtio-win.rpm` manually (should be on the same folder)
  * Fedora:
  * RedHat: https://access.redhat.com/downloads

```bash
$ ls -l
total 180M
-rw-r--r--. 1 rabin rabin 1.8K Nov 11 16:35 Containerfile
-rw-r--r--. 1 rabin rabin 2.5K Nov 11 16:35 nginx.conf
-rw-------. 1 rabin rabin  570 Nov 11 16:35 README.md
-rw-r--r--. 1 rabin rabin 180M Nov 11 15:23 virtio-win-1.9.19-1.el8.noarch.rpm

$ podman build --build-arg RPM_FILE="virtio-win-1.9.19-1.el8.noarch.rpm" -t virtio-win .
```

* Push the image to a registry which is accessable for the cluster

```bash
podman push virtio-win docker://quay.io/myrepo/virtio-win:1.9.19
```

* Run the container from Openshift

```bash
oc new-porject virtio-win
oc new-app --docker-image=quay.io/myrepo/virtio-win:1.9.19 --name=virtio-vin

--> Found container image 646d659 (About an hour old) from quay.io for "quay.io/myrepo/virtio-win:1.9.19"

    Virtio 1.9.19
    -------------
    Paravirtualized drivers enhance the performance of guests, decreasing guest I/O latency and increasing throughput to near bare-metal levels. It is recommended to use the paravirtualized drivers for fully virtualized guests running I/O heavy tasks and applications.virtio drivers are KVM's paravirtualized device drivers,available for Windows guest virtual machines running on KVM hosts.These drivers are included in the virtio package.The virtio package supports block (storage) devices and network interface controllers.This container expose the KVM virtio drivers are via webserver, to be easily be access over the network.

    Tags: builder, virtio-win, virtio-win-1.9.19

    * An image stream tag will be created as "virtio-win:1.9.19" that will track this image

--> Creating resources ...
    imagestream.image.openshift.io "virtio-win" created
    deployment.apps "virtio-win" created
    service "virtio-win" created
--> Success
    WARNING: No container image registry has been configured with the server. Automatic builds and deployments may not function.
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose service/virtio-win'
    Run 'oc status' to view your app.

```

* Expose the service

```bash
$ $ oc expose service/virtio-win --name=virtio-win
route.route.openshift.io/virtio-win exposed
```

```bash
$ oc get routes
NAME         HOST/PORT                         PATH   SERVICES     PORT       TERMINATION   WILDCARD
virtio-win   virtio-win.apps.ocp.example.com          virtio-win   8080-tcp                 None
```
