#!/bin/bash

if [ -e "/etc/udev/rules.d/70-rusefi.rules" ]; then
    echo "creating udev rules"
    cat >/etc/udev/rules.d/70-rusefi.rules <<EOL
SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", GROUP="docker"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", GROUP="docker"
EOL
    sudo service udev restart

else
    echo "skipping, udev rules already installed"

fi
