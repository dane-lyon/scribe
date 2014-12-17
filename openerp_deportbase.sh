#! /bin/bash  

if [ -f /etc/init.d/openerp ]; then

# Ajout d'un cron pour redémarrer chaque jour les services pour OpenERP 
echo "30 23 * * * /etc/init.d/postgresql-8.4 restart" > /etc/cron.d/openerp_restart
echo "35 23 * * * /etc/init.d/openerp restart" >> /etc/cron.d/openerp_restart

# Déporte les bases d'OpenERP dans le home

/etc/init.d/postgresql-8.4 stop
/etc/init.d/openerp stop

#mkdir /home/openerp_bdd
#mv /var/lib/postgresql/8.4/main/base /home/openerp_bdd
#ln -s /home/openerp_bdd/base /var/lib/postgresql/8.4/main/base
#chown -R postgres:postgres /home/openerp_bdd/base
#chmod -R u=rwx /home/openerp_bdd/base

/etc/init.d/postgresql-8.4 start
/etc/init.d/openerp start

else
  exit
fi
