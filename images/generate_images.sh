#!/bin/bash
find -regextype posix-egrep -regex '.*\.orig\.(jpg|jpeg|gif|png)$' | while read line; do
	export I_FULLNAME=$line
	export I_BASENAME=`basename $I_FULLNAME`
	export I_DIR=`dirname $I_FULLNAME`
	export I_EXT=${I_BASENAME##*.orig.}
	export I_FIRST=${I_BASENAME%.orig.*}

	echo "${I_DIR}/${I_FIRST} (${I_EXT})" 

	convert $I_FULLNAME \
		-strip -resize "144x144^" -gravity center -crop 144x144+0+0 +repage \
		"${I_DIR}/${I_FIRST}.tn144.${I_EXT}"
	convert $I_FULLNAME \
		-strip -resize "300x300^" -gravity center -crop 300x300+0+0 +repage \
		"${I_DIR}/${I_FIRST}.tn300.${I_EXT}"
	convert $I_FULLNAME \
		-resize "600x" \
		"${I_DIR}/${I_FIRST}.w600.jpg"
	convert $I_FULLNAME \
		-resize "800x" \
		"${I_DIR}/${I_FIRST}.w800.${I_EXT}"
done

find -regextype posix-egrep -regex '.*\.(tn144|tn300|w600|w800)\.(png)$' | while read line; do
	#echo $line
	#ls -l $line
	pngcrush -ow -q $line 
	#ls -l $line
done

find -regextype posix-egrep -regex '.*\.(tn144|tn300|w600|w800)\.(jpg|jpeg)$' | while read line; do
	#echo $line
	#ls -l $line
	jpegoptim -s -q -m 90 $line 
	#ls -l $line
done