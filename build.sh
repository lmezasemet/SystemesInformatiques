#!/bin/bash

# on error exit
set -e

# Flags used here, not in `make html`:
#  -n   Run in nit-picky mode. Currently, this generates warnings for all missing references.
#  -W   Turwarnings into errors. This means that the build stops at the first warning and sphinx-build exits with exit status 1.
#  -N   Do not emi colors
#  -T   output full traceback
# --keep-going continue the processing after a warning

cd Theorie
echo "**** Theorie ****"

# old version: 
# sphinx-build  -nWNT --keep-going -b html . ../web/notes/Theorie
sphinx-build -nN -b html . ../web/notes/Theorie
# make html
sphinx-build -b epub . ../web/distrib
# sphinx-build -b latex . ../web/distrib
# cd ../web/distrib
# pdflatex LEPL1503-LINFO1252.tex
# cd ..
#sphinx-build -b spelling . /tmp

cd ..
cd Outils
echo "**** Outils ****"
sphinx-build -nN -b html . ../web/notes/Outils

# epub buliding fails, commented
# sphinx-build -b epub . ../web/distrib
#sphinx-build -b spelling . /tmp

cd ..

cd Exercices
echo "**** Exercices ****"
sphinx-build -nN -b html . ../web/notes/Exercices
#sphinx-build -b spelling . /tmp
cd ..

