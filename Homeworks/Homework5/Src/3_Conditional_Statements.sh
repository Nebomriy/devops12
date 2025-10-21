#!/usr/bin/env bash

read -p "Write file name: " file

if [ -e "$file" ]; then
echo "File exists"
else
echo "File doesn't exist"
fi  
