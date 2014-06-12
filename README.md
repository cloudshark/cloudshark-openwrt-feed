# Cloudshark on OpenWrt

## Setup OpenWrt

Setup OpenWrt development environment following [official instructions](http://wiki.openwrt.org/doc/howto/buildroot.exigence).

We will assume it is configured in the ```/opt/openwrt``` directory

## Add CloudShark to OpenWrt

### Add CloudShark feed
    # add to '/opt/openwrt/trunk/feeds.conf'
    src-git cloudshark https://github.com/cloudshark/cloudshark-openwrt-feed.git

    # update and install all feed packages
    cd /opt/openwrt/trunk
    ./scripts/feeds update -a
    ./scripts/feeds install -a

### Select CloudShark package
    make menuconfig
    > Network -> cshark
    > Network -> cshark-luci

## Build and run OpenWrt with CloudShark

### Create x86 image

    # select options in 'make menuconfig'

    > Target System -> x86
    > Subtarget -> Generic
    > Target Profile -> Generic

    # optional if you want VirtualBox image
    > Target Images -> Build VirtualBox image files (VDI)

    # save configuration and build image as usual
    # images will be found in '/opt/openwrt/trunk/bin/x86'

### Run OpenWrt (in qemu)

    # start OpenWrt using bridge 'br0' interface on the host
    cd /opt/openwrt/trunk/bin/x86
    sudo qemu-system-i386 -net nic -net bridge,br=br0 openwrt-x86-generic-combined-ext4.img

## Access CloudShark web interface

    # configure 'lan' interface in '/etc/config/network'
    # set ip address and correct mask for you network
    # or
    # change proto from 'static' to 'dhcp'

    # restart network
    /etc/init.d/network restart

    # open web interface from you host
    http://guest_ip

    # login with root/root

    # access CloudShark section
    > Network -> CloudShark
