# NixInfo
Nixinfo is a tool designed to return info about a target \*nix based machine.


# Usage
Sample output for each distro [here](https://github.com/JustinTimperio/nixinfo/blob/master/sample_output.md).

### Print For a User
```shell
$ curl -s https://raw.githubusercontent.com/JustinTimperio/nixinfo/master/nixinfo.sh | sh

Distribution='SHORTNAME'
Full_Name='Full Pretty Name'
Package_Manager='pkg_manager'
Kernel='#.#.#'
Major='####'
Minor='####'
Patch='####'
```

### Import In a Shell Script
```shell
source $(curl -s https://raw.githubusercontent.com/JustinTimperio/nixinfo/master/nixinfo.sh | sh -s no-print)

# Imported Vars Below
$distro
$full_name
$pkg_manager
$kernel
$major
$minor
$patch

```

## Offically Supported Distros
Debian Based:
- Ubuntu
- Debian
- Kali Rolling
- Parrot OS

RHL Based:
- Fedora
- CentOS
- RHEL
- Oracle

Suse Based:
- Leap
- TumbleWeed
- SLES

Arch Based:
- Arch

Alpine Based:
- Alpine

BSD Based:
- FreeBSD
