#!/usr/bin/env bash

if [ `uname` == 'Linux' ]
	then
	export MAGICK_CONVERT="convert"
else
	export MAGICK_CONVERT="magick convert"
fi

find -regextype posix-egrep -regex '.*\.orig\.(jpg|jpeg|gif|png)$' | while read line; do
	export I_FULLNAME=$line
	export I_BASENAME=`basename $I_FULLNAME`
	export I_DIR=`dirname $I_FULLNAME`
	export I_EXT=${I_BASENAME##*.orig.}
	export I_FIRST=${I_BASENAME%.orig.*}

	echo "${I_DIR}/${I_FIRST} (${I_EXT})" 

	$MAGICK_CONVERT $I_FULLNAME \
		-strip -resize "144x144^" -gravity center -crop 144x144+0+0 +repage \
		"${I_DIR}/${I_FIRST}.tn144.${I_EXT}"
	$MAGICK_CONVERT $I_FULLNAME \
		-strip -resize "300x300^" -gravity center -crop 300x300+0+0 +repage \
		"${I_DIR}/${I_FIRST}.tn300.${I_EXT}"
	$MAGICK_CONVERT $I_FULLNAME \
		-resize "600x" \
		"${I_DIR}/${I_FIRST}.w600.jpg"
	$MAGICK_CONVERT $I_FULLNAME \
		-resize "800x" \
		"${I_DIR}/${I_FIRST}.w800.${I_EXT}"
	$MAGICK_CONVERT $I_FULLNAME \
		-resize "800x" \
		"${I_DIR}/${I_FIRST}.w960.${I_EXT}"
done

find -regextype posix-egrep -regex '.*\.(tn144|tn300|w600|w800|w960)\.(png)$' | while read line; do
	#echo $line
	#ls -l $line
	pngcrush -ow -q $line 
	#ls -l $line
done

find -regextype posix-egrep -regex '.*\.(tn144|tn300|w600|w800|w960)\.(jpg|jpeg)$' | while read line; do
	#echo $line
	#ls -l $line
	jpegoptim --strip-all -q -m 90 $line 
	#ls -l $line
done