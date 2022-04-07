#!/bin/sh

# 1. edit the lines below, give a hostname and token
# 2. Set this script as executable: sudo chmod +x dynv6.sh
# 3. Execute script, test and check.
# 4. Create a cron job. Example script on /opt to check every hour:
#    sudo crontab -e
#    0 * * * * /opt/dynv6.sh &>/dev/null 2>&1
# 
# Also, you can put a link to script on dhclient-exit-hooks.d:
#	sudo ln -s /opt/dynv6.sh /etc/dhcp/dhclient-exit-hooks.d/dynv6.sh
# Done!

HOSTNAME_DYNV6='' #Your Hostname
TOKEN_DYNV6=''    #Your http token

############################################

IP4ADDR=$(curl -s http://ipecho.net/plain)
IP6ADDR=`ip addr show eth0 | grep 'scope global dynamic' | grep -Po 'inet6 \K[0-9a-fA-F:]+'`

if [ "$IP4ADDR" = "" ]
then
        echo "Error: unable to determine IPv4 address" 1>&2
fi

if [ "$IP6ADDR" = "" ]
then
        echo "Error: unable to determine IPv6 address" 1>&2
fi

if [ "$IP4ADDR" != "" ]
then
	ping $HOSTNAME_DYNV6 -4 -c 1 > null # a little dirty - needed to update dns-cache
	IP4ADDR_DYNV6=$(dig $HOSTNAME_DYNV6 A +short)

	if [ "$IP4ADDR" != "$IP4ADDR_DYNV6" ]
	then
		echo "IPv4 adress has changed -> update ..."
		curl -s "https://ipv4.dynv6.com/api/update?hostname=$HOSTNAME_DYNV6&token=$TOKEN_DYNV6&ipv4=auto"
		echo "---"
	fi
fi

if [ "$IP6ADDR" != "" ]
then
        ping $HOSTNAME_DYNV6 -6 -c 1 > null # a little dirty - needed to update dns-cache
	IP6ADDR_DYNV6=$(dig $HOSTNAME_DYNV6 AAAA +short)

	if [ "$IP6ADDR" != "$IP6ADDR_DYNV6" ]
	then
		echo "IPv6 adress has changed -> update ..."
		curl -s "https://ipv6.dynv6.com/api/update?hostname=$HOSTNAME_DYNV6&token=$TOKEN_DYNV6&ipv6=auto&ipv6prefix=auto"
		echo "---"
	fi
fi
