#!/bin/sh

HOSTNAME_DYNV6='' # Dynv6 Hostname
TOKEN_DYNV6=''    # Dynv6 HTTP Token
ETH_DEV='eth0'    # Your local internet device   

############################################

IP4ADDR=$(curl -s http://ipecho.net/plain)
IP6ADDR=`ip addr show $ETH_DEV | grep 'scope global dynamic' | grep -Po 'inet6 \K[0-9a-fA-F:]+'`

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
	else
		echo "$IP4ADDR -> IPv4 Ok!"
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
	else
		echo "$IP6ADDR -> IPv6 Ok!"
	fi
fi
