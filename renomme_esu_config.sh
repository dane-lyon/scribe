#!/bin/bash
# Ce script permet d'automatiser le renommage des dossiers .Config en config_eole
# DANE de l'académie de Lyon
# ATTENTION, lire la documentation de la DANE avant utilisation !!
# Librement inspiré de la documentation EOLE
# Version 1.2 - Janvier 2015

# sauvegarde de la configuration ESU
/bin/cp -a /home/esu /home/esu.sav

# remplacement de "\.config" par "\.config_eole dans la configuration ESU existante
/bin/sed -i  's/\\.[Cc]onfig/\\config_eole/g' /home/esu/Base/*/*xml

# deplacement du profil obligatoire XP retouche
# il faut au préalable avoir modifié le profil obligatoire en suivant la documentation
/bin/mv /home/a/admin/perso/ntuserXP.man /home/netlogon/profil/ntuser.man
# deplacement du profil obligatoire 7 retouche
/bin/mv /home/a/admin/perso/ntuser7.man /home/netlogon/profil.V2/ntuser.man

 #mettre le droit de lecture aux profils obligatoires
 chown -R root:root /home/netlogon/profil*
 chmod 0644 /home/netlogon/profil/ntuser.man
 chmod 0644 /home/netlogon/profil.V2/ntuser.man 

# renomme les dossier .cCfonfig en config_eole
ldapsearch -x cn=DomainUsers | grep -i memberuid | awk '{print $2}'| sort -u | while read i
do
    # suppression du dossier qui ne devrait pas exister
    [ -d /home/${i:0:1}/${i}/perso/config_eole ] && rm -rf /home/${i:0:1}/${i}/perso/config_eole
    [ -d /home/${i:0:1}/${i}/perso/.Config ] && mv /home/${i:0:1}/${i}/perso/.Config /home/${i:0:1}/${i}/perso/config_eole
    [ -d /home/${i:0:1}/${i}/perso/.config ] && mv /home/${i:0:1}/${i}/perso/.config /home/${i:0:1}/${i}/perso/config_eole
done 
