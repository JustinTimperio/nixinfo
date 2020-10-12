#!/usr/bin/env sh

# ======================================
# Offically Supported and Tested Distros
#   Debian Based:
#    - Ubuntu
#    - Debian
#    - Kali Rolling
#    - Parrot OS
#
#   RHL Based:
#    - Fedora
#    - Fedora CoreOS
#    - CentOS
#    - RHEL
#    - Oracle Linux
#
#   Suse Based:
#    - Leap
#    - TumbleWeed
#    - SLES
#
#   Arch Based:
#    - Arch Linux
#    - Manjaro
#
#   Alpine Based:
#    - Alpine Linux
#
#   BSD Based:
#    - FreeBSD
# ======================================

# Allow For Manual Spesification of Package Manager
if [ -z $1 ]; then
  alt_pkg_manager='NONE'
else
  alt_pkg_manager=$1
fi

# Allow For Manual Spesification of /etc/os-release File
if [ -z $2 ]; then
  release_file="/etc/os-release"
else
  release_file=$2
fi

# Allow For Manual Spesification of Alternate Release File
if [ -z $3 ]; then
  alt_release_file="NONE"
else
  alt_release_file=$3
fi



print_output(){
  echo "Distribution='$distro'"
  echo "Full_Name='$name'"
  echo "Package_Manager='$pkg_manager'"
  echo "Kernel='$kernel'"
  echo "Major='$major'"
  echo "Minor='$minor'"
  echo "Patch='$patch'"
}


identify_pkg_manager(){

  # Override Package Manager
  if [ "$alt_pkg_manager" != "NONE" ]; then
    pkg_manager="$alt_pkg_manager"

  # SUSE Based
  elif [ -f "/usr/bin/zypper" ]; then
    type=$(file /usr/bin/zypper --mime-type | awk -F '[ /]' '{ print $6 }')
    if [ "$type" != "x-shellscript" -a "$type" != "x-perl" -a "$type" != "symlink" ]; then
      pkg_manager="zypper"
    fi
  
  # Deb Based
  elif [ -f "/usr/bin/apt" ] || [ -f "/bin/apt" ]; then
    type=$(file /usr/bin/apt --mime-type | awk -F '[ /]' '{ print $6 }')
    if [ "$type" != "x-shellscript" -a "$type" != "x-perl" -a "$type" != "symlink" ]; then
      pkg_manager="apt"
    fi

  # RHL Based
  elif [ -f "/usr/bin/yum" ] || [ -f "/bin/yum" ]; then
    type=$(file /usr/bin/yum --mime-type | awk -F '[ /]' '{ print $6 }')
    if [ "$type" != "x-shellscript" -a "$type" != "x-perl" -a "$type" != "symlink" ]; then
      pkg_manager="yum"
    fi

  # Arch Based
  elif [ -f "/usr/bin/pacman" ] || [ -f "/bin/pacman" ]; then
    type=$(file /usr/bin/pacman --mime-type | awk -F '[ /]' '{ print $6 }')
    if [ "$type" != "x-shellscript" -a "$type" != "x-perl" -a "$type" != "symlink" ]; then
      pkg_manager="pacman"
    fi

  # FreeBSD
  elif [ -f "/usr/sbin/pkg" ]; then
    type=$(file /usr/bin/pkg --mime-type | awk -F '[ /]' '{ print $6 }')
    if [ "$type" != "x-shellscript" -a "$type" != "x-perl" -a "$type" != "symlink" ]; then
      pkg_manager="pkg"
    fi

  # Alpine Linux
  elif [ -f "/sbin/apk" ]; then
    # Apline Doesn't Come with `file`
    pkg_manager="apk"

  # Can't Determine
  else
    pkg_manager="UNKNOWN"
  fi
}


