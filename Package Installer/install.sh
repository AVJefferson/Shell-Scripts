#!/bin/bash

##SETUP CONFIGURATION

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

# LINUX and APT UPGRADATIONS
upgradeApt=true
upgradeLinux=false

# SNAP STORE REMOVAL
purgeSnap=false
purgeGnomeStore=false

# PACKAGE INSTALLATION
p_manager="aptitude" # Note that apt and aptitude handles regular expressions differently
p_installcmd="install -y"
p_uninstall_cmd="purge -y"

conf="pkg.list"
installPkgs=true

showNMessage=true # N selected commands in .config are not displayed
notifySend=true   # Show Alert Message after completion

# Allowed Commands in $conf file
declare -A conf_cmds
conf_cmds=(["I"]="$p_manager $p_installcmd" ["P"]="$p_manager $p_uninstall_cmd")
conf_cmts=(["I"]="Installing" ["P"]="Removing" ["N"]="Not" ["Y"]="")

# CHECKING FOR ROOT PERMISSION
printText "Linux Package Installer Script - User Id: $EUID"
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
if [ $p_manager != "apt" ]; then
  printText "\nInstalling Required Package Manager $PKG_color$p_manager"
  sudo apt install $p_manager
fi

# SNAP AND GNOME-STORE
if $purgeSnap; then
  printText "\n Removing snap Packages"
  sudo snap remove firefox -y
  sudo snap remove snap-store -y
  sudo snap remove gtk-common-themes -y
  sudo snap remove gnome-3-34-1804 -y
  sudo snap remove core18 -y
  sudo snap remove gnome-3-38-2004 -y
  sudo snap remove core20 -y
  sudo snap remove core -y
  sudo snap remove bare -y
  sudo snap remove * -y

  printText "\n Removing snapd"
  sudo rm -rf /var/cache/snapd/
  sudo $p_manager purge snap snapd gnome-software-plugin-snap -y
  sudo rm -rf ~/snap

  printText "Blocking snap"
  sudo apt-mark hold snap snapd gnome-software-plugin-snap

  if $purgeGnomeStore; then
    printText "\n Removing gnome-store"
    sudo $p_manager purge gnome-software* -y
  else
    printText "\n Re-Installing gnome-store"
    sudo $p_manager install gnome-software -y
  fi
fi

# LOOP (UN)INSTALLING PACKAGES (from $conf)

# # To edit the configuration file before executing it
# printText "\nOpening configuration file"
# sudo gedit $conf
# printText "\nUsing the latest configuration file"

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

      if [ $cmd == "I" ]; then
        echo_cmd="Installing"
        p_cmd="install"
      elif [ $cmd == "P" ]; then
        echo_cmd="Removing"
        p_cmd="purge"
      elif [ $cmd == "C" ]; then
        printText $pkg
        continue
      fi

      printText "$echo_cmd $PKG_color$pkg"
      sudo $p_manager $p_cmd $pkg -y
      ;;

    [Nn]*)
      if $showNMessage; then
        if [ $yn == "Y" ]; then
          yn="N"
        fi

        cmd=${line:2:1}
        pkg=${line:4}

        if [ $cmd == "I" ]; then
          printFail "Not Installing\t$PKG_color$pkg"
        elif [ $cmd == "P" ]; then
          printFail "Not Removing\t$PKG_color$pkg"
        fi
      fi
      ;;
    *) ;;
    esac
  done <$conf
fi

# CLEANING UP UNWANTED PACKAGES
printText "\nCleaning Up"
sudo apt autoremove -y
sudo apt autoclean -y
echo ""

if $notifySend; then
  notify-send -u normal "Shell Installation Complete"
fi
