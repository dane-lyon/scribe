#!/bin/bash

#création du lien symbolique pour wpkg
#et téléchargement de wpkg-manage + clients 32 et 7 - 64 bits
#si eole-wpkg installé
# pour serveurs Scribe 2.4

. /usr/lib/eole/ihm.sh

/usr/bin/dpkg -s eole-wpkg &> /dev/null

if [ $? -eq 0 ] ; then
    [ ! -h /home/a/admin/perso/wpkg ] && ln -s /home/wpkg /home/a/admin/perso/wpkg
        EchoGras "Wpkg est installé"
        #telechargement des clients wpkg et wpkg-manage

        cd /tmp
        EchoGras "+++ téléchargement de wpkg-manage..."
            if [ ! -f /home/wpkg/wpkg-manage-setup.exe ] ; then
                wget www.ac-nantes.fr/html/ctre/wpkg-manage/wpkg-manage-setup.exe
                mv /tmp/wpkg-manage-setup.exe /home/wpkg/
            else echo "wpkg-manage est déjà présent"
            fi
        EchoGras "+++ téléchargement des clients..."
            if [ ! -f /home/wpkg/WPKG_Client32.msi  ] ; then
                wget http://wpkg.org/files/client/stable/WPKG%20Client%201.3.14-x32.msi
                mv /tmp/WPKG\ Client\ 1.3.14-x32.msi /home/wpkg/WPKG_Client32.msi
            else echo "le client wpkg 32bits est déjà présent"
            fi

            if [ ! -f /home/wpkg/Wpkg-GP_x86.exe  ] ; then
                wget http://wpkg-gp.googlecode.com/files/Wpkg-GP-0.15_x86.exe
                mv /tmp/Wpkg-GP-0.15_x86.exe /home/wpkg/Wpkg-GP_x86.exe
            else echo "le client wpkg 7 32bits est déjà présent"
            fi

            if [ ! -f /home/wpkg/Wpkg-GP_x64.exe  ] ; then
                wget http://wpkg-gp.googlecode.com/files/Wpkg-GP-0.15_x64.exe
                mv /tmp/Wpkg-GP-0.15_x64.exe /home/wpkg/Wpkg-GP_x64.exe
            else echo "le client wpkg 7 64bits est déjà présent"
            fi

        exit 0

else
    EchoGras "Wpkg n'est pas installé."
    exit 1
fi
