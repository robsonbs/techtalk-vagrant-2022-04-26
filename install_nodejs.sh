#!/bin/bash
echo "Instalando NodeJS"
curl -fsSL http://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install --global yarn
cd /persistencia/app && yarn