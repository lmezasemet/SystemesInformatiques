#!/bin/bash
# exemple_for.sh
students="Julie Maxime Hakim"
for s in $students
do
	l=`wc -l TP1-$s.txt | cut -d' ' -f1`
	echo "Bonjour $s, ton compte rendu de TP comporte $l lignes."
done
