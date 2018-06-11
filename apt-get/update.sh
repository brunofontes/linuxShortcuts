#!/usr/bin/env bash
echo Update:
apt-get -y update
echo
echo
echo Upgrade:
apt-get -y upgrade || exit 1
echo
echo
echo Dist-upgrade:
apt-get -y dist-upgrade
echo
echo
echo AutoRemove:
apt-get -y autoremove
echo
echo
echo Clean
apt-get -y clean
echo
echo
echo Autoclean
apt-get -y autoclean
