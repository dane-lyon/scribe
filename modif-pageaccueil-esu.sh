#! /bin/bash
# remplacement valeur de la page url par défaut dans la configuration ESU

cp -a /home/esu /home/esu.backup

read -p "Veuillez indiquer l'ancien url par défaut :" oldurl
read -p "Donnez la valeur du nouveau url :" newurl

# remplacement de l'ancienne valeur par la nouvelle valeur dans la configuration ESU existante
sed -i  "s|$oldurl|$newurl|g" /home/esu/Base/*/*xml

exit 0
