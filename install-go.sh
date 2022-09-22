#!/bin/bash

# remove previous go installations
echo "Removing previous go installations at /usr/local/go ..."
sudo rm -rf /usr/local/go

# install go 1.19.1
echo "Installing go 1.19.1 to system..."
sudo tar -C /usr/local -xzf ./go1.19.1.linux-amd64.tar.gz

# setup env
echo "exoprt PATH to $HOME/.profile"
export PATH=$PATH:/usr/local/go/bin >> $HOME/.profile

echo "Install go 1.19.1 success. You can type the command \"go version\" to check if go is installed correctly"

