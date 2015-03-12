#!/bin/bash

#V2 beta
# Ce script est a placé dans le dossier /root/drt, ne pas oublier les droits d'execution (+x) !
# exemple de cron pour lancer tous les jours a 6H du matin (/etc/cron.d/backup_opener) : 
# 0 6 * * * root /root/drt/backup_openerp.sh

cd /home/openerp_bdd/base

# Lancement avec le compte postgres
if su postgres -c "pg_dumpall > backup_openerp.out 2>backup.erreur" ; then

# Compression du fichier de sauvegarde avec la date du jour
tar czvf backup_openerp-`date +%Y-%m-%d`.tar.gz backup_openerp.out
rm -f backup_openerp.out

# Placement du backup au bon endroit
mv -f *.tar.gz /home/openerp_bdd

# Purge des anciens backups OpenERP qui ont plus de 20 jours
find /home/openerp_bdd/backup_openerp-* -type f -mtime +20 -exec rm -rf {} \;

else

echo "Il y a eu une erreur lors du backup postgresql d'OpenERP pour l'établissement 'machin truc (a remplacer)', vous pouvez consulter le fichier backup.erreur dans /home/openerp_base/base pour plus de précision" | mutt -s "MAIL" simon.bernard@ac-lyon.fr

fi

exit
