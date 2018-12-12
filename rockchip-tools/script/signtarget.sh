#!/bin/bash
pause()
{
echo "Press any key to quit:"
read -n1 -s key
exit 1
}

ROOTDIR=""
KEYDIR=""
SRC=""
TARGET=""
while [ $# -gt 0 ]; do
    case $1 in
        --rootdir)
            ROOTDIR=$2
            shift
            ;;

        --keydir)
            KEYDIR=$2
            shift
            ;;

        --src)
            SRC=$2
            shift
            ;;

        --target)
            TARGET=$2
            shift
            ;;

        --help)
            echo "Usage: $0 OPTIONS"
            echo "make sign target file"
            echo "--help                : show this message"
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


#find $ROOTDIR/out/dist/ -name "$PRODUCT-target_files*.zip"
#SIGN_TARGET_FILE=$(find $ROOTDIR/out/dist/ -name "$PRODUCT-target_files*.zip")
#SIGN_TARGET_FILE=ls $ROOTDIR/out/dist/$PRODUCT-target_files*.zip
#echo "sign target file:$SIGN_TARGET_FILE"
$ROOTDIR/build/tools/releasetools/sign_target_files_apks -d $KEYDIR $SRC $TARGET



