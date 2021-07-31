#!/bin/bash
COUNTRYLIST='JP'

cd `dirname $0`
DIR=`pwd`
wget -q http://ftp.apnic.net/stats/apnic/delegated-apnic-latest -O ${DIR}/delegated-apnic-latest
:> ${DIR}/iplist.txt

for country in $COUNTRYLIST
do
    for ip in `cat delegated-apnic-latest | grep "apnic|$country|ipv4|"`
    do
        COUNTRY=`echo $ip | awk -F"|" '{ print $2 }'`
        IPADDR=`echo $ip | awk -F"|" '{ print $4 }'`
        TMPCIDR=`echo $ip | awk -F"|" '{ print $5 }'`

        FLTCIDR=32
        while [ $TMPCIDR -ne 1 ];
        do
            TMPCIDR=$((TMPCIDR/2))
            FLTCIDR=$((FLTCIDR-1))
        done
        echo "$IPADDR/$FLTCIDR" >> ${DIR}/iplist.txt
    done
done

echo "${COUNTRYLIST}のIPアドレスのファイルパスは以下です"
echo "${DIR}/iplist.txt"
