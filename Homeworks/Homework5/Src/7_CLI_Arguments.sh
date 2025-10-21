#!/bin/bash

read -p "Write file name: " filename

lines=$(wc -l < "$filename")

echo "Number of lines in file $filename = $lines"
