if [ -d $1 -o ! -f $1 ]; then
    echo "Erreur, $1 n'existe pas ou est un répertoire" > /dev/stderr
    exit 2
fi