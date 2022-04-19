#!/bin/sh

HOSTNAME_DYNV6='' # Dynv6 Hostname
TOKEN_DYNV6=''    # Dynv6 HTTP Token

############################################

IP4ADDR=$(curl -s https://ip4.seeip.org)
IP6ADDR=`ip -6 addr show scope global dynamic mngtmpaddr up|egrep -o '([0-9a-f:]+:+)+[0-9a-f]+'`

if [ "$IP4ADDR" = "" ]
then
        echo "Error: unable to determine IPv4 address"
fi

if [ "$IP6ADDR" = "" ]
then
        echo "Error: unable to determine IPv6 address"
fi

if [ "$IP4ADDR" != "" ]
then
	if [ -f "/tmp/IP4ADDR_DYNV6" ]
	then
		IP4ADDR_DYNV6=$(cat /tmp/IP4ADDR_DYNV6)
	else
		ping $HOSTNAME_DYNV6 -4 -c 1 >/dev/null 2>&1
		IP4ADDR_DYNV6=$(dig $HOSTNAME_DYNV6 A +short)
		echo $IP4ADDR_DYNV6 > /tmp/IP4ADDR_DYNV6
	fi

	if [ "$IP4ADDR" != "$IP4ADDR_DYNV6" ]
	then
		echo "IPv4 adress has changed -> update ..."
		curl -s "https://ipv4.dynv6.com/api/update?hostname=$HOSTNAME_DYNV6&token=$TOKEN_DYNV6&ipv4=auto"
		echo "---"
		rm /tmp/IP4ADDR_DYNV6
	else
		echo "$IP4ADDR -> IPv4 Ok!"
	fi
fi

if [ "$IP6ADDR" != "" ]
then
	if [ -f "/tmp/IP6ADDR_DYNV6" ]
	then
		IP6ADDR_DYNV6=$(cat /tmp/IP6ADDR_DYNV6)
	else
		ping $HOSTNAME_DYNV6 -6 -c 1 >/dev/null 2>&1
		IP6ADDR_DYNV6=$(dig $HOSTNAME_DYNV6 AAAA +short)
		echo $IP6ADDR_DYNV6 > /tmp/IP6ADDR_DYNV6
	fi

	if [ "$IP6ADDR" != "$IP6ADDR_DYNV6" ]
	then
		echo "IPv6 adress has changed -> update ..."
		curl -s "https://ipv6.dynv6.com/api/update?hostname=$HOSTNAME_DYNV6&token=$TOKEN_DYNV6&ipv6=auto&ipv6prefix=auto"
		echo "---"
		rm /tmp/IP6ADDR_DYNV6
	else
		echo "$IP6ADDR -> IPv6 Ok!"
	fi
fi
