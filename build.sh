#!/bin/bash

for package in git cmake exuberant-ctags libusb-1.0-0-dev binutils-arm-none-eabi gcc-arm-none-eabi libnewlib-arm-none-eabi dfu-util; do
	dpkg -s $package > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		read -p "$package is not installed, do you wish to install?" yn

    	case $yn in
        	[Yy]* ) sudo apt-get install $package; continue;;
        	[Nn]* ) exit;;
        	* ) echo "Please answer yes or no.";;
    	esac
	fi
done

if [[ ! -e controller/.git ]]; then
    echo "Firmware directory not found. Updating submodules."
    git submodule init
    git submodule update
fi

mkdir -p ICED-L.gcc ICED-R.gcc firmware
cp layout/*.kll ICED-L.gcc/
cp layout/*.kll ICED-R.gcc/
source ./custom_ergodox.bash
cp ICED-L.gcc/kiibohd.dfu.bin firmware/left_kiibohd.dfu.bin
cp ICED-R.gcc/kiibohd.dfu.bin firmware/right_kiibohd.dfu.bin
echo "Done"
echo "Flash using dfu-util -D firmware/left_kiibohd.dfu.bin"
