#!/bin/bash
pause()
{
echo "Press any key to quit:"
read -n1 -s key
exit 1
}

SIGNED=""
LOADERVERSION=""
LOADER=""
LOADERIMG=""
PARAMETER=""
PRODUCT=""
BUILD_VARIANT=""
PACK=""
ROOTDIR=""
RAMDISK_DIR=""
KERNEL_IMAGE=""
IMAGE_DIR=""
RECOVERY_RAMDISK_DIR=""
RECOVERY_KERNEL_IMAGE=""
SYSTEM_DIR=""
BACKUP=""
UPDATESCRIPT=""
RECOVERSCRIPT=""
CHARGE_IMG=""
THREAD=""
UNZIP=""
SKIP_BUILD="false"
SECURESIGN=""
while [ $# -gt 0 ]; do
    case $1 in
        --signed)
            SIGNED=$2
            shift
            ;;

        --securesign)
            SECURESIGN=$2
            shift
            ;;

        --rootdir)
            ROOTDIR=$2
            shift
            ;;

        --loaderversion)
            LOADERVERSION=$2
            shift
            ;;

        --loader)
            LOADER=$2
            shift
            ;;

        --loaderimg)
            LOADERIMG=$2
            shift
            ;;

        --parameter)
            PARAMETER=$2
            shift
            ;;

        --product)
            PRODUCT=$2
            shift
            ;;

        --build)
            BUILD_VARIANT=$2
            shift
            ;;

        --pack)
            PACK=$2
            shift
            ;;

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

        --backup)
            BACKUP=$2
            shift
            ;;

        --updatescript)
            UPDATESCRIPT=$2
            shift
            ;;

        --recoverscript)
            RECOVERSCRIPT=$2
            shift
            ;;

        --charge)
            CHARGE_IMG=$2
            shift
            ;;

        --thread)
            THREAD=$2
            shift
            ;;

        --help)
            echo "Usage: $0 OPTIONS"
            echo "make update.img"
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

ZIP_DIR=$ROOTDIR/tools/ImageMaker/ZIP

if [ "$PACK" = "true" ]; then
RAMDISK_DIR=$ROOTDIR/out/target/product/$PRODUCT/root
KERNEL_IMAGE=$ROOTDIR/kernel/kernel.img
RECOVERY_RAMDISK_DIR=$ROOTDIR/out/target/product/$PRODUCT/recovery/root
RECOVERY_KERNEL_IMAGE=$ROOTDIR/kernel/kernel.img
SYSTEM_DIR=$ROOTDIR/out/target/product/$PRODUCT/system
PACK="true"
SKIP_BUILD="true"
fi

if [ "$SKIP_BUILD" = "false" ]; then
	if [ "$BUILD_VARIANT"x != ""x ]; then
	rm -rf $ROOTDIR/out/dist/tost7t-target_files*.zip
	$ROOTDIR/tools/script/makedist.sh $PRODUCT $BUILD_VARIANT $THREAD
	SIGNED_TARGET_FILE=$(find $ROOTDIR/out/dist/ -name "$PRODUCT-target_files*.zip")
	UNZIP="true"
	fi

	if [ "$SIGNED" = "true" ]; then
	TARGET_FILE=$(find $ROOTDIR/out/dist/ -name "$PRODUCT-target_files*.zip")
	echo "TARGET_FILE:$TARGET_FILE"
	SIGNED_TARGET_FILE=$ROOTDIR/rockdev/Image/signed-target-files.zip
	$ROOTDIR/tools/script/signtarget.sh --rootdir $ROOTDIR --keydir $ROOTDIR/vendor/rockchip/security/$PRODUCT --src $TARGET_FILE --target $SIGNED_TARGET_FILE
	UNZIP="true"
	fi

	if [ "$UNZIP" = "true" ]; then
	echo "unzip $SIGNED_TARGET_FILE"
	rm -rf ZIP_DIR=$ROOTDIR/tools/ImageMaker/ZIP
	unzip $SIGNED_TARGET_FILE -d $ZIP_DIR -o
	# >/dev/null 2>&1 
	echo "done."
	RAMDISK_DIR=$ZIP_DIR/BOOT/RAMDISK
	KERNEL_IMAGE=$ZIP_DIR/BOOT/kernel
	RECOVERY_RAMDISK_DIR=$ZIP_DIR/RECOVERY/RAMDISK
	RECOVERY_KERNEL_IMAGE=$ZIP_DIR/RECOVERY/kernel
	mv $ZIP_DIR/SYSTEM $ZIP_DIR/system
	SYSTEM_DIR=$ZIP_DIR/system
	PACK="true"
	fi
