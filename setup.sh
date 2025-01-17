# Droidian Adaptation for the Xiaomi Pocophone F1 (beryllium)
# https://droidian.org

OUTFD=/proc/self/fd/$1;
VENDOR_DEVICE_PROP=`grep ro.product.vendor.device /vendor/build.prop | cut -d "=" -f 2 | awk '{print tolower($0)}'`;

# ui_print <text>
ui_print() { echo -e "ui_print $1\nui_print" > $OUTFD; }

mkdir /r;

# mount droidian rootfs
mount /data/rootfs.img /r;

# Apply bluetooth fix
ui_print "Applying device adaptations..."
rm -f /r/etc/ofono/ril_subscription.conf
cp -r data/* /r/

# Do "chmod a+c /etc/rc.local" for first boot
chroot /r /bin/bash /local/bin/first-boot.sh

# Changing permissions for extras script
chmod +x /r/usr/local/bin/beryllium-extras.sh

# umount rootfs
umount /r;

# flash boot.img
flash_image /dev/block/bootdevice/by-name/boot boot.img
