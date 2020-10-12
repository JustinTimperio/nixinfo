# NixInfo
Nixinfo is a tool designed to return info about a target \*nix based machine.


# Usage
```shell
curl -s https://raw.githubusercontent.com/JustinTimperio/nixinfo/master/identify-distribution.sh | sh
```

## Output Structure
```shell
Distribution='SHORTNAME'
Full_Name='Full Pretty Name'
Package_Manager='pkg_manager'
Kernel='#.#.#'
Major='####'
Minor='####'
Patch='####'
```

Sample output for each distro [here](https://github.com/JustinTimperio/nixinfo/blob/master/sample_output.md).

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
- Manjaro

Alpine Based:
- Alpine

BSD Based:
- FreeBSD
