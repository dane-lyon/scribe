# Scripts à utiliser sur le serveur de fichiers Eole-Scribe


## Préambule

Si vous avez des difficultés pour télécharger les scripts depuis le serveur scribe, il faut rajouter le proxy en faisant :
```Shell
export https_proxy="ip_proxy:port_proxy"
```
puis si vous avez le message suivant "Incapable d'établir une connexion SSL", il faut rajouter l'argument suivant :
    --no-check-certificate

Ce qui donne par exemple :
```Shell
wget https://raw.githubusercontent.com/dane-lyon/scribe/master/purgesimple.sh --no-check-certificate
```


## InstallOpenERP.sh

Ce script permet d'installer OpenERP 6.1 sur un Scribe 2.3, utilisé notamment par les classes de BacPro G-A.

Pour l'utiliser :
```Shell
wget https://raw.githubusercontent.com/dane-lyon/scribe/master/InstallOpenERP.sh
chmod +x InstallOpenERP.sh
./InstallOpenERP.sh
```

## wpkg_ln.sh

Il s'agit d'un script qui automatise le téléchargement de wpkg-manage et les clients WPKG (clients Xp 32 bits, et WPKG-GP 32 et 64 bits).

wpkg_ln est un petit script à télécharger depuis un serveur Scribe qui permet, en complément de l'installation du paquet eole-wpkg, de télécharger les clients XP et 7 (Xp 32 bits et WPKG-GP 32 et 64 bits), ainsi que wpkg-manage.

Pour l'utiliser :
```Shell
wget https://raw.githubusercontent.com/dane-lyon/scribe/master/wpkg_ln.sh
chmod +x wpkg_ln.sh
./wpkg_ln.sh
```

## purge.sh

Scripts de purge des répertoires personnels sur un serveur Eole-Scribe

L'idée de purge.sh est de supprimer le cache et les fichiers superflus afin qu'ils ne soient pas inclus dans la sauvegarde.

### Installation de purge.sh

Créez un fichier /root/drt/purge.sh :
```Shell
mkdir /root/drt
cd /root/drt
nano purge.sh
```    
et y copier le script qui est à présent sur le Github.
Il ne faut pas oublier de rendre le fichier exécutable :
```Shell
chmod +x purge.sh
```    
Tester que le script fonctionne correctement :
```Shell
./purge.sh
```
    
### Exécution périodique

**Ce script sera exécuté automatiquement tous les jours à 5h00.**
    
Créer dans le répertoire **/etc/cron.d/** un fichier avec un nom parlant, par exemple **“purgeHOME”** Et y ajouter les lignes suivantes:

```Shell
# purge des /home/<user>/.Config/Application Data tous les jours à 5h00
0 5 * * * root [ -x /root/drt/purge.sh ] && sh /root/drt/purge.sh
```
Il n'y aura pas besoin de créer de patch pour que le fichier soit définitif.

### Rotation du log

Etant donné que le purge.log va se remplir avec la liste des fichiers supprimés, il serait intéressant de mettre en place sa rotation. Pour cela, créer un fichier **“purgelog”** dans le répertoire **/etc/logrotate.d**

```Shell
cd /etc/logrotate.d
nano purgelog
```
Et y copier le contenu suivant:
```Shell
/var/log/purge/purge.log {
      monthly
      rotate 4
      missingok
      compress
      dateext
}
```
Grace à ce fichier il y aura une **rotation mensuelle, 4 rotations dans la période** : donc ici 4 par mois = 1 log par semaine et **compressera les log au format “nom+date.gz”**

## purgesimple.sh

Nous avons mis en place également un script plus simple qui permet de purger les profils avant une migration vers Scribe 2.3. Cela permet de gagner du temps pour le transfert des données en supprimant plein de petits fichiers.

Ce script purge le dossier .Config/Application Data des dossiers les plus encombrants :

- OpenOffice.org
- LibreOffice
- Sun
- Microsoft

Pas de panique, ces dossiers sont reconstruits au premier lancement de l'application (le 1er lancement sera du coup, un poil plus long).

### Utilisation

On peut le mettre en place sur Scribe avec ces commandes :
```Shell
wget https://raw.githubusercontent.com/dane-lyon/scribe/master/purgesimple.sh
chmod +x purgesimple.sh
./purgesimple.sh
```
## modifproxyesu.sh


Petit script pour modifier la config du proxy dans tous les groupes de machines ESU.
Auparavant, le script fait une sauvegarde de tous les groupes dans /home/esu.sav.

Attention, il faut bien respecter le format ip (exemple 172.16.0.252).
