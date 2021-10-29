#!/bin/bash

##SETUP CONFIGURATION

# todo COLOR CODES

# LINUX and APT UPGRADATIONS
upgradeLinux=false
upgradeApt=true

# SNAP STORE REMOVAL
purgeSnap=false
purgeGnomeStore=false

# PACKAGE INSTALLATION
p_manager="aptitude" # Note that apt and aptitude handles regular expressions differently
conf="pkg.list"
showNMessage=false # N selected commands in .config are not displayed

# todo CREATING A SNAPSHOT OF EXISTING PACKAGES
#sudo apt list --installed >

# UPDATING EVERYTHING AND GETTING READY
echo "Linux Install From Config File"
sudo echo # Asking for sudo permissions
echo "Update apt"
sudo apt update -y
# sudo apt-get update -y

if $upgradeApt; then
  echo -e "\nUpgrade apt"
  sudo apt upgrade -y
# sudo apt-get upgrade -y
fi

if $upgradeLinux; then
  echo -e "\nUpdating Linux"
  sudo apt full-upgrade -y
fi

# INSTALLING REQUIRED PACKAGE MANAGER (if necessary)
if [ $p_manager != "apt" ]; then
  echo -e "\nInstalling" $p_manager
  sudo apt install $p_manager
fi

# SNAP AND GNOME-STORE
if $purgeSnap; then
  echo -e "\nRemoving snap Entirely"
  sudo snap remove firefox -y
  sudo snap remove snap-store -y
  sudo snap remove gtk-common-themes -y
  sudo snap remove core* -y

  sudo rm -rf /var/cache/snapd/
  sudo $p_manager purge snap snapd gnome-software-plugin-snap -y
  sudo rm -rf ~/snap

  echo "Blocking snap"
  sudo apt-mark hold snap snapd gnome-software-plugin-snap

  if $purgeGnomeStore; then
    echo -e "\nRemoving gnome-store"
    sudo $p_manager purge gnome-software* -y
  else
    echo -e "\nRe-Installing gnome-store"
    sudo $p_manager install gnome-software -y
  fi
fi

# LOOP (UN)INSTALLING PACKAGES (from $conf)

# # To edit the configuration file before executing it
# echo -e "\nOpening configuration file"
# sudo gedit $conf
# echo -e "\nUsing the latest configuration file"

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
      echo -e $pkg
    fi

    echo -e $echo_cmd $pkg
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
        echo "Not Installing  " $pkg
      elif [ $cmd == "P" ]; then
        echo "Not Removing    " $pkg
      fi
    fi
    ;;
  *) ;;
  esac
done <$conf

# CLEANING UP UNWANTED PACKAGES
echo -e "\nCleaning Up"
sudo apt autoremove -y
sudo apt autoclean -y