fi

if [ "$PACK" = "true" ]; then
$ROOTDIR/tools/script/packimg.sh --ramdiskdir $RAMDISK_DIR --kernelimg $KERNEL_IMAGE --imgdir $IMAGE_DIR --recoveryramdiskdir $RECOVERY_RAMDISK_DIR --recoverykernelimg $RECOVERY_KERNEL_IMAGE --systemdir $SYSTEM_DIR --rootdir $ROOTDIR
fi

rm -rf $ROOTDIR/tools/ImageMaker/image
mkdir $ROOTDIR/tools/ImageMaker/image
echo "prepare image"
cp $LOADER $ROOTDIR/tools/ImageMaker/image/loader.bin
cp $PARAMETER $ROOTDIR/tools/ImageMaker/image/parameter
cp $IMAGE_DIR/misc.img $ROOTDIR/tools/ImageMaker/image/misc.img
cp $IMAGE_DIR/boot.img $ROOTDIR/tools/ImageMaker/image/boot.img
cp $IMAGE_DIR/recovery.img $ROOTDIR/tools/ImageMaker/image/recovery.img
cp $IMAGE_DIR/system.img $ROOTDIR/tools/ImageMaker/image/system.img
echo "done"

if [ "$SECURESIGN" = "true" ]; then
	SECUREPUBLICKEY="$ROOTDIR/tools/SecureBootConsole/publicKey.bin"
	SECUREPRIVATEKEY="$ROOTDIR/tools/SecureBootConsole/privateKey.bin"
	if [ ! -f "$SECUREPUBLICKEY" ]; then
	$ROOTDIR/tools/SecureBootConsole/SecureBootConsole -k $ROOTDIR/tools/SecureBootConsole/
	fi
	echo "secure sign loader"
	$ROOTDIR/tools/SecureBootConsole/SecureBootConsole -sl $SECUREPUBLICKEY $ROOTDIR/tools/ImageMaker/image/loader.bin
	echo "secure sign boot"
	$ROOTDIR/tools/SecureBootConsole/SecureBootConsole -si $SECUREPRIVATEKEY $ROOTDIR/tools/ImageMaker/image/boot.img
	echo "secure sign recovery"
	$ROOTDIR/tools/SecureBootConsole/SecureBootConsole -si $SECUREPRIVATEKEY $ROOTDIR/tools/ImageMaker/image/recovery.img
	
fi

CMD="$ROOTDIR/tools/ImageMaker/packupdateimg.sh --loaderversion $LOADERVERSION --loader $LOADER --parameter $PARAMETER --misc $IMAGE_DIR/misc.img --boot $IMAGE_DIR/boot.img --recovery $IMAGE_DIR/recovery.img --system $IMAGE_DIR/system.img --backup $BACKUP --target $IMAGE_DIR/update.img --imagemaker $ROOTDIR/tools/ImageMaker --rootdir $ROOTDIR"

if [ "$CHARGE_IMG"x != ""x ]; then
CMD="$CMD --charge $CHARGE_IMG"
fi

if [ "$LOADERIMG"x != ""x ]; then
CMD="$CMD --loaderimg $LOADERIMG"
fi

if [ "$UPDATESCRIPT"x != ""x ]; then
CMD="$CMD --updatescript $UPDATESCRIPT"
fi

if [ "$RECOVERYSCRIPT"x != ""x ]; then
CMD="$CMD --recoverscript $RECOVERYSCRIPT"
fi
#echo "$CMD"
$CMD


