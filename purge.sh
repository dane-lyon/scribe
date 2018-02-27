#!/bin/bash
# Ce script purge certains fichiers dans les répertoires personnels
# DSI - DANE de l'académie de Lyon
# 7.1 - Juin 2017

if [ ! -d /var/log/purge ] ; then
mkdir /var/log/purge
fi

log="/var/log/purge/purge.log"
google=`ls /home/workgroups/commun/logiciels/ |grep -i '^googleearth$'`

purge()
{

## Suppression du cache GoogleEarth
if [ -n "$google" ] ; then
  find /home/workgroups/commun/logiciels/$google -iregex '^.*\.dat.*$' -exec rm -rf {} \; -print
fi

####################
## FIREFOX
# On n'utilise pas de chemin plus précis pour prendre aussi en compte les fichiers d'Eclair
# qui ne sont pas au même endroit
  echo + Nettoyage Firefox
# Purge des fichiers .sqlite de Firefox
find /home -maxdepth 10 -type f -iregex '^.*Firefox.*urlclassifier.\.sqlite$' -exec rm {} \; -print
# Purge des fichiers .sqlite.corrupt de Firefox
find /home -maxdepth 10 -type f -iregex '.*\.corrupt$' -exec rm {} \; -print
# Purge du cache de Firefox
find /home -maxdepth 10 -type d -iregex '^.*Firefox.*Cache.*$' -exec rm -r {} \; -print
# Purge des rapports de plantage de Firefox
find /home -maxdepth 10 -type f -iregex '^.*Firefox.Crash\ Reports.*$' -exec rm {} \; -print

if [ -f /root/drt/purge.conf ] ; then
. /root/drt/purge.conf
# Purge des fichier places.sqlite (bookmarks, historique)
	find /home -maxdepth 10 -type f -size +$TF -iregex '^.*places\.sqlite$' -exec rm {} \; -print
else
	find /home -maxdepth 10 -type f -size +11M -iregex '^.*places\.sqlite$' -exec rm {} \; -print
fi

####################

####################
## Suppression de fichiers dll vidéo dans Profile Firefox
echo + Nettoyage dll video Firefox

find /home -maxdepth 10 -type d -iregex '/home/.?/[^/]*/perso/config_eole/Application\ Data/Mozilla/Firefox/Profiles/Defaut/gmp' -exec rm -rf {} \; -print
find /home -maxdepth 10 -type d -iregex '/home/.?/[^/]*/perso/config_eole/Application\ Data/Mozilla/Firefox/Profiles/Defaut/gmp-widevinecdm' -exec rm -rf {} \; -print
find /home -maxdepth 10 -type d -iregex '/home/.?/[^/]*/perso/config_eole/Application\ Data/Mozilla/Firefox/Profiles/Defaut/gmp-gmpopenh264' -exec rm -rf {} \; -print
find /home -maxdepth 10 -type d -iregex '/home/.?/[^/]*/perso/config_eole/Application\ Data/Mozilla/Firefox/Profiles/Defaut/gmp-eme-adobe' -exec rm -rf {} \; -print
####################

####################
## LibreOffice
 echo + Nettoyage Libre Office
# Purge du cache de LibreOffice
find /home -maxdepth 12 -type f -iregex '^.*LibreOffice.*cache.*\.dat$' -exec rm {} \; -print
find /home -maxdepth 12 -type d -iregex '/home/.?/[^/]*/perso/\(.Config\|config_eole\)/Application\ Data/LibreOffice/3/user/uno\_packages/cache' -exec rm -rf {} \; -print
# find /home -maxdepth 12 -type d -iregex '/home/.?/[^/]*/perso/\(.Config\|config_eole\)/Application\ Data/LibreOffice/4/user/uno\_packages/cache' -exec rm -rf {} \; -print
####################

####################
## Fichiers verrous
 echo + Nettoyage des fichiers verrous .~lock.*
find /home -type f -name ".~lock.*" -exec rm -rf {} \; -print
####################

####################
## Fichiers dvd
  echo + Nettoyage DVD
find /home -maxdepth 10 -type f -iregex '^.*\.VOB$' -exec rm -r {} \; -print
####################

####################
## Fichiers du cache SunJava
  echo + Nettoyage Cache SunJava
find /home -maxdepth 14 -type f -iregex '^.*Sun.*cache.*$' -exec rm {} \; -print
####################

####################
## Suppression des dossiers de clé USB U3
  echo + Nettoyage Cle USB U3
find /home -maxdepth 10 -type d -iregex '/home/.?/[^/]*/perso/\(.Config\|config_eole\)/Application\ Data.U3' -exec rm -r {} \; -print
####################

####################
## Suppression des historiques de IE
  echo + Nettoyage Historique IE
find /home -maxdepth 10 -type d -iregex '/home/.?/[^/]*/perso/\(.Config\|config_eole\)/Local\ /Settings/Historique/History.IE5' -exec rm -r {} \; -print
####################

####################
## Suppression du fichier temporaire de Regressi
  echo + Nettoyage Regressi
find /home -maxdepth 10 -type d -iregex '/home/.?/[^/]*/perso/\(.Config\|config_eole\)/Application\ Data/Regressi/tampon/videoPA.avi' -exec rm -rf {} \; -print
####################

####################
## Suppression du fichier temporaire de Abatia
  echo + Nettoyage Abatia
find /home -maxdepth 10 -type d -iregex '/home/.?/[^/]*/perso/\(.Config\|config_eole\)/Application\ Data/Abatia-3-0' -exec rm -rf {} \; -print
####################




}

echo "">>  $log
echo "******************************************************************">>  $log
echo "Purge des /home/<user>/.Config/Application Data du $(date)">>  $log
purge 1>>  $log 2>&1
echo "Purge terminee a $(date)">>  $log

#copie du log dans le répertoire de l'admin
echo "+ Copie du log dans le répertoire de l'admin"
mkdir /home/a/admin/perso/purge-log &>/dev/null
'cp' $log /home/a/admin/perso/purge-log &>/dev/null
