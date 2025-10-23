#!/bin/bash

echo ""
echo  "Let's play! Try to guess the number from 1 to 100. "
echo ""
sleep 1
echo  "You'll have 5 attempts in total. Good luck! "
echo ""
sleep 1
secret=$((RANDOM % 100 + 1))
#echo "$secret"   #показує результат для отладки
for i in {1..5}; do
	read -p "Write please your option $i: " number
	if (( number==secret )); then
		echo ""
		echo "You won! My congratulations!"
		exit 0
	elif (( number < secret )); then
		echo "Good attempt, but try choose little bit bigger number.. "
	elif (( number > secret )); then
		echo "Good attempt, but try choose little bit smaller number.. "
	fi
done
echo ""
echo "We are sorry, but you lose.. Correct number was $secret.  "
