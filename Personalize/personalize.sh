#!/bin/bash

# AVAILABLE COLOR CODES
Black="\033[0;30m"
Dark_Gray="\033[1;30m"
Red="\033[0;31m"
Light_Red="\033[1;31m"
Green="\033[0;32m"
Light_Green="\033[1;32m"
Brown_Orange="\033[0;33m"
Yellow="\033[1;33m"
Blue="\033[0;34m"
Light_Blue="\033[1;34m"
Purple="\033[0;35m"
Light_Purple="\033[1;35m"
Cyan="\033[0;36m"
Light_Cyan="\033[1;36m"
Light_Gray="\033[0;37m"
White="\033[1;37m"
Clear_color="\033[0m"

# USED COLOR SCHEMES
Text_color=$Green     # Comment Color
Fail_color=$Red       # Fail Color
PKG_color=$Light_Blue # Highlight Color

function printText {
    echo -e "$Text_color$1$Clear_color"
}

function printFail {
    echo -e "$Fail_color$1$Clear_color"
}

#* SETUP CONFIGURATION
# Copy Config Files to location

#* EXECUTION BEGINS HERE
