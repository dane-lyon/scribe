#!/bin/bash
# Ce script purge certains fichiers dans les repertoires personnels
# DSI - DANE de l'académie de Lyon
# 6.1 - Avril 2017

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
# On n'utilise pas de chemin plus precis pour prendre aussi en compte les fichiers d'Eclair
# qui ne sont pas au meme endroit
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
## Open Office
  echo + Nettoyage Open Office
# Purge du cache d'OpenOffice
find /home -maxdepth 12 -type f -iregex '^.*OpenOffice\.org.*cache.*\.dat$' -exec rm {} \; -print
# Suppression des anciens dossier OpenOffice.org2
find /home -maxdepth 10 -type d -iregex '/home/.?/[^/]*/perso/\(.Config\|config_eole\)/Application\ Data/OpenOffice\.org2' -exec rm -r {} \; -print
####################

####################
## LibreOffice
 echo + Nettoyage Libre Office
# Purge du cache de LibreOffice
find /home -maxdepth 12 -type f -iregex '^.*LibreOffice.*cache.*\.dat$' -exec rm {} \; -print
find /home -maxdepth 12 -type d -iregex '/home/.?/[^/]*/perso/\(.Config\|config_eole\)/Application\ Data/LibreOffice/3/user/uno\_packages/cache' -exec rm -rf {} \; -print
find /home -maxdepth 12 -type d -iregex '/home/.?/[^/]*/perso/\(.Config\|config_eole\)/Application\ Data/LibreOffice/4/user/uno\_packages/cache' -exec rm -rf {} \; -print
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
## Suppression des dossiers de cle USB U3
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
