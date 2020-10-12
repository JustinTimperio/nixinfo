#!/usr/bin/env sh

basedir=$(pwd)

# Test apt Based Distros
$basedir/identify-distribution.sh apt $basedir/release-info/debian_10/etc/os-release $basedir/release-info/debian_10/etc/debian_version
echo '====================================='
$basedir/identify-distribution.sh apt $basedir/release-info/kali/etc/os-release
echo '====================================='
$basedir/identify-distribution.sh apt $basedir/release-info/parrot/etc/os-release
echo '====================================='
$basedir/identify-distribution.sh apt $basedir/release-info/ubuntu_18.04/etc/os-release
echo '====================================='
$basedir/identify-distribution.sh apt $basedir/release-info/ubuntu_20.04/etc/os-release
echo '====================================='

# Test yum Based Distros
$basedir/identify-distribution.sh yum $basedir/release-info/centos_8/etc/os-release $basedir/release-info/centos_8/etc/centos-release
echo '====================================='
$basedir/identify-distribution.sh yum $basedir/release-info/centos_7/etc/os-release $basedir/release-info/centos_7/etc/centos-release
echo '====================================='
$basedir/identify-distribution.sh yum $basedir/release-info/fedora_32/etc/os-release
echo '====================================='
$basedir/identify-distribution.sh yum $basedir/release-info/oracle_linux_8/etc/os-release
echo '====================================='
$basedir/identify-distribution.sh yum $basedir/release-info/rhel_7/etc/os-release
echo '====================================='

# Test zypper Based Distros
$basedir/identify-distribution.sh zypper $basedir/release-info/leap_15/etc/os-release
echo '====================================='
$basedir/identify-distribution.sh zypper $basedir/release-info/tumbleweed/etc/os-release
echo '====================================='
$basedir/identify-distribution.sh zypper $basedir/release-info/sles_12_sp5/etc/os-release
echo '====================================='
$basedir/identify-distribution.sh zypper $basedir/release-info/sles_15/etc/os-release
echo '====================================='
$basedir/identify-distribution.sh zypper $basedir/release-info/sles_15_sp1/etc/os-release
echo '====================================='

# Test arch Based Distros
$basedir/identify-distribution.sh pacman $basedir/release-info/arch/etc/os-release
echo '====================================='

# Test alpine Based Distros
$basedir/identify-distribution.sh apk $basedir/release-info/alpine_3.12/etc/os-release
