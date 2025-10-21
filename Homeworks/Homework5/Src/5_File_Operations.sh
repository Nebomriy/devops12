#!/bin/bash

read -p "Specify source folder: " folder1
read -p "Specify destination folder: " folder2
read -p "Specify filename for copy in source folder: " file

if [ ! -d "$folder1" ]; then
    echo "Source folder does not exist!"
    exit 1
fi

if [ ! -d "$folder2" ]; then
    echo "Destination folder does not exist!"
    exit 1
fi

if [ -e "$folder1/$file" ]; then
	cp "$folder1/$file" "$folder2"
	echo "File $file successfully copied to the destination folder"
else echo "File not found"
fi 
