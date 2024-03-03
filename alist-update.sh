#!/bin/bash

VERSION=$(curl -s https://api.github.com/repos/alist-org/alist/releases/latest |
    grep tag_name |
    cut -d ":" -f2 |
    sed 's/\"//g;s/\,//g;s/\ //g;s/v//' |
    head -n 1)
CURRENT=$(/home/alist/alist version | grep "Version: v" | awk '{print $2}')

if [ "v$VERSION" = "$CURRENT" ]; then
    echo "no need to upgrade"
else
    curl -fsSL "https://alist.nn.ci/v3.sh" | bash -s update /home
fi
