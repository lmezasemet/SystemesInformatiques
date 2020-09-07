#!/bin/bash
for f in TP1-*.txt; do
	echo "Génération de la signature du fichier $f ..."
	sha1sum $f > $f.sha1
done
