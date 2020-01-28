#!/bin/bash

if [ -f credentials.sh ]; then
  echo "loading credentials from:"
  echo "  - $(pwd)/credentials.sh"
else
  ./create-credentials.sh
fi

. credentials.sh

IFS=',' read -r -a array <<< "$DOMAIN"
ACME_DOMAINS=""
for element in "${array[@]}"
do
  ACME_DOMAINS="$ACME_DOMAINS -d *.$element"
done

$ACME_HOME/acme.sh --issue --dns --home "$CERT_HOME"$ACME_DOMAINS \
  --yes-I-know-dns-manual-mode-enough-go-ahead-please \
  | egrep '(Domain|TXT value)' | cut -d"'" -f 2 | ./doit.sh

$ACME_HOME/acme.sh --renew --home "$CERT_HOME"$ACME_DOMAINS \
  --yes-I-know-dns-manual-mode-enough-go-ahead-please
