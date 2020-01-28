#!/bin/bash
IP=$(curl -s ipinfo.io/ip)
R_IP=$(curl -s "https://riuna.com/smarthome/?get=nuc-k8-ip")
if [ "$IP" == "$R_IP" ]; then
    echo "IP did not change, aborting"
    exit 0
else
    curl -s "https://riuna.com/smarthome/?set=nuc-k8-ip&value=IP()" > /dev/null
    echo "IP updated in riuna/smarthome"
fi

export DOMAIN=riuna.com
export SUBDOMAIN=k
export USER=1105270
export PASSWORD=G_JM8Nt9Dz*AFMQNCrDt

URL=https://gateway.autodns.com/
#echo "url='$URL'"

read -r -d '' DOCUMENT << EOM
<?xml version="1.0" encoding="utf-8"?>
<request>
    <auth>
        <user>$USER</user>
        <password>$PASSWORD</password>
        <context>4</context>
    </auth>
    <task>
        <code>0205</code>
        <zone>
            <name>$DOMAIN</name>
            <system_ns>a.ns14.net</system_ns>
        </zone>
        <key></key>
    </task>
</request>
EOM
#echo "document='$DOCUMENT'"

REQ=$(echo $DOCUMENT | curl -X POST -T - $URL | node /home/joran/edit-zone.js $IP)
if [ -z "$REQ" ]; then
    echo "IP did not change"
else
    echo "$(date) | $IP" >> /home/joran/ip-history.txt
    echo $REQ | curl -X POST -T - $URL
fi
echo
