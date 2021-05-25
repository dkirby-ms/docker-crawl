#!/bin/sh

RCDIR=/data/rcs/$CRAWLVERSION
INPROGRESSDIR=/data/inprogress/$CRAWLVERSION
TTYRECDIR=/data/ttyrec/$1
MORGUEDIR=/data/morgue/$1
DEFAULT_RC=/app/settings/init.txt
PLAYERNAME=$1

mkdir -p $RCDIR
mkdir -p $INPROGRESSDIR
mkdir -p $TTYRECDIR
mkdir -p $MORGUEDIR

if [ ! -f ${RCDIR}/${PLAYERNAME}.rc ]; then
    cp ${DEFAULT_RC} ${RCDIR}/${PLAYERNAME}.rc
fi