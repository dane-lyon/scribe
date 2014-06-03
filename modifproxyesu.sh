#! /bin/bash
# remplacement valeur du proxy dans  la configuration ESU
cp -a /home/esu /home/esu.sav
read -p "Donnez l'ip de l'ancien proxu dans esu ?" ancienproxy
read -p "Donnez la valeur du nouveau proxy ?" nouveauproxy
# remplacement de l'ancienne valeur par la nouvelle valeur dans la configuration ESU existante
sed -i  "s/$ancienproxy/$nouveauproxy/g" /home/esu/Base/*/*xml
exit 0

