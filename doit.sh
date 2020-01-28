#!/bin/bash

URL=https://gateway.autodns.com/

doChallenge () {
  echo "$1 $2"
  export DOMAIN=$1
  export CHALLENGE=$2
  if [ "$(echo $DOMAIN | cut -d'.' -f 3)" == "" ]; then
    export SUDBOMAIN=""
  else
    export DOMAIN=$(echo $DOMAIN | cut -d'.' -f 2,3)
    export SUBDOMAIN=$(echo $DOMAIN | cut -d'.' -f 1)
  fi
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
  REQ=$(echo $DOCUMENT | curl -X POST -T - $URL | node $(pwd)/edit-zone.js)
  if [ -z "$REQ" ]; then
    echo "could not generate request for $DOMAIN"
  else
    echo $REQ | curl -X POST -T - $URL
  fi
  echo ""

}

while read -r txt_record; do
  read -r challenge
  txt_record=${txt_record:16}
  doChallenge $txt_record $challenge
done
