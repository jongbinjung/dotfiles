#!/bin/bash
BASE_DIR=`pwd`

sudo ln -s $BASE_DIR/vtex /usr/local/bin/vtex
sudo chmod +x /usr/local/bin/vtex

unset BASE_DIR
