#!/usr/bin/env bash

sudo apt-get install software-properties-common
sudo add-apt-repository ppa:ethereum/ethereum
sudo add-apt-repository ppa:ethereum/ethereum-dev
sudo apt-get update
sudo apt-get install cpp-ethereum
sudo apt-get install solc