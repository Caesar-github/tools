#!/bin/bash
pause()
{
echo "Press any key to quit:"
read -n1 -s key
exit 1
}
echo "Setting up environment"
set -e
. build/envsetup.sh >/dev/null && setpaths
export PATH=$ANDROID_BUILD_PATHS:$PATH
ROOTDIR=$(gettop)
PRODUCT=$1
if [ "$PRODUCT" = ""  ]; then
echo "error: need product name"
pause
else
echo "product:$PRODUCT"
make otapackage -j16
TARGET_FILE=$(find $ROOTDIR/out/target/product/$PRODUCT/obj/PACKAGING/target_files_intermediates/ -name "$PRODUCT-target_files*.zip")
echo "target file:$TARGET_FILE"
rm -rf $ROOTDIR/tools/script/tmp
mkdir -p $ROOTDIR/tools/script/tmp
$ROOTDIR/build/tools/releasetools/sign_target_files_apks -d $ROOTDIR/vendor/rockchip/security/$PRODUCT $TARGET_FILE $ROOTDIR/tools/script/tmp/signed-target-files.zip
#build/target/product/security/privateKey.bin
$ROOTDIR/build/tools/releasetools/ota_from_target_files $ROOTDIR/tools/script/tmp/signed-target-files.zip $ROOTDIR/rockdev/Image/update.zip
rm -rf $ROOTDIR/tools/script/tmp
fi


