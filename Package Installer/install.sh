#!/bin/bash

##SETUP CONFIGURATION

# AVAILABLE COLOR CODES
Black="\033[0;30m"
Dark_Gray="\033[1;30m"
Red="\033[0;31m"
Light Red="\033[1;31m"
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
Text_color=$Green
Fail_color=$Red
PKG_color=$Blue


# LINUX and APT UPGRADATIONS
upgradeLinux=false
upgradeApt=true

# SNAP STORE REMOVAL
purgeSnap=false
purgeGnomeStore=false

# PACKAGE INSTALLATION
p_manager="aptitude" # Note that apt and aptitude handles regular expressions differently
conf="pkg.list"
showNMessage=true # N selected commands in .config are not displayed

# todo CREATING A SNAPSHOT OF EXISTING PACKAGES
#sudo apt list --installed >

# UPDATING EVERYTHING AND GETTING READY
echo -e $Text_color "Linux Install From Config File" $Clear_color
sudo echo # Asking for sudo permissions
echo -e $Text_color "Update apt" $Clear_color
sudo apt update -y
# sudo apt-get update -y

if $upgradeApt; then
  echo -e $Text_color "\n Upgrade apt" $Clear_color
  sudo apt upgrade -y
# sudo apt-get upgrade -y
fi

if $upgradeLinux; then
  echo -e $Text_color "\n Updating Linux" $Clear_color
  sudo apt full-upgrade -y
fi

# INSTALLING REQUIRED PACKAGE MANAGER (if necessary)
if [ $p_manager != "apt" ]; then
  echo -e $Text_color "\n Installing Required Package Manager" $PKG_color $p_manager $Clear_color
  sudo apt install $p_manager
fi

# SNAP AND GNOME-STORE
if $purgeSnap; then
  echo -e $Text_color "\n Removing snap Entirely" $Clear_color
  sudo snap remove firefox -y
  sudo snap remove snap-store -y
  sudo snap remove gtk-common-themes -y
  sudo snap remove core* -y

  sudo rm -rf /var/cache/snapd/
  sudo $p_manager purge snap snapd gnome-software-plugin-snap -y
  sudo rm -rf ~/snap

  echo -e $Text_color "Blocking snap" $Clear_color
  sudo apt-mark hold snap snapd gnome-software-plugin-snap

  if $purgeGnomeStore; then
    echo -e $Text_color "\n Removing gnome-store" $Clear_color
    sudo $p_manager purge gnome-software* -y
  else
    echo -e $Text_color "\n Re-Installing gnome-store" $Clear_color
    sudo $p_manager install gnome-software -y
  fi
fi

# LOOP (UN)INSTALLING PACKAGES (from $conf)

# # To edit the configuration file before executing it
# echo -e $Text_color "\nOpening configuration file" $Clear_color
# sudo gedit $conf
# echo -e $Text_color "\nUsing the latest configuration file" $Clear_color

yn="N" # Consecutive Ns and Ys are clubbed.

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
      echo -e $Text_color $pkg $Clear_color
    fi

    echo -e $Text_color $echo_cmd $PKG_color $pkg $Clear_color
    sudo $p_manager $p_cmd $pkg -y
    ;;

  [Nn]*)
    if $showNMessage; then
      if [ $yn == "Y" ]; then
        echo ""
        yn="N"
      fi

      cmd=${line:2:1}
      pkg=${line:4}

      if [ $cmd == "I" ]; then
        echo -e $Fail_color "Not Installing  " $PKG_color $pkg $Clear_color
      elif [ $cmd == "P" ]; then
        echo -e $Fail_color "Not Removing    " $PKG_color $pkg $Clear_color
      fi
    fi
    ;;
  *) ;;
  esac
done <$conf

# CLEANING UP UNWANTED PACKAGES
echo -e $Text_color "\n Cleaning Up" $Clear_color
sudo apt autoremove -y
sudo apt autoclean -y
echo ""