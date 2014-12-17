#! /bin/bash  

# Ajout d'un cron pour redémarrer chaque jour les services pour OpenERP 
echo 30 23 * * * root $(dpkg -s openerp &>/dev/null) ; [[ $(echo $?) -eq 0 ]] && /etc/init.d/postgresql restart > /etc/cron.d/openerp_restart
echo 35 23 * * * root $(dpkg -s openerp &>/dev/null) ; [[ $(echo $?) -eq 0 ]] && /etc/init.d/openerp restart >> /etc/cron.d/openerp_restart

# Déporte les bases d'OpenERP dans le home
mkdir /home/openerp_bdd
mv /var/lib/postgresql/8.4/main/base /home/openerp_bdd
ln -s /home/openerp_bdd/base /var/lib/postgresql/8.4/main/base
chown -R postgres:postgres /home/openerp_bdd/base
chmod -R u=rwx /home/openerp_bdd/base
exit 0
fi
