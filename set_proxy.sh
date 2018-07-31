#!/bin/bash

bashrc=~/.bashrc
zshrc=~/.zshrc
apt_conf=/etc/apt/apt.conf
etc_env=/etc/environment
wgetrc=~/.wgetrc
renviron=~/.Renviron
kioslaverc=~/.kde/share/config/kioslaverc

http_proxy=http://proxy22.iitd.ac.in:3128			# Check if proxy works without authentication
https_proxy=https://proxy22.iitd.ac.in:3128
ftp_proxy=ftp://proxy22.iitd.ac.in:3128

if ! [ -z "$(tail -c 1 $apt_conf)" ]; then echo "" | sudo tee -a $apt_conf > /dev/null; fi
if ! grep -q "Acquire::http::Proxy" $apt_conf; then echo "Acquire::http::Proxy \"$http_proxy\";" | sudo tee -a $apt_conf > /dev/null; fi
if ! grep -q "Acquire::https::Proxy" $apt_conf; then echo "Acquire::https::Proxy \"$https_proxy\";" | sudo tee -a $apt_conf > /dev/null; fi
if ! grep -q "Acquire::ftp::Proxy" $apt_conf; then echo "Acquire::ftp::Proxy \"$ftp_proxy\";" | sudo tee -a $apt_conf > /dev/null; fi

if ! [ -z "$(tail -c 1 $etc_env)" ]; then echo "" | sudo tee -a $etc_env > /dev/null; fi
if ! grep -q "http_proxy" $etc_env; then echo "http_proxy=$http_proxy" | sudo tee -a $etc_env > /dev/null; fi
if ! grep -q "https_proxy" $etc_env; then echo "https_proxy=$https_proxy" | sudo tee -a $etc_env > /dev/null; fi
if ! grep -q "ftp_proxy" $etc_env; then echo "ftp_proxy=$ftp_proxy" | sudo tee -a $etc_env > /dev/null; fi

if ! [ -z "$(tail -c 1 $bashrc)" ]; then echo "" >> $bashrc; fi
if ! grep -q "http_proxy" $bashrc; then echo "export http_proxy=$http_proxy" >> $bashrc; fi
if ! grep -q "https_proxy" $bashrc; then echo "export https_proxy=$https_proxy" >> $bashrc; fi
if ! grep -q "ftp_proxy" $bashrc; then echo "export ftp_proxy=$ftp_proxy" >> $bashrc; fi

if ! [ -z "$(tail -c 1 $zshrc)" ]; then echo "" >> $zshrc; fi
if ! grep -q "http_proxy" $zshrc; then echo "export http_proxy=$http_proxy" >> $zshrc; fi
if ! grep -q "https_proxy" $zshrc; then echo "export https_proxy=$https_proxy" >> $zshrc; fi
if ! grep -q "ftp_proxy" $zshrc; then echo "export ftp_proxy=$ftp_proxy" >> $zshrc; fi

git config --global http.proxy $http_proxy
git config --global https.proxy $https_proxy

npm config set proxy $http_proxy
npm config set https-proxy $http_proxy 				# Check with https_proxy

if ! [ -z "$(tail -c 1 $wgetrc)" ]; then echo "" >> $wgetrc; fi
if ! grep -q "use_proxy" $wgetrc; then echo "use_proxy=yes" >> $wgetrc; fi
if ! grep -q "http_proxy" $wgetrc; then echo "http_proxy=$http_proxy" >> $wgetrc; fi
if ! grep -q "https_proxy" $wgetrc; then echo "https_proxy=$https_proxy" >> $wgetrc; fi

if ! [ -z "$(tail -c 1 $renviron)" ]; then echo "" >> $renviron; fi
if ! grep -q "http_proxy" $renviron; then echo "http_proxy=$http_proxy" >> $renviron; fi
if ! grep -q "https_proxy" $renviron; then echo "https_proxy=$https_proxy" >> $renviron; fi

if ! [ -z "$(tail -c 1 $kioslaverc)" ]; then echo "" >> $kioslaverc; fi
if ! grep -q "\[Proxy Settings\]" $kioslaverc; then echo "[Proxy Settings][\$i]" >> $kioslaverc; fi
if ! grep -q "ProxyType" $kioslaverc; then echo "ProxyType=1" >> $kioslaverc; fi
if ! grep -q "httpProxy" $kioslaverc; then echo "httpProxy=$http_proxy" >> $kioslaverc; fi
if ! grep -q "httpsProxy" $kioslaverc; then echo "httpsProxy=$https_proxy" >> $kioslaverc; fi
if ! grep -q "ftpProxy" $kioslaverc; then echo "ftpProxy=$ftp_proxy" >> $kioslaverc; fi

# find ~/.mozilla/firefox -maxdepth 2 -type f -name prefs.js | while read f; do grep -m1 -q "network.proxy.type.*.0)\;$" "${f}" && { sed "s|network.proxy.type\", 0|network.proxy.type\", 2|g" "${f}" > "${f}.tmp" && mv -f "${f}.tmp" "${f}"; } done;

sed -i -e 's/ProxyType=0/ProxyType=2/g' .config/kioslaverc
kbuildsycoca5 1&> /dev/null		# Restart kioslave

# gsettings set org.gnome.system.proxy.http host http://proxy22.iitd.ac.in
# gsettings set org.gnome.system.proxy.https host https://proxy22.iitd.ac.in
# gsettings set org.gnome.system.proxy.ftp host ftp://proxy22.iitd.ac.in
# gsettings set org.gnome.system.proxy.http port 3128
# gsettings set org.gnome.system.proxy.https port 3128
# gsettings set org.gnome.system.proxy.ftp port 3128
# gsettings set org.gnome.system.proxy use-same-proxy false
gsettings set org.gnome.system.proxy mode 'manual'

notify-send -i ~/.local/share/icons/add.png -t 3000 "Proxy" "Activated"