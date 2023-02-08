#!/bin/bash

# Install Hugo in the folder and create a 'www' directory to store the 
# markdown and config files.

hugo new site www
cd www
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke themes/ananke
echo "theme = 'ananke'" >> config.toml
