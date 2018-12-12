#!/bin/bash
pause()
{
echo "Press any key to quit:"
read -n1 -s key
exit 1
}
echo "Setting up environment"
set -e
. build/envsetup.sh
ROOTDIR=$(gettop)
PRODUCT=$1
if [ "$PRODUCT" = ""  ]; then
echo "error: need product name"
pause
else
echo "product:$PRODUCT"
KEYDIR=$ROOTDIR/vendor/rockchip/security/$PRODUCT
mkdir -p $KEYDIR
cd $ROOTDIR/tools/script
./mkkey.sh platform
mv $ROOTDIR/tools/script/platform.pem $KEYDIR
mv $ROOTDIR/tools/script/platform.pk8 $KEYDIR
mv $ROOTDIR/tools/script/platform.x509.pem $KEYDIR
./mkkey.sh media
mv $ROOTDIR/tools/script/media.pem $KEYDIR
mv $ROOTDIR/tools/script/media.pk8 $KEYDIR
mv $ROOTDIR/tools/script/media.x509.pem $KEYDIR
./mkkey.sh shared
mv $ROOTDIR/tools/script/shared.pem $KEYDIR
mv $ROOTDIR/tools/script/shared.pk8 $KEYDIR
mv $ROOTDIR/tools/script/shared.x509.pem $KEYDIR
./mkkey.sh releasekey
mv $ROOTDIR/tools/script/releasekey.pem $KEYDIR
mv $ROOTDIR/tools/script/releasekey.pk8 $KEYDIR
mv $ROOTDIR/tools/script/releasekey.x509.pem $KEYDIR
cd $ROOTDIR
fi
