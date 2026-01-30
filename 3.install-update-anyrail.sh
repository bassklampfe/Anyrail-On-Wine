#!/bin/bash

#----------------------------------------------------------------------
# this script fetches the newest Anyrail7 version
#----------------------------------------------------------------------

set -e
set -x
STAMP=$(date +%Y%m%d)

DOWNLOADDIR=/tmp/anyrail
mkdir -p "${DOWNLOADDIR}"

#
# get page from website
#
ANYRAIL_PAGE="${DOWNLOADDIR}/www.anyrail.com-$STAMP"
if [ ! -f "${ANYRAIL_PAGE}" ]
then
	curl 'https://www.anyrail.com/' --output "${ANYRAIL_PAGE}.part" -H 'Accept: text/html' -H 'Accept-Language: de,en-US'
	mv "${ANYRAIL_PAGE}.part" "${ANYRAIL_PAGE}"
fi

#
# extract version from webpage
#
ANYRAIL_HREF=$(perl -ne 'm/<a href="([^"]+)">Herunterladen <small>f.*r Windows<\/small><\/a>/ && print "$1\n"' "${ANYRAIL_PAGE}" 2>&1| head -n1)
echo "ANYRAIL_HREF='${ANYRAIL_HREF}'"
ANYRAIL_VERSION="${ANYRAIL_HREF##*/}"
echo "ANYRAIL_VERSION='${ANYRAIL_VERSION}'"

if [ "${ANYRAIL_VERSION}" == "" ]
then
	echo "No Anyrail Version found"
	exit 1
fi

ANYRAIL_MSI="${DOWNLOADDIR}/${ANYRAIL_VERSION}"
echo "ANYRAIL_MSI='${ANYRAIL_MSI}'"

#
# download version 
#
if [ ! -f "${ANYRAIL_MSI}" ]
then
	curl "https://www.anyrail.com/${ANYRAIL_HREF}" --output "${ANYRAIL_MSI}.part"
	mv "${ANYRAIL_MSI}.part" "${ANYRAIL_MSI}"
fi

#
# extract
#
rm -rf "${ANYRAIL_MSI%.msi}"
msiextract --directory "${ANYRAIL_MSI%.msi}" "${ANYRAIL_MSI}"

#
# install
#
export WINEPREFIX="${HOME}/.wine-anyrail"
mkdir -p "${WINEPREFIX}/drive_c/Program Files/AnyRail7"
cp -v "${ANYRAIL_MSI%.msi}/APPDIR:./"* "${WINEPREFIX}/drive_c/Program Files/AnyRail7/"
