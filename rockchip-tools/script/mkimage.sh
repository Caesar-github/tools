#!/bin/bash
pause()
{
echo "Press any key to quit:"
read -n1 -s key
exit 1
}

SIGNED="false"
LOADERVERSION="RK31"
PRODUCT="rk30sdk"
BUILD_VARIANT=""
PACK="false"
BACKUP="RESERVED"
UPDATESCRIPT=""
RECOVERSCRIPT=""
THREAD=""
SECURESIGN="false"

while [ $# -gt 0 ]; do
    case $1 in
        --build)
            BUILD_VARIANT=$2
            shift
            ;;

        --sign)
            SIGNED=$2
            shift
            ;;

        --product)
            PRODUCT=$2
            shift
            ;;

        --thread)
            THREAD=$2
            shift
            ;;

        --pack)
            PACK=$2
            shift
            ;;

        --securesign)
            SECURESIGN=$2
            shift
            ;;

        --help)
            echo "Usage: $0 OPTIONS"
            echo "make update.img"
            echo "--build <eng/user>                : build eng or user version"
            echo "--sign <ture/false>               : if we should sign apk"
            echo "--product <product>               : product name, default name is rk30sdk"
            echo "--thread <thread>                 : how many thread you want to use"
            echo "--pack <ture/false>               : just pack, no build, no sign"
            echo "--securesign <ture/false>         : secure boot sign"
            echo "--help                            : show this message"
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

echo "Setting up environment"
set -e
. build/envsetup.sh >/dev/null && setpaths
export PATH=$ANDROID_BUILD_PATHS:$PATH
ROOTDIR=$(gettop)
LOADER="$ROOTDIR/uboot/RK3188Loader_mini.bin"
PARAMETER="$ROOTDIR/tools/parameter/parameter"
RAMDISK_DIR="$ROOTDIR/out/target/product/rk30sdk/root"
KERNEL_IMAGE="$ROOTDIR/kernel/arch/arm/boot/Image"
IMAGE_DIR="$ROOTDIR/rockdev/Image"
RECOVERY_RAMDISK_DIR="$ROOTDIR/out/target/product/rk30sdk/recovery"
RECOVERY_KERNEL_IMAGE="$ROOTDIR/kernel/arch/arm/boot/Image"
SYSTEM_DIR="$ROOTDIR/out/target/product/rk30sdk/system"
CHARGE="$ROOTDIR/uboot/charge.img"
LOADERIMG="$ROOTDIR/uboot/uboot.img"

CMD="$ROOTDIR/tools/script/mkupdateimg.sh --signed $SIGNED --securesign $SECURESIGN --loaderversion $LOADERVERSION --loader $LOADER --parameter $PARAMETER --product $PRODUCT --pack $PACK --ramdiskdir $RAMDISK_DIR --kernelimg $KERNEL_IMAGE --imgdir $IMAGE_DIR --recoveryramdiskdir $RECOVERY_RAMDISK_DIR --recoverykernelimg $RECOVERY_KERNEL_IMAGE --systemdir $SYSTEM_DIR --backup $BACKUP --rootdir $ROOTDIR"

if [ "$THREAD"x != ""x ]; then
CMD="$CMD --thread $THREAD"
fi

if [ "$UPDATESCRIPT"x != ""x ]; then
CMD="$CMD --updatescript $UPDATESCRIPT"
fi

if [ "$RECOVERYSCRIPT"x != ""x ]; then
CMD="$CMD --recoverscript $RECOVERYSCRIPT"
fi

if [ "$CHARGE"x != ""x ]; then
CMD="$CMD --charge $CHARGE"
fi

if [ "$LOADERIMG"x != ""x ]; then
CMD="$CMD --loaderimg $LOADERIMG"
fi

if [ "$BUILD_VARIANT"x != ""x ]; then
CMD="$CMD --build $BUILD_VARIANT"
fi
#echo "$CMD"
$CMD



