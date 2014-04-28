#! /bin/bash

#### script pour installer Open Erp sur scribe 2.3 #######
#### DANE rectorat de lyon ######
#### Fait par Dominique Jassin #####
#### Version 2 ######

#### on teste si le paquet est présent inutile d'aller plus loin si c'est la cas
dpkg -s openerp &>/dev/null
if [ $? -eq 0 ] ; then
	echo "openerp est déjà présent"
	exit 0
else
#### on rajoute les outils eole pour lancer postgresql et openerp
. /usr/share/eole/FonctionsEoleNg

#### on rajoute le dépôt open erp dans la source.list

touch /etc/apt/sources.list.d/openerp-6.1-nightly.list
echo deb http://nightly.openerp.com/6.1/nightly/deb ./ > /etc/apt/sources.list.d/openerp-6.1-nightly.list

##### on installe openerp et on met à jour les paquets
apt-get update
apt-get install openerp

#### ouverture des ports sur le scribe , en fait ce fichier devrRA REDESCENDRE VIA LA VARIANTE ET C'EST INUTILE DE LE CREER SI TU NE RECONFIGURE PAS, LE FICHIER NE SERA PAS TRAITE DONC PAS DE REGLES.
echo " allow_src(interface='eth0', ip='0/0', port='8069')
     allow_src(interface='eth0', ip='0/0', port='5432')" > /usr/share/eole/firewall/00_root_openerp.fw
#donc on ajoute les autorisations à la volée
	/sbin/iptables -I wide-root -p tcp -m state --state NEW -m tcp --dport 8069 --tcp-flags FIN,SYN,RST,ACK SYN -j ACCEPT
	/sbin/iptables -I wide-root -p tcp -m state --state NEW -m tcp --dport 5432 --tcp-flags FIN,SYN,RST,ACK SYN -j ACCEPT


#### paramétrage de postgres pour le rendre accessible depuis le réseau
### on remplace #listen_addresses = 'localhost' par listen_addresses = '*' dans ####le fichier de conf pour que le serveur écoute

sed -i.BAK  "s/^\#listen_addresses =.*/listen_addresses = '*'/g" /etc/postgresql/8.4/main/postgresql.conf
### modification du fichier pg_hba.conf
#### attention je passe par un numéro de ligne donc cette opération peut échouer
sed -i.BAK "85i\host    all        all    0.0.0.0/0    trust" /etc/postgresql/8.4/main/pg_hba.conf
#### on redémarre postgresql et openerp pour que la config remonte

service postgresql-8.4 restart
service openerp restart

###### on rajoute la base postgresql dans la sauvegarde bacula
###### on crée le fichier avec touch et on écrit dedans

echo "Include {
File = /var/lib/postgresql
}" /etc/bacula/baculafichiers.d/openerp.conf

#### on rajoute les tests dans le diagnose
echo "#! /bin/bash
. /usr/share/eole/FonctionsEoleNg
. /etc/eole/containers.conf
. ParseDico
if [ \$activer_mysql == 'oui' ]; then
EchoGras \"*** OpenERP\"
TestPid PostgreSql postgres
fi

if [ \"\$activer_apache\" != \"non\" ];then
	. /usr/share/eole/FonctionsEoleNg
	if [ \$adresse_ip_web = '127.0.0.1' ];then
	TestHTTPPage OpenERP http://\$adresse_ip_eth0:8069
	else
	TestService Web \$container_ip_web:80
	fi
	echo
fi
exit 0 " > /usr/share/eole/diagnose/module/151-openerp
chmod +x /usr/share/eole/diagnose/module/151-openerp
####sed -i.BAK "/TestService/a \TestPid PostgreSql postgres" /usr/share/eole/diagnose/module/151-mysql
#####sed -i.BAK "/ TestService Web \$adresse/a \TestHTTPPage OpenERP http://\$adresse_ip_eth0:8069" /usr/share/eole/diagnose/module/151-web

#### le dépot openerp-6.1-nightly.list n'a pas de signature et fait échouer la maj des scribes
#### on supprime donc le fichier et on relance un apt-get update

rm /etc/apt/sources.list.d/openerp-6.1-nightly.list
apt-get update

#### message de fin d'installation

echo "L'installation est terminée. Il faut faire un reconfigure et un diagnose pour vérifier que tout est ok. Attention le reconfigure coupera l'accès au réseau temporairement !!!"
echo "un log contenant les dossiers modifiés est disponible sur le perso de l'admin. Ce log s'appelle InstallationOpenERP.log"

echo "les fichiers modifiés par cette installation sont:
/etc/apt/sources.list.d/openerp-6.1-nightly.list
/usr/share/eole/firewall/00_root_openerp.fw
/etc/postgresql/8.4/main/postgresql.conf
/etc/postgresql/8.4/main/pg_hba.conf
/etc/bacula/baculafichiers.d/openerp.conf
/usr/share/eole/diagnose/module/151-openerp

Les anciens fichiers de configuration ont une extension en .BAK. Vous pouvez toujours utiliser cp pour les remettre en place en cas de problème " > /home/a/admin/perso/InstallationOpenERP.log


exit 0
fi
