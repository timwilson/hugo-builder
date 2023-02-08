#!/bin/bash

# Install Hugo in the folder and create a 'www' directory to store the 
# markdown and config files.

usage() {
	echo "Usage: $0 [ -r REPO_URL ] [ -t THEME_NAME ]" 1>&2
}

exit_abnormal() {
	usage
	exit 1
}

while getopts "r:t:" options; do

	case "${options}" in
		r)
			THEME_URL=${OPTARG}
			;;
		t)
			THEME_NAME=${OPTARG}
			;;
		:)
			echo "Error: -${OPTARG} requires an argument."
			exit_abnormal
			;;
		*)
			exit_abnormal
			;;
	esac
done

if [ "$THEME_URL" = "" ]; then
	echo "No theme URL detected."
	THEME_URL='https://themes.gohugo.io/themes/hugo-theme-charlolamode/'
	THEME_NAME='charlolamode'
elif [ "$THEME_NAME" = "" ]; then
	exit_abnormal
fi

hugo new site www
cd www
echo THEME_URL: $THEME_URL
echo THEME_NAME: $THEME_NAME
git submodule add $THEME_URL themes/$THEME_NAME
echo "theme = '$THEME_NAME'" >> config.toml
