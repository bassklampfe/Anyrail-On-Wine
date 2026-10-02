#!/bin/bash

#----------------------------------------------------------------------
# this script creates file types and Desktop starters for Anyrail
#----------------------------------------------------------------------


set -e


find ${HOME}/.local/share -name "anyrail*" -delete

export WINEPREFIX="${HOME}/.wine-anyrail"
ICONDIR=/tmp/Icons
rm -rf ${ICONDIR}/*
mkdir -p ${ICONDIR}

wrestool -x "--output=${ICONDIR}/" -t14 "${WINEPREFIX}/drive_c/Program Files/AnyRail7/AnyRail7.exe"
(
	cd ${ICONDIR} 
	rm -f *.png
	convert AnyRail7.exe_14_APPICON_1_0.ico -set filename:mysize "anyrail-anyrail7-%wx%h" "%[filename:mysize].png"
	rm -f *.ico
	
	for png in *{16,32,64}*.png
	do
		echo "png='${png}'"
		name=$(basename "${png}" ".png")
		size=$(convert "${png}" -print "%w" /dev/null)
		item=${name%-*}
		echo "name='${name}' item='${item}' size='${size}'"
		xdg-icon-resource install --mode user --size ${size} ${png} ${item}
		xdg-icon-resource install --context mimetypes --mode user --size ${size} ${png} ${item}
	done

)


#----------------------------------
# define bin file file
#----------------------------------
echo "-- create application script --"
mkdir -p ~/bin
cat  << '-EOF-' > ~/bin/AnyRail7
#!/bin/bash
export WINEPREFIX="${HOME}/.wine-anyrail"
any=$(realpath "$1")
echo "any='$any'"
if [ -f "$any" ]
then
	cd $(dirname "$any")
	exec wine "C:/Program Files/AnyRail7/AnyRail7.exe" "$(basename "$any")"
	exit
fi
exec wine "C:/Program Files/AnyRail7/AnyRail7.exe"
-EOF-
chmod +x ~/bin/AnyRail7
#----------------------------------
# define desktop file
#----------------------------------
echo "-- create application type --"
cat  << -EOF- > /tmp/anyrail-anyrail7.desktop
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
MimeType=application/anyrail-anyrail7-any;
Exec=AnyRail7 %F
Terminal=false
Icon=anyrail-anyrail7
Name=AnyRail7
-EOF-
chmod +x /tmp/anyrail-anyrail7.desktop

sha256sum=$(sha256sum "/tmp/anyrail-anyrail7.desktop"|perl -pe 's/ .*//')
echo "sha256sum='${sha256sum}'"
#gio set "$desktop" 'metadata::trusted' TRUE
gio set "/tmp/anyrail-anyrail7.desktop" 'metadata::xfce-exe-checksum' "${sha256sum}"

xdg-desktop-menu install --mode user /tmp/anyrail-anyrail7.desktop

DESKTOP=$(xdg-user-dir DESKTOP)
cp /tmp/anyrail-anyrail7.desktop ${DESKTOP}/


#----------------------------------
# define mime type with icon
#----------------------------------
echo "-- create mime type --"
cat << -EOF- > /tmp/anyrail-anyrail7-any.xml
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="application/anyrail-anyrail7-any">
	<comment>AnyRail7</comment>
	<glob pattern="*.any"/>
	<icon name="anyrail-anyrail7"/>
  </mime-type>
</mime-info>
-EOF-
xdg-mime install --mode user /tmp/anyrail-anyrail7-any.xml
update-mime-database ~/.local/share/mime