identify_deb(){
  kernel=$(uname -r | awk -F '[-]' '{print $1}')
  
  if [ -f "$release_file" ]; then
    distro=$(awk -F '[= ]' '/^NAME=/ { gsub(/"/,"");  print toupper($2) }' $release_file)

    if [ "$distro" = "UBUNTU" ]; then
      name=$(awk -F '[= ]' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
      major=$(awk -F '[=. ]' '/^VERSION=/ { gsub(/"/,"");  print $2 }' $release_file)
      minor=$(awk -F '[=. ]' '/^VERSION=/ { gsub(/"/,"");  print $3 }' $release_file)
      patch=$(awk -F '[=. ]' '/^VERSION=/ { gsub(/"/,"");  print $4 }' $release_file)

    elif [ "$distro" = "DEBIAN" ]; then
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
 
      if [ "$alt_release_file" = "NONE" ]; then
        alt_release_file='/etc/debian_version'
      fi

      major=$(head -1 $alt_release_file | awk -F '[=.]' '{ gsub(/"/,""); print $1 }')
      minor=$(head -1 $alt_release_file | awk -F '[=.]' '{ gsub(/"/,""); print $2 }')
      patch='n/a'

    elif [ "$distro" = "KALI" ]; then
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
      major=$(awk -F '[=.]' '/^VERSION=/ { gsub(/"/,"");  print $2 }' $release_file)
      minor=$(awk -F '[=.]' '/^VERSION=/ { gsub(/"/,"");  print $3 }' $release_file)
      patch='n/a'

    elif [ "$distro" = "PARROT" ]; then
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
      major=$(awk -F '[=.]' '/^VERSION=/ { gsub(/"/,"");  print $2 }' $release_file)
      minor=$(awk -F '[=.]' '/^VERSION=/ { gsub(/"/,"");  print $3 }' $release_file)
      patch='n/a'

    else
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
      major=$(awk -F '=' '/^VERSION=/ { gsub(/"/,"");  print $2 }' $release_file)
      minor='UNKNOWN'
      patch='UNKNOWN'
    fi
  
  else
    echo 'System is Based on Debian Linux But NO Release Info Was Found in $release_file!'
    exit 1
  fi
}


identify_rhl(){
  kernel=$(uname -r | awk -F '[-]' '{print $1}')
  
  if [ -f "$release_file" ]; then
    distro=$(awk -F '[= ]' '/^NAME=/ { gsub(/"/,"");  print toupper($2) }' $release_file)

    if [ "$distro" = "FEDORA" ]; then
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
      major=$(awk -F '[= ]' '/^VERSION=/ { gsub(/"/,"");  print $2 }' $release_file)
      minor='n/a'
      patch='n/a'

    elif [ "$distro" = "CENTOS" ]; then

      if [ "$alt_release_file" = "NONE" ]; then
        alt_release_file='/etc/centos-release'
      fi

      name=$(cat $alt_release_file)
      major=$(grep -o '[0-9]\+' $alt_release_file | sed -n '1p')
      minor=$(grep -o '[0-9]\+' $alt_release_file | sed -n '2p')
      patch=$(grep -o '[0-9]\+' $alt_release_file | sed -n '3p')

    elif [ "$distro" = "ORACLE" ]; then
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
      major=$(awk -F '[=.]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' $release_file)
      minor=$(awk -F '[=.]' '/^VERSION_ID=/ { gsub(/"/,"");  print $3 }' $release_file)
      patch='n/a'

    elif [ "$distro" = "RED" ]; then
      distro='REDHAT'
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
      major=$(awk -F '[=.]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' $release_file)
      minor=$(awk -F '[=.]' '/^VERSION_ID=/ { gsub(/"/,"");  print $3 }' $release_file)
      patch='n/a'

    else
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
      major=$(awk -F '=' '/^VERSION=/ { gsub(/"/,"");  print $2 }' $release_file)
      minor='UNKNOWN'
      patch='UNKNOWN'
    fi

  else
    echo 'System is Based on RedHat Linux But NO Release Info Was Found in $release_file!'
    exit 1
  fi
}


identify_suse(){
  kernel=$(uname -r | awk -F '[-]' '{print $1}')
  
  if [ -f "$release_file" ]; then
    distro=$(awk -F '[= ]' '/^NAME=/ { gsub(/"/,"");  print toupper($3) }' $release_file)
    
    if [ "$distro" = "LEAP" ]; then
      # Tested
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
      major=$(awk -F '[=. ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' $release_file)
      minor=$(awk -F '[=. ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $3 }' $release_file)
      patch='n/a'

    elif [ "$distro" = "TUMBLEWEED" ]; then
      # Tested
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
      major=$(awk -F '[= ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' $release_file | rev | cut -c5- | rev)
      minor=$(awk -F '[= ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' $release_file | cut -c5- | rev | cut -c3- | rev)
      patch=$(awk -F '[= ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' $release_file | cut -c7-)

    elif [ "$distro" = "SLES" ]; then
      # Un-Tested
      name=$(awk -F '=' '/^NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
      major=$(awk -F '[=.]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' $release_file)
      minor=$(awk -F '[=.]' '/^VERSION_ID=/ { gsub(/"/,"");  print $3 }' $release_file)
      patch='n/a'
    fi
  
  else
    echo 'System is Based on OpenSUSE But NO Release Info Was Found in $release_file!'
    exit 1
  fi
}


identify_arch(){
  kernel=$(uname -r | awk -F '[-]' '{print $1}')
  
  if [ -f "$release_file" ]; then
    # Tested
    distro=$(awk -F '[= ]' '/^NAME=/ { gsub(/"/,"");  print toupper($2) }' $release_file)
    name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
    major=$(awk -F '=' '/^BUILD_ID/ { gsub(/"/,""); print $2 }' $release_file)
    minor=$(awk -F '=' '/^BUILD_ID/ { gsub(/"/,""); print $2 }' $release_file)
    patch=$(awk -F '=' '/^BUILD_ID/ {  gsub(/"/,""); print $2 }' $release_file)
  
  else
    echo 'System is Based on Arch Linux But NO Release Info Was Found in $release_file!'
    exit 1
  fi
}


identify_freebsd(){
  # Tested
  kernel=$(uname -K)
  distro=$(uname | tr [a-z] [A-Z])
  name="$(uname) $(uname -r)"
  major=$(uname -r | awk -F '[.-]' '{ print $1 }')
  minor=$(uname -r | awk -F '[.-]' '{ print $2 }')
  patch='n/a'
}


identify_alpine(){
  kernel=$(uname -r | awk -F '[-]' '{ print $1 }')
  
  if [ -f "$release_file" ]; then
    # Tested
    distro=$(awk -F '[=]' '/^NAME=/ { gsub(/"/,"");  print toupper($2) }' $release_file)
    name=$(awk -F '=' '/^PRETTY_NAME=/{ print $2 }' $release_file)
    major=$(awk -F '[=. ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' $release_file)
    minor=$(awk -F '[=. ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $3 }' $release_file)
    patch='n/a'
  
  else
    echo 'System is Based Alpine Linux But NO Release Info Was Found in $release_file!'
    exit 1
  fi
}


# Use PKG Manager Trigger Identification Process
identify_pkg_manager

if [ "$pkg_manager" = "apt" ]; then
  identify_deb

elif [ "$pkg_manager" = "yum" ]; then
  identify_rhl

elif [ "$pkg_manager" = "zypper" ]; then
  identify_suse

elif [ "$pkg_manager" = "pkg" ]; then
  identify_freebsd

elif [ "$pkg_manager" = "apk" ]; then
  identify_alpine

elif [ "$pkg_manager" = "pacman" ]; then
  identify_arch

else
  echo 'Could NOT Determine The Systems Package Manager!' 
  exit 1
fi

print_output
