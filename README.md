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
et y copier le script [purge.sh](https://github.com/dane-lyon/scribe/blob/master/purge.sh).
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

## purge_mensuelle.sh

Scripts de purge des répertoires personnels sur un serveur Eole-Scribe à exécuter mensuellement.

Ce script supprime des dossiers laissés par une ancienne version d´un logiciel, il n´est pas utile de le lancer tous les jours.

### Installation

Pour commencer, nous allons créer un fichier nommé purge_mensuelle.sh
```Shell
mkdir /root/drt
cd /root/drt
nano purge_mensuelle.sh
```
Puis nous insérons le script [purge_mensuelle.sh](https://github.com/dane-lyon/scribe/blob/master/purge_mensuelle.sh), et nous le rendons exécutable
```Shell
cd /root/drt
chmod +x purge_mensuelle.sh
```
On teste que le script fonctionne correctement.

Si la date du jour est supérieure au 7, modifier le temps du temps la ligne 108 en mettant une valeur supérieure à la date du jour (ne pas oublier de remettre la valeur 7 à la fin du test).
```Shell
cd /root/drt
./purge_mensuelle.sh
```
Le script va créer un fichier purge_mensuelle.log dans /var/log/purge/ dans lequel on pourra retrouver la liste des fichiers supprimés ainsi que les éventuels messages d'erreur liés à la purge. Ce fichier log sera automatiquement copié dans un dossier purge_mensuelle-log contenu dans U:\ de l'admin.

### Exécution périodique

Il nous faut maintenant créer dans le répertoire /etc/cron.d/ un fichier avec un nom parlant, par exemple “purge_mensuelle”
```Shell
nano /etc/cron.d/purge_mensuelle
```
 Et y ajouter les lignes suivantes:
```Shell
# purge des /home/<user>/.Config/Application Data le 1er mercredi du mois à 6h00
0 6 * * 3 root [ -x /root/drt/purge_mensuelle.sh ] && sh /root/drt/purge_mensuelle.sh
```
Une condition dans le script fera en sorte que le script ne se lance que le premier mercredi du mois.

### Rotation du log

Etant donné que le purge_mensuelle.log va se remplir avec la liste des fichiers supprimés, il serait intéressant de mettre en place sa rotation. Pour cela, créer un fichier “purgemensuellelog” dans le répertoire /etc/logrotate.d
```Shell
cd /etc/logrotate.d
nano purgemensuellelog
```
Et y copier le contenu suivant :
```Shell
/var/log/purge/purge_mensuelle.log {
  monthly
  rotate 1
  missingok
  compress
  dateext
}
```
Grace à ce fichier il y aura une rotation mensuelle, une rotation dans la période : donc ici 1 par mois = 1 log par mois et compressera les log au format “nom+date.gz”.

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
