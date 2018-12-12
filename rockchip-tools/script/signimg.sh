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
SIGNED_TARGET_FILE=$ROOTDIR/rockdev/Image/signed-target-files.zip
SIGNED_IMAGE=$ROOTDIR/rockdev/Image/signed-img.zip
echo "signed target file:$SIGNED_TARGET_FILE"
echo "signed image:$SIGNED_IMAGE"

if [ ! -f "$SIGNED_TARGET_FILE" ]
then
echo "error: need singed target file"
pause
fi
rm -rf $SIGNED_IMAGE
$ROOTDIR/build/tools/releasetools/img_from_target_files $SIGNED_TARGET_FILE $SIGNED_IMAGE



