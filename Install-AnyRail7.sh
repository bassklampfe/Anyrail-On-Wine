#!/bin/bash

#----------------------------------------------------------------------
# this script does all required steps to install Anyrail on Wine
#----------------------------------------------------------------------

set -e
bash 1.RequiredLinuxPackages.sh
bash 2.PrepareWinePrefix.sh
bash 3.install-update-anyrail.sh
bash 4.make-anyrail-filetypes.sh
echo "*** Install complete ***"