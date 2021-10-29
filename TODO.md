# TODO LIST

## PERSONALIZE LINUX

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

### firewall ufw
    sudo ufw enable
    sudo ufw allow app samba

### openssh-server
* create user and password. rsa private-public key pair may not work with some ssh clients

### gnome-extensions
* disable dock

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