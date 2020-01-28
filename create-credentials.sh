#!/bin/bash

# set defaults
DOMAIN=example.com
USER=$(whoami)
PASSWORD=
ACME_HOME=/home/$(whoami)/.acme.sh

# load credentials from previous run
if [ -f credentials.sh ]; then
  . credentials.sh
fi

# DOMAIN
read -p "Domain ($DOMAIN): " T_DOMAIN
if [ "$T_DOMAIN" != "" ]; then
  DOMAIN=$T_DOMAIN
fi

# USER
read -p "User ($USER): " T_USER
if [ "$T_USER" != "" ]; then
  USER=$T_USER
fi

# PASSWORD
read -sp "Password (***): " T_PASSWORD
if [ "$T_PASSWORD" != "" ]; then
  PASSWORD=$T_PASSWORD
fi
echo ""

# ACME_HOME
read -sp "Acme path ($ACME_HOME): " T_ACME_HOME
if [ "$T_ACME_HOME" != "" ]; then
  ACME_HOME=$T_ACME_HOME
fi

# write changes to credentials.sh
cat > credentials.sh << EOF
#!/bin/bash
export DOMAIN=$DOMAIN
export USER=$USER
export PASSWORD=$PASSWORD
export ACME_HOME=$ACME_HOME
EOF
