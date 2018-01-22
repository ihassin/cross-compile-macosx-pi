#!/bin/sh
# 
# File:   pi.sh
# Author: ita
#
# Created on Jan 21, 2018, 5:19:28 PM
#
echo "Copying file"
scp "dist/Debug/GNU-Pi-MacOSX/welcome_1" pi@pi:~
echo "Running file"
ssh pi@pi -C "./welcome_1"
