#!/bin/bash
# Ce script purge certains dossiers APPDATA dans les repertoires personnels des utilisateurs
# DANE de l'académie de Lyon
# Version 1 - Décembre 2013
# Version modifiée pour une migration vers 2.3 : suppression des dossiers libreoffice, openoffice, sun et microsoft contenus dans Application Data

if [ ! -d /var/log/purge ] ; then
mkdir /var/log/purge
fi

log="/var/log/purge/purgesimple.log"

purge()
{


## Open Office
  echo + Nettoyage Open Office
  # Suppression du dossier appdata de OpenOffice
find /home -maxdepth 8 -type d -iregex '/home/.?/[^/]*/perso/\.Config/Application\ Data/OpenOffice\.org' -exec rm -r {} \; -print
####################

####################
## LibreOffice
 echo + Nettoyage Libre Office
# Purge du dossier appdata de LibreOffice
find /home -maxdepth 8 -type d -iregex '/home/.?/[^/]*/perso/\.Config/Application\ Data/LibreOffice' -exec rm -r {} \; -print
####################


####################
## Suppression du dossier SUN
  echo + Nettoyage SunJava
find /home -maxdepth 8 -type d -iregex '/home/.?/[^/]*/perso/\.Config/Application\ Data/Sun' -exec rm -r {} \; -print
####################

####################
## Suppression du dossier MICROSOFT
  echo + Nettoyage Microsoft
  find /home -maxdepth 8 -type d -iregex '/home/.?/[^/]*/perso/\.Config/Application\ Data/Microsoft' -exec rm -r {} \; -print
####################

}

echo "">> $log
echo "******************************************************************">> $log
echo "Purge des /home/<user>/.Config/Application Data du $(date)">> $log
purge 1>> $log 2>&1
echo "Purge terminee a $(date)">> $log

#copie du log dans le répertoire de l'admin
echo "+ Copie du log dans le répertoire de l'admin"
mkdir /home/a/admin/perso/purge-log &>/dev/null
'cp' $log /home/a/admin/perso/purge-log &>/dev/null
