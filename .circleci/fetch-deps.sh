#!/usr/bin/env bash

sudo apt-get -y install software-properties-common
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo add-apt-repository -y ppa:ethereum/ethereum-dev
sudo apt-get -y update
sudo apt-get install -y curl
sudo apt-get install -y dpkg
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash
sudo apt-get install -y nodejs evm solc
