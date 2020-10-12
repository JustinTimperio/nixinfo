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


# Allow For Manual Spesification of os-release File
if [ -z $1 ]; then
  release_file="/etc/os-release"
else
  release_file=$1
fi


print_output(){
  echo "Package_Manager=$pkg_manager"
  echo "Distribution=$name"
  echo "Kernel=$kernel"
  echo "Major=$major"
  echo "Minor=$minor"
  echo "Patch=$patch"
}


identify_pkg_manager(){
  # SUSE Based
  if [ -f "/usr/bin/zypper" ]; then
    # Needs run first because Tumbleweed has both zypper and apt-rpm
    pkg_manager="zypper"
  
  # Deb Based
  elif [ -f "/usr/bin/apt" ] || [ -f "/bin/apt" ]; then
    pkg_manager="apt"

  # RHL Based
  elif [ -f "/usr/bin/yum" ] || [ -f "/bin/yum" ]; then
    pkg_manager="yum"

  # SUSE Based
  elif [ -f "/usr/bin/zypper" ]; then
    pkg_manager="zypper"

  # Arch Based
  elif [ -f "/usr/bin/pacman" ] || [ -f "/bin/pacman" ]; then
    pkg_manager="pacman"

  # FreeBSD
  elif [ -f "/usr/sbin/pkg" ]; then
    pkg_manager="pkg"

  # Alpine Linux
  elif [ -f "/sbin/apk" ]; then
    pkg_manager="apk"

  # Can't Determine
  else
    pkg_manager="UNKNOWN"
  fi
}


identify_deb(){
  kernel=$(uname -r | awk -F '[-]' '{print $1}')
  
  if [ -f "$release_file" ]; then
    distro=$(awk -F '[= ]' '/^NAME=/ { gsub(/"/,"");  print tolower($2) }' $release_file)

    if [ "$distro" = "ubuntu" ]; then
      # Tested
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
      major=$(awk -F '[=. ]' '/^VERSION=/ { gsub(/"/,"");  print $2 }' $release_file)
      minor=$(awk -F '[=. ]' '/^VERSION=/ { gsub(/"/,"");  print $3 }' $release_file)
      patch=$(awk -F '[=. ]' '/^VERSION=/ { gsub(/"/,"");  print $4 }' $release_file)

    elif [ "$distro" = "debian" ]; then
      # Tested
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
      major=$(head -1 /etc/debian_version | awk -F '[=.]' '{ gsub(/"/,""); print $1 }')
      minor=$(head -1 /etc/debian_version | awk -F '[=.]' '{ gsub(/"/,""); print $2 }')
      patch='n/a'

    elif [ "$distro" = "kali" ]; then
      # Tested
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
      major=$(awk -F '[=.]' '/^VERSION=/ { gsub(/"/,"");  print $2 }' $release_file)
      minor=$(awk -F '[=.]' '/^VERSION=/ { gsub(/"/,"");  print $3 }' $release_file)
      patch='n/a'
    
    elif [ "$distro" = "Parrot" ]; then
      # Un-Tested
      major='n/a'
      minor='n/a'
      patch='n/a'

    else
      # Tested
      major=$(awk -F '[=]' '/^VERSION_ID/ { gsub(/"/,"");  print $2 }' $release_file)
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
    distro=$(awk -F '[= ]' '/^NAME=/ { gsub(/"/,"");  print tolower($2) }' $release_file)
    
    if [ "$distro" = "fedora" ]; then
      # Tested
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
      major=$(awk -F '[= ]' '/^VERSION=/ { gsub(/"/,"");  print $2 }' $release_file)
      minor='n/a'
      patch='n/a'
    
    elif [ "$distro" = "centos" ]; then
      # Tested
      name=$(cat /etc/centos-release)
      major=$(grep -o '[0-9]\+' /etc/centos-release | sed -n '1p')
      minor=$(grep -o '[0-9]\+' /etc/centos-release | sed -n '2p')
      patch=$(grep -o '[0-9]\+' /etc/centos-release | sed -n '3p')

    elif [ "$distro" = "oracle" ]; then
      # Tested
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
      major=$(awk -F '[=.]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' $release_file)
      minor=$(awk -F '[=.]' '/^VERSION_ID=/ { gsub(/"/,"");  print $3 }' $release_file)
      patch='n/a'
    
    elif [ "$distro" = "redhat" ]; then
      # Un-Tested
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
      major='n/a'
      minor='n/a'
      patch='n/a'
    fi

  else
    echo 'System is Based on RedHat Linux But NO Release Info Was Found in $release_file!'
    exit 1
  fi
}


identify_suse(){
  kernel=$(uname -r | awk -F '[-]' '{print $1}')
  
  if [ -f "$release_file" ]; then
    distro=$(awk -F '[= ]' '/^NAME=/ { gsub(/"/,"");  print tolower($3) }' $release_file)
    
    if [ "$distro" = "leap" ]; then
      # Tested
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
      major=$(awk -F '[=. ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' $release_file)
      minor=$(awk -F '[=. ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $3 }' $release_file)
      patch='n/a'

    elif [ "$distro" = "tumbleweed" ]; then
      # Tested
      name=$(awk -F '=' '/^PRETTY_NAME=/ { gsub(/"/,"");  print $2 }' $release_file)
      major=$(awk -F '[= ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' $release_file | rev | cut -c5- | rev)
      minor=$(awk -F '[= ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' $release_file | cut -c5- | rev | cut -c3- | rev)
      patch=$(awk -F '[= ]' '/^VERSION_ID=/ { gsub(/"/,"");  print $2 }' $release_file | cut -c7-)

    elif [ "$distro" = "sles" ]; then
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
    distro="arch"
    name=$(awk -F '[= ]' '/^NAME/ { gsub(/"/,""); print $2 }' $release_file)
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
  kernel=$(uname -r)
  distro=$(uname)
  name="$(uname) $(uname -r)"
  major=$(uname -r | awk -F '[.-]' '{ print $1 }')
  minor=$(uname -r | awk -F '[.-]' '{ print $2 }')
  patch='n/a'
}


identify_alpine(){
  kernel=$(uname -r | awk -F '[-]' '{ print $1 }')
  
  if [ -f "$release_file" ]; then
    # Tested
    distro=$(awk -F '[= ]' '/^NAME=/ { gsub(/"/,"");  print tolower($2) }' $release_file)
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
