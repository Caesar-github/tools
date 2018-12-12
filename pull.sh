#!/bin/bash

#git init
##update gerrit
cd /home/wxt/work/tools/gerrit
git fetch origin -p

##update AndroidScreencast
cd /home/wxt/work/tools/AndroidScreencast
git fetch origin -p

#update smatch
cd /home/wxt/work/tools/smatch
git fetch origin -p
