#!/bin/bash
set -eu
ROOTFS_DIR=$1

function setup_openwrt()
{
# dist
    mkdir -p ./run  # for overlayfs ramdisk

    [ -f ./etc/config/luci_statistics ] && sed -i '/collectd_thermal/{n;s/0/1/;}' ./etc/config/luci_statistics
    [ -f ./etc/config/luci_statistics ] && sed -i '/collectd_uptime/{n;s/0/1/;}' ./etc/config/luci_statistics

    [ -d ./etc/triggerhappy/triggers.d ] && echo 'BTN_1 1 /sbin/reboot' >> ./etc/triggerhappy/triggers.d/example.conf

    # disable uci_rollback for change ap to sta with 192.168.2.1
    sed -i 's/uci_apply(true)/uci_apply(false)/' ./usr/lib/lua/luci/view/footer.htm

    # rom version
    DATE=$(date +%Y%m%d)
    echo "${DATE}" >./etc/rom-version
}

(cd ${ROOTFS_DIR} && {
	setup_openwrt
})
