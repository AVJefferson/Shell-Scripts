# TODO LIST

## PERSONALIZE LINUX

### BASH
#### backup .bashrc file
    cp ~/.bashrc ~/.bashrc.bak
#### edit .bashrc
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
    
#### add .bash_aliases
    # alias for launching new terminal window
    alias gt="gnome-terminal --"
    alias htop="gnome-terminal --geometry 140x40 -t htop -- sudo htop"

    alias aptclear="sudo apt autoremove && sudo apt autoclean"

    # Fast Shutdown and Reboot
    alias shutnow="shutdown now"

### settings

### bluetooth
* pair bluetooth headset

### keyboard shortcuts
* addnew
  * xkill
  * htop
* edit existing
  * launcher 3
  * navigation 3
  * sound&media 6
  * system 4
  * windows 2

### wifi
* add wifi password to known networks

### samba
* setup username password
* "usershare owner only = false" in [global] at smb.conf

### openssh-server
* create user and password. rsa private-public key pair may not work with some ssh clients

### firewall ufw
    sudo ufw enable
    sudo ufw allow Samba
    sudo ufw allow OpenSSH


### gnome-extensions
* disable ubuntu-dock@ubuntu.com

### ubuntu advantage
    ubuntu-advantage disable livepatch

### gnome-tweaks
* general
  * suspend lid close
* top bar
  * enable hot corner
  * battery percentage
  * clock
    * weekday
    * date
    * seconds

### thonny

### arduino

### flex

### bison

### mariadb-server

### git
    git config --global user.name ""
    git config --global user.email ""
    git config --global core.editor ""


## PACKAGE (UN)INSTALLER

### Allowing spacing between | separated  commands in the pkg.list file

### Add Color

### Add logging file
* Saved as pkglist.log
  * Date and Time = "\#!date=yyyy-mm-dd--HH-MM-SS"
  * must have a list of installed packages and removed packages under 2 sections.
  * save only those that actually get installed
* create another shell called rollback
  * reads a date-time as input
  * Reads a log file and reverts changes till entered date