Scripts à utiliser sur le serveur de fichiers Eole-Scribe
====

InstallOpenERP.sh
===

Ce script permet d'installer OpenERP 6.1 sur un Scribe 2.3, utilisé notamment par les classes de BacPro G-A.

Pour l'utiliser :

    wget https://raw.githubusercontent.com/dane-lyon/scribe/master/InstallOpenERP.sh
    chmod +x InstallOpenERP.sh
    ./InstallOpenERP.sh


wpkg_ln.sh
===

Il s'agit d'un script qui automatise le téléchargement de wpkg-manage et les clients WPKG (clients Xp 32 bits, et WPKG-GP 32 et 64 bits).

wpkg_ln est un petit script à télécharger depuis un serveur Scribe qui permet, en complément de l'installation du paquet eole-wpkg, de télécharger les clients XP et 7 (Xp 32 bits et WPKG-GP 32 et 64 bits), ainsi que wpkg-manage.

Pour l'utiliser :

    wget https://raw.githubusercontent.com/dane-lyon/scribe/master/wpkg_ln.sh
    chmod +x wpkg_ln.sh
    ./wpkg_ln.sh


purge.sh et purgesimple.sh
===

Scripts de purge des répertoires personnels sur un serveur Eole-Scribe

L'idée de purge.sh est de supprimer le cache et les fichiers superflus afin qu'ils ne soient pas inclus dans la sauvegarde.

Le script purge est à exécuter de manière régulière, tous les jours, sur le serveur, via un cron. Plus de détails sur cette page : http://nefertiti.crdp.ac-lyon.fr/wk/cdch/purge_des_repertoires_perso

purgesimple.sh est un petit script qui permet de gagner du temps dans une optique de migration de serveur 2.2 en 2.3, il supprime les nombreux fichiers des profils utilisateurs (libreoffice, openoffice.org, SunJava et Microsoft), fichiers se trouvant dans le dossier .Config.
