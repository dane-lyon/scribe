#!/bin/bash
# Ce script purge certains fichiers dans les repertoires personnels une fois par mois
# DSI - DANE de l'académie de Lyon
# 1.0 - Mai 2017

if [ ! -d /var/log/purge ] ; then
mkdir /var/log/purge
fi

log="/var/log/purge/purge_mensuelle.log"

purge_mensuelle()
{
    ####################
    ## Suppression des dossiers com.makeblock.Scratch.old_version
    echo + Nettoyage MBlock
    #On vérifie si le package mBlock existe, si il n'existe pas, il n'y a pas de purge
    xml_mblock=$(find /home/wpkg/packages  -maxdepth 1 -iregex ".*mblock.*")
    if [ -e "$xml_mblock" ]
    then
      #On extrait la version de mBlock depuis le package
      version_mblock=$(grep \"version\" $xml_mblock | awk -F"value=\"" '{ print $2 }' | awk -F\" '{print $1}')
      #On indique la version actuelle de mBlock
      echo "Version actuelle de mBlock : $version_mblock"
      #On stocke dans un fichier temporaire l'emplacement des dossiers à supprimer
      find /home -maxdepth 6 -type d -iregex "/home/.?/[^/]*/perso/\(.Config\|config_eole\)/Application\ Data/\(com.makeblock\|cc.mblock\).*" | grep -v "$version_mblock" > /tmp/dossiers_mblock.tmp

      #On lit le fichier contenant les dossiers à supprimer ligne par ligne
      while read ligne
      do
      	#On supprime le dossier indiqué par la ligne actuelle
      	rm -rf "$ligne"
      	#On affiche dans le log le dossier supprimé
      	echo "$ligne"
      done < /tmp/dossiers_mblock.tmp

      #On supprime le fichier temporaire
      rm -f /tmp/dossiers_mblock.tmp
    fi
    ####################

    ####################
    ## Purge de Sketchup
      echo + Nettoyage Sketchup

    xml_sketchup=$(find /home/wpkg/packages  -maxdepth 1 -iregex ".*sketchup.*")
    #Nettoyage des dossiers Sketchup 8
    find /home -maxdepth 10 -type d -iregex '/home/.?/[^/]*/perso/\(.Config\|config_eole\)/Application\ Data/Google/Google\ SketchUp\ 8' -exec rm -rf {} \; -print

    #On vérifie si le package Sketchup existe, s'il n'existe pas, il n'y a pas de purge
    if [ -e "$xml_sketchup" ]
    then
      #On extrait la version de SketchUp depuis le package
      version_sketchup=$(grep name=\"W7\" $xml_sketchup | awk -F"value=\"" '{ print $2 }' | awk -F\" '{print $1}')
      echo version_sketchup
      #On regarde si la variable version_sketchup n'est pas vide (Elle peut être vide si toujours sur SketchUp 8)
      if [ "$version_sketchup" != "" ]
      then

        #On indique la version actuelle de Sketchup
        echo -e "Version actuelle de Sketchup : $version_sketchup\n"


        #On purge le Webcache de la version actuelle
        echo "--- Début purge du Webcache ---"
        find /home -maxdepth 8 -type d -iregex "/home/.?/[^/]*/perso/\(.Config\|config_eole\)/Application\ Data/SketchUp/SketchUp\ $version_sketchup/WebCache" -exec rm -rf {} \; -print
        echo -e "--- Fin purge du Webcache ---\n"

        #On stocke dans un fichier temporaire l'emplacement des dossiers à supprimer
        echo "--- Début purge version anterieure a Sketchup $version_sketchup ---"
        find /home -maxdepth 7 -type d -iregex "/home/.?/[^/]*/perso/\(.Config\|config_eole\)/Application\ Data/SketchUp/SketchUp.*" | grep -v "$version_sketchup" > /tmp/dossiers_sketchup.tmp

        #On lit le fichier contenant les dossiers à supprimer ligne par ligne
        while read ligne
        do
    	  #On supprime le dossier indiqué par la ligne actuelle
        rm -rf "$ligne"
    	  #On affiche dans le log le dossier supprimé
    	  echo "$ligne"
        done < /tmp/dossiers_sketchup.tmp
        echo -e "--- Fin purge version anterieure a Sketchup $version_sketchup ---\n"

        #On supprime le fichier temporaire
        rm -f /tmp/dossiers_sketchup.tmp
      fi
    fi

    ####################
    ## Suppression du dossier Scratch
    echo + Nettoyage Scratch
    find /home -maxdepth 10 -type d -iregex '/home/.?/[^/]*/perso/\(.Config\|config_eole\)/Application\ Data/edu\.media\.mit\.Scratch2Editor' -exec rm -rf {} \; -print
    ####################


}


if [ $(date +%d) -le 7 ]
  then
	echo "">>  $log
	echo "******************************************************************">>  $log
	echo "Purge mensuelle des /home/<user>/config_eole/Application Data du $(date)">>  $log
	purge_mensuelle 1>>  $log 2>&1
	echo "Purge mensuelle terminee a $(date)">>  $log

	#copie du log dans le répertoire de l'admin
	echo "+ Copie du log dans le répertoire de l'admin"
	mkdir /home/a/admin/perso/purge_mensuelle-log &>/dev/null
	cp $log /home/a/admin/perso/purge_mensuelle-log &>/dev/null
fi
