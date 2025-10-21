#!/bin/bash

read -p "Enter a sentance: " sentence
reversed_sentence=""
for word in $sentence; do
	reversed_sentence="$word $reversed_sentence"
done
echo "$reversed_sentence"
