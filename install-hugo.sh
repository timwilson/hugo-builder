#!/bin/bash

# Install Hugo in the folder and create a 'www' directory to store the 
# markdown and config files.

THEME_URL="${1:-https://themes.gohugo.io/themes/hugo-theme-charlolamode/}
THEME_NAME=charlolamode

hugo new site www
cd www
git submodule add $THEME_URL themes/$THEME_NAME
echo "theme = '$THEME_NAME'" >> config.toml
