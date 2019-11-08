#!/bin/bash
#########################################################
#
# Netmapper script.
#
# Install Dependencies
# 1) apt-get update && apt-get install nmap
#
#########################################################
clear
# Create temp files
echo '#################################################################'
echo
echo '.##....##.########.########.##.....##....###....########.'
echo '.###...##.##..........##....###...###...##.##...##.....##'
echo '.####..##.##..........##....####.####..##...##..##.....##'
echo '.##.##.##.######......##....##.###.##.##.....##.########.'
echo '.##..####.##..........##....##.....##.#########.##.......'
echo '.##...###.##..........##....##.....##.##.....##.##.......'
echo '.##....##.########....##....##.....##.##.....##.##.......'
echo
echo '						Version 1.0								   '
echo
echo '#################################################################'
echo
echo 'Verifying dependcies...'
echo

echo 'Checking for NMAP...'
if [ -e /usr/bin/nmap ]
  then
	  echo 'NMAP binaries found!'
  else
  	echo 'Error: NMAP binaries NOT FOUND!'
  	echo 'Please update repos and run apt-get install nmap'
  	echo 'Bailing!'
	  exit
fi
echo

echo 'Creating temporary files...'
if [ -e /tmp/netmap ]
  then
	rm -R /tmp/netmap
  else
	mkdir /tmp/netmap
	mkdir /tmp/netmap/logs
	mkdir /tmp/netmap/resources
fi
echo

echo 'Querying interfaces (state UP)...'
ip link show | grep 'state UP'
echo
echo 'Which interface do you want to want to query?'
#read INTERFACE
#HostIPAddr=$(ip addr show $INTERFACE | grep 'inet ' | awk -F'[: ]+' '{ print $3 }')
echo
HostIPAddr=$(ip addr show enp0s25 | grep 'inet ' | awk -F'[: ]+' '{ print $3 }')
echo "Your IP address is: $HostIPAddr"
HostNetworkAddr=$(awk -F"." '{print $1"."$2"."$3".0"}'<<<$HostIPAddr)
HostMask=$(awk -F"/" '{print "/"$2}'<<<$HostIPAddr)
HostNetwork=$HostNetworkAddr$HostMask
echo "The network you will be scanning is: $HostNetwork"
echo
echo 'Harvesting IP addresses...'
nmap -v -sn $HostNetwork -oG /tmp/netmap/resources/iplist.txt
cat /tmp/netmap/resources/iplist.txt | grep 'Status: Up' > /tmp/netmap/resources/targets.txt
echo
cat /tmp/netmap/resources/iplist.txt < awk -F"." '{print $1"."$2"."$3"."$4}'

########################################################################

echo "Would you like to keep the temporary files? [y/N]"
read ANSWER
if [ "$ANSWER" = "y" ]
  then
    echo "Done!"
    exit
  else
    echo 'Cleaning up...'
  	rm -R /tmp/netmap
fi
echo
echo '#################################################################'
echo
echo 'Done!'
echo
exit
