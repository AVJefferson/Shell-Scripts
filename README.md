# LINUX ESSENTIAL SCRIPTS
A highly customizable package installation, de-bloater and initial personalization shell script.

# PACKAGE INSTALLER

## SETUP CONFIGURATION
These Variables are used to customize the way the [bash script](Package%20Installer/install.sh) executes.

### LINUX and APT UPGRADATIONS
    upgradeApt=true
    upgradeLinux=false
    

### SNAP STORE REMOVAL
    purgeSnap=false
    purgeGnomeStore=false

### PACKAGE INSTALLATION
    p_manager="aptitude"
    conf="pkg.list"
    showNMessage=false

## PACKAGE LIST
**IMP: Edit the [package list file](Package%20Installer/pkg.list) to select/Unselect the packages (using Y/N) you choose to (un)install before executing the shell script.** The packages to be installed are stored in. This filename can also be changed using the $conf variable.

### COMMENTS
Everything beginnning with \# are read as comments and are not processed.
Empty Lines are allowed

### PACKAGES
Packages are to be listed as `[YN] [IPC] package-name`. They should be written in new lines **without intent**.

* [**YN**] - YES or NO
  * Y - Yes, The action is executed.
  * N - No,  The action is not executed but is kept for later reference. If $showNMessage is set to true then these packages are displayed but not executed.
* [**IPC**] - INSTALL or PURGE or COMMENT
  * I - Install, Installs the package (if Yes Selected).
  * P - Purge, Uninstals the package (if Yes Selected).
  * C - Comment, Prints (echo) the content to terminal.
* package-name - Self explanatory. Wild Cards are also allowed.



# LINUX PERSONALIZATION

## PERSONALIZATION CONFIGURATION
    addAlias=false
    disableUbuntuDock=false
further personalizations commands are yet to be added