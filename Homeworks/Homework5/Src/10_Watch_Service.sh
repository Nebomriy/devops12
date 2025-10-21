#!/bin/bash

dir="$HOME/watch"

while true;  do
	for file in "$dir"/*; do 
	if [ -f "$file" ] && [[ "$file" != *.back ]]; then
		cat "$file" 
		mv "$file" "$file.back" 
	fi	
	done
	sleep 5

done
