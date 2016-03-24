#!/bin/bash

########### ce script permet de renseigner l'adresse du proxy et le port pour firefox dans esu #############
###########  DANE rectorat de lyon #########
###########  Virginie  Favrat  &  Jean Philippe Patrizio. ########


########### on efface l'ecran
clear

echo -e "\n\n\n\n"

echo "ce script permet de modifier dans tous les groupes machines, l'adresse du serveur proxy."

#### on sauvegarde le dossier esu

cp -r /home/esu /home/esu.bak

echo -e "\n\n"

read -p "		Saisissez l'adresse du proxy: (172.16.0.252) que vous souhaitez déployer : " proxy

read -p "		Saisissez le port  du proxy: (3128) que vous souhaitez déployer : " port


#### Attention on échape les caractères // avec # comme séparateur.

#domaine=$(echo $proxy | sed 's#/#\\/#g')

#### On remplace

sed -i 's/\(<Variable nom="network.proxy.http.*>\)\(.*\)\(<\/Variable>\)/\1'$proxy'\3/' /home/esu/Base/*/*xml

sed -i 's/\(<Variable nom="network.proxy.http_port.*>\)\(.*\)\(<\/Variable>\)/\1'$port'\3/' /home/esu/Base/*/*xml

