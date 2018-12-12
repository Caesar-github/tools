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
if [ "$1"x != ""x  ]; then
	if [  -d "$1" ]; then
		echo "create data.img"
		genext2fs -a -d $1 -b 20000 -N 100 -m 0 rockdev/Image/userdata.img #>/dev/null 2>&1 && \
		tune2fs -O dir_index,filetype,sparse_super -j -L system -c -1 -i 0 rockdev/Image/userdata.img #>/dev/null 2>&1 && \
		echo "done"
	else
		echo "could not find user data dir"
	fi
fi

