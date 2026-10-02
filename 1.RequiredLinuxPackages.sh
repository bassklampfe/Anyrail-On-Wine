#!/bin/bash

#----------------------------------------------------------------------
# this script installs all packages required for Anyrail on Wine
#----------------------------------------------------------------------
TEST_INSTALL="apt-get -q -q -q --simulate --no-install-recommends install"
#
# check if wine is already installed
#
wine_found=$(which wine)
if [ "${wine_found}" != "" ]
then
	echo "wine already installed as '${wine_found}'"
else
	#
	# try to find out, which wine version is available
	#
	if ${TEST_INSTALL} wine >& /dev/null ; then which_wine=wine ; fi
	if ${TEST_INSTALL} wine-stable >& /dev/null ; then which_wine=wine-stable ; fi
	if [ "$which_wine" == "" ]
	then
		echo "No installable wine found"
		exit 1
	fi
	echo "installing ${which_wine}"
fi

sudo apt update
sudo apt install \
	$which_wine \
	winetricks \
	msitools \
	icoutils \
	curl \
	imagemagick \
