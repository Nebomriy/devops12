#!/bin/bash

read -p "Write file name please: " filename

if [ -f "$filename" ]; then
	cat "$filename" 
else
	echo "File not exist!"
fi
