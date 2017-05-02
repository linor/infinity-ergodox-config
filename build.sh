#!/bin/bash

if [[ ! -e controller/.git ]]; then
    echo "Firmware directory not found. Updating submodules."
    git submodule init
    git submodule update
fi
