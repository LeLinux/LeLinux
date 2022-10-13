#!/bin/bash
mkdir lelinux
cd lelinux
cp ../lubuntu-22.04-desktop-amd64.iso .
mkdir mnt
mount -o loop lubuntu-22.04-desktop-amd64.iso mnt
mkdir extract-cd
rsync --exclude=/casper/filesystem.squashfs -a mnt/ extract-cd
unsquashfs mnt/casper/filesystem.squashfs
mv squashfs-root edit
cp /etc/resolv.conf edit/etc/
mount -o bind /run/ edit/run
cp /etc/hosts edit/etc/
cp /etc/apt/sources.list edit/etc/apt/sources.list
mount --bind /dev/ edit/dev
chroot edit /bin/bash << "EOT"
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts
export HOME=/root
export LC_ALL=C
dbus-uuidgen > /var/lib/dbus/machine-id
dpkg-divert --local --rename --add /sbin/initctl
ln -s /bin/true /sbin/initctl
apt-get update
sudo apt-get install openbox jgmenu mate-media polybar nemo picom xfce4-terminal plank -y
sudo apt-get install vim -y
sudo apt-get remove compiz pcmanfm-qt lxqt-session -y
cd /usr/share/xsessions/
cp openbox.desktop Lubuntu.desktop
cp openbox.desktop lxqt.desktop
EOT
mkdir edit/etc/skel/.config
mkdir edit/etc/skel/.config/openbox
mkdir edit/etc/skel/.config/polybar
cp /home/system/configs_lelinux/openbox/autostart edit/etc/skel/.config/openbox/
cp /home/system/configs_lelinux/polybar/config edit/etc/skel/.config/polybar/
cp /home/system/configs_lelinux/polybar/cal.sh edit/etc/skel/.config/polybar/
chroot edit

