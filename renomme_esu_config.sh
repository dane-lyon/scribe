#!/bin/bash
# Ce script permet d'automatiser le renommage des dossiers .Config en config_eole
# DANE de l'académie de Lyon
# Librement inspiré de la documentation EOLE
# Version 1 - Janvier 2015

# sauvegarde de la configuration ESU
/bin/cp -a /home/esu /home/esu.sav

# remplacement de "\.config" par "\.config_eole dans la configuration ESU existante
/bin/sed -i  's/\\.[Cc]onfig/\\config_eole/g' /home/esu/Base/*/*xml

# deplacement du profil obligatoire XP retouche
# il faut au préalable avoir modifier le profil obligatoire en suivant la documentation
/bin/mv /home/a/admin/perso/ntuserXP.man /home/netlogon/profil/ntuser.man
# deplacement du profil obligatoire 7 retouche
/bin/mv /home/a/admin/perso/ntuser7.man /home/netlogon/profil.V2/ntuser7.man

# renomme les dossier .cCfonfig en config_eole
ldapsearch -x cn=DomainUsers | grep -i memberuid | awk '{print $2}'| sort -u | while read i
do
    echo "[ -d /home/${i:0:1}/${i}/perso/.Config ] && mv /home/${i:0:1}/${i}/perso/.Config /home/${i:0:1}/${i}/perso/config_eole"
    echo "[ -d /home/${i:0:1}/${i}/perso/.config ] && mv /home/${i:0:1}/${i}/perso/.config /home/${i:0:1}/${i}/perso/config_eole"
done

