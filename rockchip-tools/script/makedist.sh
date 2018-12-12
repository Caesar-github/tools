#!/bin/bash
pause()
{
echo "Press any key to quit:"
read -n1 -s key
exit 1
}
PRODUCT=$1
BUILD_VARIANT=""
THREAD=""

if [ "$PRODUCT" = ""  ]; then
echo "error: need product name"
pause
fi

if [ "$2" = "eng"  ]; then
BUILD_VARIAN="eng"
elif [ "$2" = "user"  ]; then
BUILD_VARIAN="user"
else
BUILD_VARIAN=""
fi

CMD="make PRODUCT-$PRODUCT-$BUILD_VARIAN dist"
if [ "$UPDATESCRIPT"x != ""x ]; then
CMD="$CMD --updatescript $UPDATESCRIPT"
fi
if [ "$3"x != ""x ]; then
CMD="$CMD -j$3"
fi
echo "$CMD"
$CMD


