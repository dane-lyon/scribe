#/bin/bash
clear
# script qui copie & modifie le fichier /usr/share/eole/creole/distrib dans /usr/share/eole/creole/modif

# copie du fichier à modifier dans le répertoire modif
cp /usr/share/eole/creole/distrib/balado-connexion.php /usr/share/eole/creole/modif/balado-connexion.php

#suppression du s de https
sed -i "s/https/http/g" /usr/share/eole/creole/modif/balado-connexion.php

# génération du patch
gen_patch

echo "pensez à lancer un reconfigure ensuite"

