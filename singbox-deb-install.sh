#!/bin/bash

set -e -o pipefail

ARCH_RAW=$(uname -m)
case "${ARCH_RAW}" in
'x86_64') ARCH='amd64' ;;
'x86' | 'i686' | 'i386') ARCH='386' ;;
'aarch64' | 'arm64') ARCH='arm64' ;;
'armv7l') ARCH='armv7' ;;
's390x') ARCH='s390x' ;;
*)
    echo "Unsupported architecture: ${ARCH_RAW}"
    exit 1
    ;;
esac

VERSION=$(curl -s https://api.github.com/repos/SagerNet/sing-box/releases |
    grep tag_name |
    cut -d ":" -f2 |
    sed 's/\"//g;s/\,//g;s/\ //g;s/v//' |
    head -n 1)
CURRENT=$(/usr/bin/sing-box version | grep "sing-box version" | awk '{print $3}')

if [ "$VERSION" = "$CURRENT" ]; then
    curl -Lo sing-box.deb "https://github.com/SagerNet/sing-box/releases/download/v${VERSION}/sing-box_${VERSION}_linux_${ARCH}.deb"
    sudo dpkg -i sing-box.deb
    rm sing-box.deb
else
    echo "no need to upgrade"
fi
