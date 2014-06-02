#! /bin/bash
# remplacement valeur du proxy dans  la configuration ESU
cp -a /home/esu /home/esu.sav
# remplacement de "172.16.0.252 par 172.18.183.252" dans la configuration ESU existante
sed -i  "s/172.16.0.252/172.18.183.252/g" /home/esu/Base/*/*xml
