#!/bin/bash

echo "$1"
pngtopnm $1 > linuxlogo.pnm 
pnmquant 224 linuxlogo.pnm > linuxlogo224.pnm
pnmtoplainpnm linuxlogo224.pnm > linuxlogo224.ppm
