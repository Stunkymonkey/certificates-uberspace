#!/bin/bash

# be safe about permissions
LASTUMASK=`umask`
umask 077

# OpenSSL for HPUX needs a random file
RANDOMFILE=$HOME/.rnd

# create a config file for openssl
CONFIG=`mktemp -q /tmp/openssl-conf.XXXXXXXX`
if [ ! $? -eq 0 ]; then
    echo "Could not create temporary config file. exiting"
    exit 1
fi

echo "Private Key and Certificate Signing Request Generator"
# echo "This script was designed to suit the request format needed by"
echo "the CAcert Certificate Authority. www.Startssl.com"
echo

PWD=$(pwd)

printf "Domain (with ending) : "
read DOMAIN
if [ -z "$DOMAIN" ]; then
   echo "No Domain entered. Exiting..."
   exit
fi

printf "Subdomain (ie. mail, www): "
read HOST
if [ -z "$HOST" ]; then
   echo "No Subdomain entered. Exiting..."
   exit
fi

FOLDER=${HOST}"."${DOMAIN}
mkdir $FOLDER

COMMONNAME=${HOST}.${DOMAIN}
KEYBITS=4096

SANAMES=""

# Config File Generation

cat <<EOF > $CONFIG
# -------------- BEGIN custom openssl.cnf -----
 HOME                    = $HOME
EOF

if [ "`uname -s`" = "HP-UX" ]; then
    echo " RANDFILE                = $RANDOMFILE" >> $CONFIG
fi

cat <<EOF >> $CONFIG
 oid_section             = new_oids
 [ new_oids ]
 [ req ]
 default_days            = 730            # how long to certify for
 default_keyfile         = ./$FOLDER/${HOST}_privatekey.pem
 distinguished_name      = req_distinguished_name
 encrypt_key             = no
 string_mask = nombstr
EOF

if [ ! "$SANAMES" = "" ]; then
    echo "req_extensions = v3_req # Extensions to add to certificate request" >> $CONFIG
fi

cat <<EOF >> $CONFIG
 [ req_distinguished_name ]
 commonName              = Common Name (eg, YOUR name)
 commonName_default      = $COMMONNAME
 commonName_max          = 64
 [ v3_req ]
EOF

if [ ! "$SANAMES" = "" ]; then
    echo "subjectAltName=$SANAMES" >> $CONFIG
fi

echo "# -------------- END custom openssl.cnf -----" >> $CONFIG

echo "Running OpenSSL..."
openssl req -batch -config $CONFIG -sha256 -newkey rsa:$KEYBITS -out ./$FOLDER/${HOST}_csr.pem
echo "Copy the following Certificate Request and paste into Startssl website to obtain a Certificate."
echo "When you receive your certificate, you 'should' enter it in the "./$FOLDER/${HOST}_startssl.pem
echo
cat ./$FOLDER/${HOST}_csr.pem
echo
echo "The Certificate request is also available in ./$FOLDER/${HOST}_csr.pem"
echo "The Private Key is stored in ./$FOLDER/${HOST}_privatekey.pem"
echo
touch ./$FOLDER/${HOST}_startssl.pem

rm $CONFIG

#restore umask
umask $LASTUMASK
