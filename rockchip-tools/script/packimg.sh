#!/bin/bash
pause()
{
echo "Press any key to quit:"
read -n1 -s key
exit 1
}

ROOTDIR=""
RAMDISK_DIR=""
KERNEL_IMAGE=""
IMAGE_DIR=""
RECOVERY_RAMDISK_DIR=""
RECOVERY_KERNEL_IMAGE=""
SYSTEM_DIR=""
while [ $# -gt 0 ]; do
    case $1 in
        --ramdiskdir)
            RAMDISK_DIR=$2
            shift
            ;;

        --kernelimg)
            KERNEL_IMAGE=$2
            shift
            ;;

        --imgdir)
            IMAGE_DIR=$2
            shift
            ;;

        --recoveryramdiskdir)
            RECOVERY_RAMDISK_DIR=$2
            shift
            ;;

        --recoverykernelimg)
            RECOVERY_KERNEL_IMAGE=$2
            shift
            ;;

        --systemdir)
            SYSTEM_DIR=$2
            shift
            ;;

        --rootdir)
            ROOTDIR=$2
            shift
            ;;

        --help)
            echo "Usage: $0 OPTIONS"
            echo "pack image"
            echo "--ramdiskdir <ramdiskdir>"
            echo "--kernelimg <kernelimg>"
            echo "--imgdir <imgdir>"
            echo "--recoveryramdiskdir <recoveryramdiskdir>"
            echo "--recoverykernelimg <recoverykernelimg>"
            echo "--systemdir <systemdir>"
            echo "--help "
            echo
            exit 0
            ;;

        *)
            echo "Unknown option $1."
            exit 1
            ;;
    esac
    shift
done


if [ "$RAMDISK_DIR"x != ""x ]; then
echo "create boot.img"
rm -rf $IMAGE_DIR/boot.img
	[ -d $RAMDISK_DIR ] && \
	mkbootfs $RAMDISK_DIR | minigzip > $IMAGE_DIR/ramdisk.img && mkbootimg --kernel $KERNEL_IMAGE \
	--ramdisk $IMAGE_DIR/ramdisk.img --output $IMAGE_DIR/boot.img
echo "done."
fi
if [ "$RECOVERY_RAMDISK_DIR"x != ""x ]; then
echo "create recovery.img"
rm -rf $IMAGE_DIR/recovery.img
	[ -d $RECOVERY_RAMDISK_DIR ] && \
	mkbootfs $RECOVERY_RAMDISK_DIR | minigzip > $IMAGE_DIR/ramdisk-recovery.img && mkbootimg --kernel $RECOVERY_KERNEL_IMAGE \
	--ramdisk $IMAGE_DIR/ramdisk-recovery.img --output $IMAGE_DIR/recovery.img
echo "done."
fi
echo "copy misc.img"
rm -rf $IMAGE_DIR/misc.img
	cp -a $ROOTDIR/rkst/Image/misc.img $IMAGE_DIR/misc.img
echo "done."
if [ -f "$ROOTDIR/uboot/images.img" ]; then
echo "copy charge.img"
rm -rf $IMAGE_DIR/charge.img
cp -a $ROOTDIR/uboot/images.img $IMAGE_DIR/charge.img
echo "done."
fi
if [ "$SYSTEM_DIR"x != ""x ]; then
echo "create system.img"
rm -rf $IMAGE_DIR/system.img
	delta=5120
	num_blocks=`du -sk $SYSTEM_DIR | tail -n1 | awk '{print $1;}'`
	num_blocks=$(($num_blocks + $delta))
	num_inodes=`find $SYSTEM_DIR | wc -l`
	num_inodes=$(($num_inodes + 500))
	ok=0
	while [ "$ok" = "0" ]; do
		genext2fs -a -d $SYSTEM_DIR -b $num_blocks -N $num_inodes -m 0 $IMAGE_DIR/system.img >/dev/null 2>&1 && \
		tune2fs -j -L system -c -1 -i 0 $IMAGE_DIR/system.img >/dev/null 2>&1 && \
		ok=1 || num_blocks=$(($num_blocks + $delta))
	done
	e2fsck -fy $IMAGE_DIR/system.img >/dev/null 2>&1 || true

	delta=1024
	num_blocks=`resize2fs -P $IMAGE_DIR/system.img 2>&1 | tail -n1 | awk '{print $7;}'`
	rm -f $IMAGE_DIR/system.img
	ok=0
	while [ "$ok" = "0" ]; do
		genext2fs -a -d $SYSTEM_DIR -b $num_blocks -N $num_inodes -m 0 $IMAGE_DIR/system.img >/dev/null 2>&1 && \
		tune2fs -O dir_index,filetype,sparse_super -j -L system -c -1 -i 0 $IMAGE_DIR/system.img >/dev/null 2>&1 && \
		ok=1 || num_blocks=$(($num_blocks + $delta))
	done
	e2fsck -fyD $IMAGE_DIR/system.img >/dev/null 2>&1 || true
echo "done."
fi
