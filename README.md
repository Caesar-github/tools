# tools

1. smatch:
make

##install the .so
sudo apt-get install libsqlite3-dev

##check
cd ~/kernel/src/
~/smatch/smatch_scripts/kchecker xxx (drivers/thermal/rockchip_thermal.c) ARCH=arm

2. git
sudo apt-get install libcurl4-gnutls-dev

make prefix=/usr/local all
sudo make prefix=/usr/local install

reboot


3. rootfs

1) How to unpack the initram.cpio?

cat  initramfs.cpio |cpio -i

2) How to re-generate the initram.cpio

find .|cpio -o -H newc > initramfs.cpio

4. java-switch.sh
./java_switch.sh jdk6
./java_switch.sh jdk7
...

5. repo
curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/work/tools/repo/repo
chmod a+x repo
PATH=~/work/tools/repo/repo:$PATH

5. synergy
##view the setting
set the client/server name, the same with the hostname

6. build-kernel:
build kernel rockchip platform
