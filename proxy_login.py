#!/usr/bin/env python

import requests
from bs4 import BeautifulSoup as bs
import os
from time import sleep
import signal
from subprocess import Popen, PIPE

class SignalHandler:
	signal = False
	control_proxy = False
	logout = False
	terminate = False
	def __init__(self):
		signal.signal(signal.SIGUSR1, self.logout_signal)
		signal.signal(signal.SIGINT, self.control_proxy_signal)
		signal.signal(signal.SIGTERM, self.exit_signal)

	def logout_signal(self,signum,frame):
		self.logout = not self.logout
		self.signal = True

	def control_proxy_signal(self,signum,frame):
		if(not self.control_proxy):
			os.system('notify-send "Proxy control - Script mode"')
		else:
			os.system('notify-send "Proxy control - User mode"')
		self.control_proxy = not self.control_proxy
		self.signal = True

	def exit_signal(self,signum,frame):
		os.system('notify-send "Exitting Proxy Script"')
		self.terminate = True
		self.signal = True

handler = SignalHandler()

def checkNet(i):
    status = os.popen('wget --spider "http://google.com" > /dev/null 2>&1 && echo -n success || echo -n failure').read()
    connected = status == 'success'
    if(connected and i != 0):
    	os.system('notify-send "Proxy logged in"')
    if(not connected and i != 0):
    	os.system('notify-send "Proxy logged out"')
    return connected

def detect_ethernet_cable():
	status = Popen('ethtool eno1 | grep "Link detected: no"', stdout=PIPE, stderr=PIPE, shell=True).communicate()[0]
	return status == ''

def wait_for_ethernet_cable(t):
	for j in range(t):
		if(detect_ethernet_cable()):
			for k in range(5):
				sleep(1)
				handler.signal = False
				if(not detect_ethernet_cable()):
					continue
			break
		else:
			sleep(1)
			handler.signal = False
		if(handler.terminate):
			exit()
		if(not handler.control_proxy):
			break

def get_session_id(raw_resp):
	soup = bs(raw_resp, 'lxml')
	id = [n['value'] for n in soup.find_all('input') if n['name'] == 'sessionid']
	return id[0]

payload_login = {'action': 'Validate', 'logon': 'Log on', 'userid': 'cs1150265', 'pass': 'NLVIvg4yS'}
payload_refresh = {'action': 'Refresh'}
payload_logout = {'action': 'logout', 'logout': 'Log out'}

def login(session):
	resp = session.get('https://proxy22.iitd.ernet.in/cgi-bin/proxy.cgi', verify='/home/anoop/.iitd.pem', proxies={'http':'','https':''})
	payload_login['sessionid'] = get_session_id(resp.content)
	payload_refresh['sessionid'] = payload_login['sessionid']
	payload_logout['sessionid'] = payload_login['sessionid']
	resp_login = session.post('https://proxy22.iitd.ernet.in/cgi-bin/proxy.cgi',verify='/home/anoop/.iitd.pem', proxies={'http':'','https':''},data=payload_login)

def refresh(session):
	resp_refresh = session.post('https://proxy22.iitd.ernet.in/cgi-bin/proxy.cgi',verify='/home/anoop/.iitd.pem', proxies={'http':'','https':''},data=payload_refresh)

def logout(session):
	resp_logout = session.post('https://proxy22.iitd.ernet.in/cgi-bin/proxy.cgi',verify='/home/anoop/.iitd.pem', proxies={'http':'','https':''},data=payload_logout)

wait_multipier = [1, 2, 5, 10]
init_notification = False
while(True):
	i=0
	while(not handler.control_proxy):
		if(not init_notification):
			os.system('notify-send "Automatic Proxy Login Script" "For using Script mode, send SIGINT signal"')
			init_notification = True
		sleep(120)
		handler.signal = False
		connected = checkNet(i)
		if(connected and handler.control_proxy):
			os.system('notify-send "Proxy logged in already" "For switching to Script mode, logout proxy from browser and send SIGINT signal"')
			handler.control_proxy = False
		if(handler.terminate):
			exit()
		if(handler.logout):
			handler.logout = False
	connected = checkNet(i)
	while(handler.control_proxy):
		i = i+1
		if(handler.terminate):
			if(connected):
				logout(session)
				sleep(5)
				handler.signal = False
				connected = checkNet(i)
			exit()
		if(not connected and not handler.logout):
			j = 0
			while(not detect_ethernet_cable()):
				wait_time = 120 * wait_multipier[j]
				os.system('notify-send "Ethernet cable unplugged" "Waiting for cable to be replugged (%ds)"' %wait_time)
				wait_for_ethernet_cable(wait_time)
				j = j+1 if j < 3 else 3
				if(not handler.control_proxy):
					break
			if(not handler.control_proxy):
				break
			session = requests.session()
			try:
				login(session)
			except requests.exceptions.ConnectionError:
				os.system('notify-send "Connection Error(1)" "Switching to User mode"')
				handler.control_proxy = False
				break
			connected = checkNet(i)
		if(connected and not handler.logout):
			j = 0
			while(not detect_ethernet_cable()):
				wait_time = 5 * wait_multipier[j]
				os.system('notify-send "Ethernet cable unplugged" "Waiting for cable to be replugged (%ds)"' %wait_time)
				wait_for_ethernet_cable(wait_time)
				j = j+1
				if(not handler.control_proxy or j == 3):
					break
			if(j == 3 and not detect_ethernet_cable()):
				continue
			if(not handler.control_proxy):
				break
			try:
				refresh(session)
			except requests.exceptions.ConnectionError:
				os.system('notify-send "Connection Error(2)" "Switching to User mode"')
				handler.control_proxy = False
				break
		if(connected and handler.logout):
			j = 0
			wait_for_ethernet_cable(180)
			if(not detect_ethernet_cable()):
				os.system('notify-send "Ethernet cable unplugged" "Assuming proxy logout after wait of 180s"')
				j = 1
			if(not handler.control_proxy):
				break
			try:
				if(j == 0):
					logout(session)
			except requests.exceptions.ConnectionError:
				os.system('notify-send "Connection Error(3)" "Switching to User mode"')
				handler.control_proxy = False
				break
			sleep(5)
			handler.signal = False
			connected = checkNet(i)
			if(handler.terminate):
				exit()
			if(not handler.logout):
				continue
		for x in range(12):
			sleep(10)
			if(not detect_ethernet_cable()):
				break
			if(handler.signal):
				handler.signal = False
				break
		if(not handler.control_proxy):
			logout(session)
			sleep(5)
			handler.signal = False
			connected = checkNet(i)
			if(handler.terminate):
				exit()