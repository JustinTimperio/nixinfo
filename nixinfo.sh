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
#
#   Alpine Based:
#    - Alpine Linux
#
#   BSD Based:
#    - FreeBSD
# ======================================

# Allow For Raw Print or Source Import In Another Script
if [ -z $1 ]; then
  use_type='PRINT'
elif [ "$1" = 'print' ] || [ "$1" = 'PRINT' ] ; then
  use_type='PRINT'
elif [ "$1" = 'no-print' ] || [ "$1" = 'NO-PRINT' ] ; then
  use_type='SOURCE'
else
  use_type='PRINT'
fi

# Allow For Manual Spesification of Package Manager
if [ -z $2 ]; then
  alt_pkg_manager='NONE'
else
  alt_pkg_manager=$2
fi

# Allow For Manual Spesification of /etc/os-release File
if [ -z $3 ]; then
  release_file="/etc/os-release"
else
  release_file=$3
fi

# Allow For Manual Spesification of Alternate Release File
if [ -z $4 ]; then
  alt_release_file="NONE"
else
  alt_release_file=$2
fi


identify_pkg_manager(){
  # SUSE Based
  if [ -f "/usr/bin/zypper" ]; then
    type=$(file $(readlink -f /usr/bin/zypper) --mime-type | awk -F '[ /]' '{ print $6 }')
    if [ "$type" != "x-shellscript" -a "$type" != "x-perl" ]; then
      pkg_manager="zypper"
    fi
  fi
  
  # Deb Based
  if [ -f "/usr/bin/apt" ]; then
    type=$(file $(readlink -f /usr/bin/apt) --mime-type | awk -F '[ /]' '{ print $6 }')
    if [ "$type" != "x-shellscript" -a "$type" != "x-perl" ]; then
      pkg_manager="apt"
    fi
  fi

  # RHL Based
  if [ -f "/usr/bin/yum" ]; then
    type=$(file $(readlink -f /usr/bin/yum) --mime-type | awk -F '[ /]' '{ print $6 }')
    if [ "$type" != "x-shellscript" -a "$type" != "x-perl" ]; then
      pkg_manager="yum"
    fi
  fi

  # Arch Linux
  if [ -f "/usr/bin/pacman" ]; then
    type=$(file $(readlink -f /usr/bin/pacman) --mime-type | awk -F '[ /]' '{ print $6 }')
    if [ "$type" != "x-shellscript" -a "$type" != "x-perl" ]; then
      pkg_manager="pacman"
    fi
  fi

  # FreeBSD
  if [ -f "/usr/sbin/pkg" ]; then
    type=$(file $(readlink -f /usr/sbin/pkg) --mime-type | awk -F '[ /]' '{ print $6 }')
    if [ "$type" != "x-shellscript" -a "$type" != "x-perl" ]; then
      pkg_manager="pkg"
    fi
  fi

  # Alpine Linux
  if [ -f "/sbin/apk" ]; then
    # Apline Doesn't Come with `file`
    pkg_manager="apk"
  fi

  # Override Package Manager
  if [ "$alt_pkg_manager" != "NONE" ]; then
    pkg_manager="$alt_pkg_manager"
  fi
  
  # Can't Determine
  if [ -z $pkg_manager ]; then
    pkg_manager="UNKNOWN"
  fi
}


identify_deb(){
  kernel=$(uname -r | awk -F '[-]' '{print $1}')
  
  if [ -f "$release_file" ]; then
    distro=$(awk -F '[= ]' '/^NAME=/ { gsub(/"/,"");  print toupper($2) }' $release_file)

    if [ "$distro" = "UBUNTU" ]; then
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
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
    distro=$(awk -F '=' '/^NAME=/ { gsub(/"/,"");  print toupper($2) }' $release_file)
    
    if [ "$distro" = "OPENSUSE LEAP" ]; then
      distro="LEAP"
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
      major=$(awk -F '[=. ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' $release_file)
      minor=$(awk -F '[=. ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $3 }' $release_file)
      patch='n/a'

    elif [ "$distro" = "OPENSUSE TUMBLEWEED" ]; then
      distro="TUMBLEWEED"
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
      major=$(awk -F '[= ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' $release_file | rev | cut -c5- | rev)
      minor=$(awk -F '[= ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' $release_file | cut -c5- | rev | cut -c3- | rev)
      patch=$(awk -F '[= ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' $release_file | cut -c7-)

    elif [ "$distro" = "SLES" ]; then
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
    echo 'System is Based on OpenSUSE But NO Release Info Was Found in $release_file!'
    exit 1
  fi
}


identify_arch(){
  kernel=$(uname -r | awk -F '[-]' '{print $1}')
  
  if [ -f "$release_file" ]; then
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
    distro=$(awk -F '[= ]' '/^NAME=/ { gsub(/"/,"");  print toupper($2) }' $release_file)
    name=$(awk -F '=' '/^PRETTY_NAME=/{ gsub(/"/,""); print $2 }' $release_file)
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

if [ "$use_type" = "PRINT" ]; then
  # Print Info For User
  echo "Distribution='$distro'"
  echo "Full_Name='$name'"
  echo "Package_Manager='$pkg_manager'"
  echo "Kernel='$kernel'"
  echo "Major='$major'"
  echo "Minor='$minor'"
  echo "Patch='$patch'"

else
  # Import Results as Source
  distro=$distro
  full_name=$name
  pkg_manager=$pkg_manager
  kernel=$kernel
  major=$major
  minor=$minor
  patch=$patch
fi
