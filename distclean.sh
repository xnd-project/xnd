#!/bin/sh

if [ $(basename $(pwd)) != "xnd" ]
then
    printf "\ndistclean: error: this script must be run from the \"xnd\" directory\n\n"
    exit 1
fi

find . \( -name CMakeCache.txt -o -name Makefile -o -name cmake_install.cmake -o  \
          -name build.ninja -o -name rules.ninja -o -name .ninja_deps \
          -o -name .ninja_log -o -name install_manifest.txt \) \
       -exec rm -f {} \;

find . \( -name CMakeFiles -o -name usr -o -name __pycache__ \) -prune -exec rm -rf {} \;
