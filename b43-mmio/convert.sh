#!/bin/sh
if [ -e "$1" ]
then
	cp $1 $1.b43

	awk --posix -f mmio-tools/convert.awk $1.b43 > $1.tmp
	mv $1.tmp $1.b43

	awk --posix -f mmio-tools/filter.awk $1.b43 > $1.tmp
	mv $1.tmp $1.b43

	awk --posix -f mmio-tools/parse.awk $1.b43 > $1.tmp
	mv $1.tmp $1.b43

	sh ssb/ssb.sh $1.b43

	awk --posix -f b43/b43.awk $1.b43 > $1.tmp
	mv $1.tmp $1.b43
else
	echo "Pass filename as argument"
fi
