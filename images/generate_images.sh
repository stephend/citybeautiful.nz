#!/usr/bin/env bash

if [ `uname` == 'Linux' ]
	then
	export MAGICK_CONVERT="convert"
else
	export MAGICK_CONVERT="magick convert"
fi

crush_finished() {
	if [ ${I_EXT} == 'png' ]; then
		pngcrush -ow -q ${O_NAME}
	else
		jpegoptim --strip-all -q -m 90 ${O_NAME}
	fi
}

convert_tn() {
	export O_NAME="${I_DIR}/${I_FIRST}.tn${1}.${I_EXT}"
	if [ ! -e ${O_NAME} -a $I_WIDTH -ge ${1} ] ; then
		$MAGICK_CONVERT $I_FULLNAME \
			-strip -resize "${1}x${1}^" -gravity center -crop 144x144+0+0 +repage \
			"${O_NAME}"
		crush_finished
	fi	
}

convert_w_jpg() {
	export O_NAME="${I_DIR}/${I_FIRST}.w${1}.jpg"
	if [ ! -e ${O_NAME} -a $I_WIDTH -ge ${1} ] ; then
		$MAGICK_CONVERT $I_FULLNAME \
			-resize "${1}x" \
			"${O_NAME}"
		crush_finished
	fi	
}

convert_w() {
	export O_NAME="${I_DIR}/${I_FIRST}.w${1}.${I_EXT}"
	if [ ! -e ${O_NAME} -a $I_WIDTH -ge ${1} ] ; then
		$MAGICK_CONVERT $I_FULLNAME \
			-resize "${1}x" \
			"${O_NAME}"
		crush_finished
	fi
}

find -regextype posix-egrep -regex '.*\.orig\.(jpg|jpeg|gif|png)$' | while read line; do
	export I_FULLNAME=$line
	export I_BASENAME=`basename $I_FULLNAME`
	export I_DIR=`dirname $I_FULLNAME`
	export I_EXT=${I_BASENAME##*.orig.}
	export I_FIRST=${I_BASENAME%.orig.*}


	# Clear existing files
	rm ${I_DIR}/${I_FIRST}.{tn144,tn300,w600,w800,w960}.*

	read -r I_WIDTH I_HEIGHT <<< $( $MAGICK_CONVERT $I_FULLNAME -format "%w %h" info:)

	echo "${I_DIR}/${I_FIRST} (${I_EXT}, ${I_WIDTH}x${I_HEIGHT})" 

	convert_tn 144
	convert_tn 300
	convert_w_jpg 600
	convert_w 800
	convert_w 960
done
