# TODO LIST
* 
# PERSONALIZE LINUX

## BASH

### backup .bashrc file
    cp ~/.bashrc ~/.bashrc.bak

### edit .bashrc
    # Better History
    HISTSIZE=10000
    HISTFILESIZE=15000
    HISTTIMEFORMAT="%F %T "

    # 2 line bash interface
    if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n\$ '
    else
      PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\n\$ '
    fi
    unset color_prompt force_color_prompt
    
### add .bash_aliases
    # alias for launching new terminal window
    alias gt="gnome-terminal --"
    alias htop="gnome-terminal --geometry 140x40 -t htop -- sudo htop"

    alias aptclear="sudo apt autoremove && sudo apt autoclean"

    # Fast Shutdown and Reboot
    alias shutnow="shutdown now"

## settings

## bluetooth
* pair bluetooth headset

## keyboard shortcuts
* addnew
  * xkill
  * htop
* edit existing
  * launcher 3
  * navigation 3
  * sound&media 6
  * system 4
  * windows 2

## wifi
* add wifi password to known networks

## copyq
* general
  * autostart
  * always on top
  * close when unfocused
* history
  * max items 500
* notification
  * bottom right
* shortcuts
  * show tray menu -- meta + v

## samba
    sudo smbpasswd -a USERNAME
    cd /etc/samba/smb.conf
    cp smb.conf smb.conf.bak
* "usershare owner only = false" in [global] at [smb.conf](/etc/samba/smb.conf) @ line 169
* remove/comment print$  @ lines 231-236

## firewall ufw
    sudo ufw enable
    sudo ufw allow Samba
    sudo ufw allow OpenSSH

## gnome-tweaks
* general
  * suspend lid close
* top bar
  * enable hot corner
  * battery percentage
  * clock
    * weekday
    * date
    * seconds

## thonny

## arduino

## flex

## bison

## mariadb-server

## git
    git config --global user.name ""
    git config --global user.email ""
    git config --global core.editor ""

    gpg --default-new-key-algo rsa4096 --gen-key
    gpg --list-secret-keys --keyid-format=long
    gpg --armor --export PRIVATE-ID
    git config --global user.signingkey PRIVATE-ID
    git config --global commit.gpgsign true

## python
    sudo pip install Discord
    sudo pip install eyeD3


# PACKAGE (UN)INSTALLER

## Better Commands in [pkg.list](Package%20Installer/pkg.list)
* Allowing spacing between | separated  commands in the pkg.list file
* Allow # comments after commands
* Print invalid commands
* Add ? \[YN\] for yes or no enquiry during runtime.
* Allow options to be given to [install.sh](Package%20Installer/install.sh) as arguments
  * --force-all
    * force install all packages
* Support for commmands like
  * curl
  * wget
  * add-apt-repository

## Read error/success from package manager

## Snap remove everything from list

## Add logging file
* Saved as pkglist.log
  * Date and Time = "\#!date=yyyy-mm-dd--HH-MM-SS"
  * must have a list of installed packages and removed packages under 2 sections.
  * save only those that actually get installed
* create another shell called rollback
  * reads a date-time as input
  * Reads a log file and reverts changes till entered date
