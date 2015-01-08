#!/bin/bash

#installation de wpkg-report pour Eole 2.4 !!
#version 09/2014

WPKGDIR="/home/wpkg"
WPKGRAPPORT="$WPKGDIR/rapports"
URL='ftp://ftp.gig-mbh.de/software/wpkg-package-states.zip'
FILE='wpkg-package-states.zip'
nom_machine=`CreoleGet smb_netbios_name`

#on teste la présence de eole-wpkg
dpkg -s eole-wpkg &>/dev/null
if [ $? != 0 ] ; then
    echo "Wpkg n'est pas installé sur ce serveur !"
    exit 1
else
    cd $WPKGDIR/softwares
    mkdir .EtatsClients &>/dev/null
    setfacl -Rm u::-wx,g::-wx,o::-wx .EtatsClients
    setfacl -Rdm u::rwx,g::rwx,o::rwx .EtatsClients
    mkdir -p $WPKGRAPPORT &>/dev/null
    cd $WPKGRAPPORT &>/dev/null
   # wget ftp://ftp.gig-mbh.de/software/wpkg-create-report.zip &>/dev/null
    wget $URL
    if [ $? != 0 ] ;then
        echo "l'archive n'a pas pu être téléchargée !"
        exit 1
    else
        echo "Téléchargement de l'archive OK !"
        unzip -o $FILE
        rm -rf $FILE
        #unzip -u wpkg-create-report.zip
        #rm -rf wpkg-create-report.zip
        sed -i 's/<wpkgBaseDir><\/wpkgBaseDir>/<wpkgBaseDir>\\\\'$nom_machine'\\wpkg\\<\/wpkgBaseDir>/g' settings.xml
        sed -i 's/<clientStateStorePath>clientStates/<clientStateStorePath>\\\\'$nom_machine'\\wpkg\\softwares\\.EtatsClients\\/g' settings.xml
        sed -i 's/<saveOutput>false/<saveOutput>true/g' settings.xml
        sed -i 's/<outputFile>c:\\/<outputFile>\\\\'$nom_machine'\\wpkg\\rapports\\Compte-Rendu-/g' settings.xml
        echo "cscript run.wsf" > $WPKGRAPPORT/'Création du rapport WPKG.bat'
        todos -u $WPKGRAPPORT/'Création du rapport WPKG.bat'
        if [ $? = 0 ] ; then
            echo "Creation du script de creation du rapport WPKG OK !"
        fi
        exit 0
    fi
fi
