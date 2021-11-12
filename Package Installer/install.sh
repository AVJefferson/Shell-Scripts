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
# LINUX and APT UPGRADATIONS
upgradeApt=true
upgradeLinux=true

# SNAP STORE REMOVAL
purgeSnap=true
purgeGnomeStore=false

# PACKAGE INSTALLATION
p_mgr="aptitude" # Note that apt and aptitude handles regular expressions differently
add_repos="add-apt-repository"

configFile="pkg.list"
installPkgs=false

showNMessage=true # N selected commands in $configFile are not displayed
notifySend=true   # Show Alert Message after completion

# Allowed Commands in $configFile
declare -A conf_cmds
conf_cmds[I]="$p_mgr install -y"
conf_cmds[P]="$p_mgr purge -y"
conf_cmds[R]="$add_repos -y"
conf_cmds[U]="$p_mgr update"

# Comments to be used for each command
declare -A conf_cmts
conf_cmts["I"]="Installing"
conf_cmts["P"]="Removing"
conf_cmts["R"]="Adding repo"

#* EXECUTION BEGINS HERE
# CHECKING FOR ROOT PERMISSION
printText "Linux Package Installer Script"
if [ $EUID != "0" ]; then
  printFail "This script must be run with root privilages\n"
  exit 1
fi

# UPDATING EVERYTHING AND GETTING READY
printText "Update apt"
sudo apt update -y

if $upgradeApt; then
  printText "\nUpgrade apt"
  sudo apt upgrade -y
fi

if $upgradeLinux; then
  printText "\nUpdating Linux"
  sudo apt full-upgrade -y
fi

# INSTALLING REQUIRED PACKAGE MANAGER (if necessary)
if [ $p_mgr != "apt" ]; then
  printText "\nInstalling Required Package Manager $PKG_color$p_mgr"
  sudo apt install $p_mgr
  echo ""
fi

# SNAP AND GNOME-STORE
if $purgeSnap; then
  printText "\nRemoving snapd and all snap packages"
  sudo rm -rf /var/cache/snapd/
  sudo $p_mgr purge snap snapd gnome-software-plugin-snap -y
  sudo rm -rf ~/snap

  printText "Blocking snap"
  sudo apt-mark hold snap snapd gnome-software-plugin-snap

  if $purgeGnomeStore; then
    printText "\nRemoving gnome-store"
    sudo $p_mgr purge gnome-software* -y
  else
    printText "\nRe-Installing gnome-store"
    sudo $p_mgr install gnome-software -y
  fi
fi

# LOOP (UN)INSTALLING PACKAGES (from $configFile)

# # To edit the configuration file before executing it
# printText "\nOpening configuration file"
# sudo gedit $configFile

yn="N" # Consecutive Ns and Ys are clubbed.
if $installPkgs; then
  while IFS= read -r line; do
    case $line in
    [Yy]*)
      if [ $yn == "N" ]; then
        echo ""
        yn="Y"
      fi

      cmd=${line:2:1}
      pkg=${line:4}

      printText "${conf_cmts[$cmd]} $PKG_color$pkg"
      sudo ${conf_cmds[$cmd]} $pkg
      ;;

    [Nn]*)
      if $showNMessage; then
        if [ $yn == "Y" ]; then
          yn="N"
        fi

        cmd=${line:2:1}
        pkg=${line:4}

        printFail "Not ${conf_cmts[$cmd]}\t$PKG_color$pkg"
      fi
      ;;
    *) ;;
    esac
  done <$configFile
fi

# CLEANING UP UNWANTED PACKAGES
printText "\nCleaning Up"
sudo apt autoremove -y
sudo apt autoclean -y
echo ""

# NOTIFICATION FOR COMPLETION
if $notifySend; then
  notify-send -u normal "Shell Installation Complete"
fi
