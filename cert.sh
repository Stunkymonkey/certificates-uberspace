#!/bin/bash
#
# csr.sh: Certificate Signing Request Generator
# Copyright(c) 2015 Felix Bühler
# Copyright(c) 2005 Evaldo Gardenali <evaldo@gardenali.biz>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of the author nor the names of its contributors may
#    be used to endorse or promote products derived from this software
#    without specific prior written permission.
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
KEYBITS=4096
UBERMAIL="hallo@uberspace.de"
STARTSSL="./sub.class1.server.ca.pem"

PWD=$(pwd)
# be safe about permissions
LASTUMASK=$(umask)
umask 077

# create a config file for openssl
CONFIG=$(mktemp -q /tmp/openssl-conf.XXXXXXXX)
if [ ! $? -eq 0 ]; then
    echo "Could not create temporary config file. exiting"
    exit 1
fi

printf "Domain (the ending): "
read DOMAIN
if [ -z "$DOMAIN" ]; then
   echo "No Domain entered. Exiting..."
   exit
fi

printf "Subdomain (ie. mail, www): "
read SUBDOMAIN
if [ -z "$SUBDOMAIN" ]; then
   echo "No Subdomain entered. Exiting..."
   exit
fi

FQDN="${SUBDOMAIN}.${DOMAIN}"

CSR="./certs/$FQDN/${SUBDOMAIN}_csr.pem"
KEY="./certs/$FQDN/${SUBDOMAIN}_privatekey.pem"
CRT="./certs/$FQDN/${SUBDOMAIN}_startssl.pem"
mkdir -p "./certs/$FQDN"

# Config File Generation
cat <<EOF > $CONFIG
# -------------- BEGIN custom openssl.cnf -----
 HOME                    = $HOME
 oid_section             = new_oids
 [ new_oids ]
 [ req ]
 default_days            = 730            # how long to certify for
 default_keyfile         = $KEY
 distinguished_name      = req_distinguished_name
 encrypt_key             = no
 string_mask = nombstr
 [ req_distinguished_name ]
 commonName              = Common Name (eg, YOUR name)
 commonName_default      = $FQDN
 commonName_max          = 64
 [ v3_req ]
# -------------- END custom openssl.cnf -----
EOF

echo "Running OpenSSL..."
openssl req -batch -config $CONFIG -sha256 -newkey rsa:$KEYBITS -out $CSR
echo 
echo "Copy the following Certificate Request and paste into Startssl website to obtain a Certificate."
echo
cat $CSR 
echo
echo "        CSR: $CSR"
echo "Private Key: $KEY"
echo
echo "Please paste your generated certificate here and press Ctrl+D after finishing:"
echo
cat > $CRT 

rm $CONFIG
#restore umask
umask $LASTUMASK

# check with uber script
uberspace-prepare-certificate -c $CRT -k $KEY -i $STARTSSL

if [ $? -eq 0 ]; then
	uberspace-prepare-certificate -c $CRT -k $KEY -i $STARTSSL | \
		mail -s "Please add the certificates" $UBERMAIL && \
		echo "Mail was sent to $UBERMAIL" 
else
	echo "Unknown Error:"
	echo "Test it with this command below:"
	echo "uberspace-prepare-certificate -c $CRT -k $KEY -i $STARTSSL"
	exit 1
fi
