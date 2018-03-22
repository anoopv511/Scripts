#!/bin/bash

bashrc=~/.bashrc
zshrc=~/.zshrc
apt_conf=/etc/apt/apt.conf
wgetrc=~/.wgetrc
renviron=~/.Renviron
kioslaverc=~/.kde/share/config/kioslaverc

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

sed -i '/\[Proxy Settings\]/d' $kioslaverc
sed -i '/ProxyType=1/d' $kioslaverc
sed -i '/httpProxy/d' $kioslaverc
sed -i '/httpsProxy/d' $kioslaverc
sed -i '/ftpProxy/d' $kioslaverc

find ~/.mozilla/firefox -maxdepth 2 -type f -name prefs.js | while read f; do grep -m1 -q "network.proxy.type.*.2)\;$" "${f}" && { sed "s|network.proxy.type\", 2|network.proxy.type\", 0|g" "${f}" > "${f}.tmp" && mv -f "${f}.tmp" "${f}"; } done;

sed -i -e 's/ProxyType=2/ProxyType=0/g' .config/kioslaverc
# Restart kioslave

gsettings set org.gnome.system.proxy mode 'none'