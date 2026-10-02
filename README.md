# Anyrail-On-Wine

A collection of shell scripts to install Anyrail7 on an Ubuntu based linux hosts with wine in a separate wine prefix.

## Installation

After downloading the whole repository (either with git or as zip archive), just run in terminal window in extraction folder  
`bash Install-AnyRail7.sh`  
then enter your password (required only to install required additional packages)  
  
NOTE: If you haven't had a bin folder in your home before, you will have to relogin once after installation.

## Known issues with Anyrail with wine

- Export of 3D-View to graphic renders only black on black images
- On exit Anyrail occasionally crashes (Mostly, when 3D-View is open, so please switch to 2D-View before closing the program)
- Save location of Tracks is not remembered
- not all filemanagers will show anyrail icon on *.any files (trouble with mimetypes)

## Tested on

- Ubuntu 24.04 with wine-9.0
- Mint 22 with wine-9.0
- Mint 22 with wine-11

- wine-5.0 seems to be to old, nothing to see in 3D-View

## Not tested (yet)

- Registration : You'll have to obtain a regular license at https://www.anyrail.com/
- Update via Anyrail tool. Instead of using the update you should repeat  
  `bash 3.install-update-anyrail.sh`

