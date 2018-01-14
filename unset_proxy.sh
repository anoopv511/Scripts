#!/bin/bash

bashrc=~/.bashrc
zshrc=~/.zshrc
apt_conf=/etc/apt/apt.conf
wgetrc=~/.wgetrc
renviron=~/.Renviron

sudo sed -i '/Acquire::http::Proxy/d' $apt_conf
sudo sed -i '/Acquire::https::Proxy/d' $apt_conf
sudo sed -i '/Acquire::ftp::Proxy/d' $apt_conf

sed -i '/http_proxy/d' $bashrc
sed -i '/https_proxy/d' $bashrc
sed -i '/ftp_proxy/d' $bashrc

sed -i '/http_proxy/d' $zshrc
sed -i '/https_proxy/d' $zshrc
sed -i '/ftp_proxy/d' $zshrc

git config --global --unset http.proxy
git config --global --unset https.proxy

npm config delete proxy
npm config delete https-proxy

sed -i '/use_proxy/d' $wgetrc 
sed -i '/http_proxy/d' $wgetrc
sed -i '/https_proxy/d' $wgetrc

sed -i '/http_proxy/d' $renviron
sed -i '/https_proxy/d' $renviron