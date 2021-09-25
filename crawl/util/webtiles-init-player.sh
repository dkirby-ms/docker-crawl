#!/bin/sh
INPROGRESSDIR=/tdata/inprogress/$CRAWLVERSION
TTYRECDIR=/tdata/ttyrec/$1
MORGUEDIR=/tdata/morgue/$1
DEFAULT_RC=/webserver/settings/init.txt
PLAYERNAME=$1

mkdir -p $INPROGRESSDIR
mkdir -p $TTYRECDIR
mkdir -p $MORGUEDIR

for CRAWLVERSION in $SUPPORTED_CRAWL_VERSIONS
do
RCDIR=/data/rcs/$CRAWLVERSION
mkdir -p $RCDIR
if [ ! -f ${RCDIR}/${PLAYERNAME}.rc ]; then
    cp ${DEFAULT_RC} ${RCDIR}/${PLAYERNAME}.rc
fi
done
