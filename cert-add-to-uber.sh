#!/bin/bash

# input for files
printf "Domain (with ending) : "
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
FOLDER=$SUBDOMAIN"."$DOMAIN

# check with uber script
MAIL=$(uberspace-prepare-certificate -c ./$FOLDER/${SUBDOMAIN}_startssl.pem -k ./$FOLDER/${SUBDOMAIN}_privatekey.pem  -i ./sub.class1.server.ca.pem)

# check if cert are correct
FINE="Let's check the files... Key is okay... Certificate is okay... Certificate matches key... All good! Feel free to mail to hallo@uberspace.de, please include the following information:"


if [[ "${MAIL/$FINE}" = "$MAIL" ]]; then
   # echo "True"
   echo -e "$MAIL"
   # mail it to uberspace
   echo -e "$MAIL" | mail -s "Please add the certificates" hallo@uberspace.de
   echo "Mail was sent to hallo@uberspace.de" 
else
   echo "Unknown Error:"
   echo
   echo $MAIL
   echo
   echo $FINE
   echo
   echo "Test it with this command below:"
   echo "uberspace-prepare-certificate -c ./"$FOLDER"/"${SUBDOMAIN}"_startssl.pem -k ./"$FOLDER"/"${SUBDOMAIN}"_privatekey.pem  -i ./sub.class1.server.ca.pem"
   exit
fi


