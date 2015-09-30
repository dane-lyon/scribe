#!/bin/bash
# Script de Simon.B

# Ce script va effectuer les tâches suivantes :
# - Installation d'OpenERP version 7 pour un Scribe 2.4
# - Ouverture du port OpenERP pour qu'il fonctionne avec un Scribe 2.4
# - Dépot du dossier contenant les futurs bases dans un dossier du home (pour ne pas saturer plus tard le /var)
# - Mise en place d'un système de sauvegarde
# - Redémarrage chaque nuit des services bacula & postgresql (pas sûr que ça soit utile)

# A la fin du script ça ne sera pas encore terminé, il faudra :

# - Lancer un reconfigure (pour programmer a 20H par exemple : echo "reconfigure" | at 20:00)
# - si vous voulez récupérer les bases d'OpenERP 6 de la 2.3, restaurer votre fichier .out (cf doc)

# Installation de Postgressql
apt-get -y install postgresql

# Telechargement & Installation du paquet OpenERP 7
wget http://nightly.odoo.com/7.0/nightly/deb/openerp_7.0.20150924_all.deb
dpkg -i openerp_7.0.20150924_all.deb 
apt-get -fy install

# Autorisation du port OpenERP pour Scribe 2.4 ("reconfigure" pour que le changement soit pris en compte !!)
wget --no-check-certificate https://raw.githubusercontent.com/dane-lyon/experimentation/master/dico_dane.xml
mv dico_dane.xml /usr/share/eole/creole/dicos/local/

# Déport des bases dans le home
/etc/init.d/postgresql stop && /etc/init.d/openerp stop
mkdir /home/openerp_bdd
mv /var/lib/postgresql/9.1/main/base /home/openerp_bdd
ln -s /home/openerp_bdd/base /var/lib/postgresql/9.1/main/base
chown -R postgres:postgres /home/openerp_bdd/base
chmod -R u=rwx /home/openerp_bdd/base
/etc/init.d/postgresql start && /etc/init.d/openerp start

# Ajout d'un cron qui redémarre service OpenERP et Postgresql chaque nuit a 20H30
echo "30 20 * * * root /etc/init.d/postgresql restart" > /etc/cron.d/openerp_restart
echo "30 20 * * * root /etc/init.d/openerp restart" >> /etc/cron.d/openerp_restart

# Mise en place d'un système de sauvegarde pour OpenERP
wget --no-check-certificate https://raw.githubusercontent.com/dane-lyon/scribe/scribe2223/backup_openerp.sh
mv backup_openerp.sh /root/drt/ 
chmod +x /root/drt/backup_openerp.sh

# Programmation du backup toutes les nuits a 05H du matin
echo "0 5 * * * root /root/drt/backup_openerp.sh" > /etc/cron.d/sauvegarde_openerp


exit



