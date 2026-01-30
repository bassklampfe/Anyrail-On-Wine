#!/bin/bash

#----------------------------------------------------------------------
# this script prepares a seperate wineprefix for running 
# AnyRail on Linux using wine
#----------------------------------------------------------------------

export WINEPREFIX="${HOME}/.wine-anyrail"
rm -rf "${WINEPREFIX}"
wineboot -u
winetricks --unattended win10 gdiplus d3dcompiler_47
