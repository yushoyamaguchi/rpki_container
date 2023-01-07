#!/bin/sh -

OPENSSL=openssl

DATE=`/bin/date +%Y-%m%d`
SERIAL=`cat /proc/meminfo | ${OPENSSL} sha256 -sha256 |cut -d " " -f 2 | cut -c 1-11`
echo $SERIAL

OPENSSLCNF=opensslcnf-template.txt
CANAME=CANAME

[ -f ${CANAME}.cer ] && mv ${CANAME}.cer ${CANAME}.cer.old

${OPENSSL} req                  \
        -new                    \
        -x509                   \
        -config ${OPENSSLCNF}   \
        -out  ${CANAME}.cer    \
        -keyout  ${CANAME}.key  \
        -outform    DER         \
        -days       1825     \
        -set_serial 0x${SERIAL} \
        -extensions x509v3_extensions

if [ -f ${CANAME}.cer ] ; then
  echo "converting .cer to .pem."
  ${OPENSSL} x509 -inform der -in ${CANAME}.cer -outform pem -out ${CANAME}.pem
  echo "verifing "
  ${OPENSSL} verify -CAfile ${CANAME}.pem ${CANAME}.pem
  echo ${CANAME}.cer was created.
else
  echo ${CANAME}.cer was not created.
fi