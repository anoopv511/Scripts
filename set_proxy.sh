#!/bin/bash

bashrc=~/.bashrc
apt_conf=/etc/apt/apt.conf
wgetrc=~/.wgetrc
renviron=~/.Renviron

http_proxy=http://proxy22.iitd.ac.in:3128			# Check if proxy works without authentication
https_proxy=https://proxy22.iitd.ac.in:3128
ftp_proxy=ftp://proxy22.iitd.ac.in:3128

if ! [ -z "$(tail -c 1 $apt_conf)" ]; then echo "" | sudo tee -a $apt_conf > /dev/null; fi
if ! grep -q "Acquire::http::Proxy" $apt_conf; then echo "Acquire::http::Proxy \"$http_proxy\";" | sudo tee -a $apt_conf > /dev/null; fi
if ! grep -q "Acquire::https::Proxy" $apt_conf; then echo "Acquire::https::Proxy \"$https_proxy\";" | sudo tee -a $apt_conf > /dev/null; fi
if ! grep -q "Acquire::ftp::Proxy" $apt_conf; then echo "Acquire::ftp::Proxy \"$ftp_proxy\";" | sudo tee -a $apt_conf > /dev/null; fi

if ! [ -z "$(tail -c 1 $bashrc)" ]; then echo "" >> $bashrc; fi
if ! grep -q "http_proxy" $bashrc; then echo "export http_proxy=$http_proxy" >> $bashrc; fi
if ! grep -q "https_proxy" $bashrc; then echo "export https_proxy=$https_proxy" >> $bashrc; fi
if ! grep -q "ftp_proxy" $bashrc; then echo "export ftp_proxy=$ftp_proxy" >> $bashrc; fi

git config --global http.proxy $http_proxy
git config --global https.proxy $https_proxy

npm config set proxy $http_proxy
npm config set https-proxy $http_proxy 				# Check with https_proxy

if ! [ -z "$(tail -c 1 $bashrc)" ]; then echo "" >> $wgetrc; fi
if ! grep -q "use_proxy" $wgetrc; then echo "use_proxy=yes" >> $wgetrc; fi
if ! grep -q "http_proxy" $wgetrc; then echo "http_proxy=$http_proxy" >> $wgetrc; fi
if ! grep -q "https_proxy" $wgetrc; then echo "https_proxy=$https_proxy" >> $wgetrc; fi

if ! [ -z "$(tail -c 1 $bashrc)" ]; then echo "" >> $renviron; fi
if ! grep -q "http_proxy" $renviron; then echo "http_proxy=$http_proxy" >> $renviron; fi
if ! grep -q "https_proxy" $renviron; then echo "https_proxy=$https_proxy" >> $renviron; fi