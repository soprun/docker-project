#!/bin/bash

if [ $# -ne 1 ]
then
	echo "Please enter site name"
else
	MITE=$1
fi

ping -c 3 $SITE > /dev/null

if [ $? != 0 ]
then
	echo `date +%F`
	echo "Your site seems to be down"
fi