#!/bin/sh
TTYRECDIR=/data/ttyrec/$1
MORGUEDIR=/data/morgue/$1
DEFAULT_RC=/webserver/settings/init.txt
PLAYERNAME=$1

mkdir -p $TTYRECDIR
mkdir -p $MORGUEDIR

for CRAWLVERSION in $SUPPORTED_CRAWL_VERSIONS
do
RCDIR=/data/rcs/$CRAWLVERSION
INPROGRESSDIR=/data/inprogress/$CRAWLVERSION
mkdir -p $RCDIR
mkdir -p $INPROGRESSDIR
if [ ! -f ${RCDIR}/${PLAYERNAME}.rc ]; then
    cp ${DEFAULT_RC} ${RCDIR}/${PLAYERNAME}.rc
fi
done
