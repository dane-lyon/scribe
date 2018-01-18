#!/bin/bash

objectif :
- Dans le fichier "/home/esu/Console/ListeRegles.xml", insérer les lignes suivantes :

						<Regle type="BOOLEEN">
							<OS>254</OS>
							<Intitule>Autoriser la lecture des animations flash (swf) sur un partage réseau</Intitule>
							<Chemin>JS://%AppData%\Mozilla\Firefox\Profiles\Defaut\user.js</Chemin>
							<Variable nom="plugins.flashBlock.enabled" type="BOOLEAN">
								<ValueOn>false</ValueOn>
								<ValueOff>true</ValueOff>
							</Variable>
							<Commentaire>Mettre sur false pour autoriser la lecture flash depuis partage réseau</Commentaire>
						</Regle>

- Juste après les lignes :

						<Regle type="BOOLEEN">
							<OS>254</OS>
							<Intitule>Vérifier que Firefox est le navigateur par défaut</Intitule>
							<Chemin>JS://%AppData%\Mozilla\Firefox\Profiles\Defaut\user.js</Chemin>
							<Variable nom="browser.shell.checkDefaultBrowser" type="BOOLEAN">
								<ValueOn>true</ValueOn>
								<ValueOff>false</ValueOff>
							</Variable>
							<Commentaire>Pas de commentaires pour cette règle !</Commentaire>
						</Regle>
            

================================


sed -n '/<Variable nom="browser.shell.checkDefaultBrowser" type="BOOLEAN">
								<ValueOn>true</ValueOn>
								<ValueOff>false</ValueOff>
							</Variable>
							<Commentaire>Pas de commentaires pour cette règle !</Commentaire>/ 
<Variable nom="browser.shell.checkDefaultBrowser" type="BOOLEAN">
								<ValueOn>true</ValueOn>
								<ValueOff>false</ValueOff>
							</Variable>
							<Commentaire>Pas de commentaires pour cette règle !</Commentaire>
						<Regle type="BOOLEEN">
							<OS>254</OS>
							<Intitule>Autoriser la lecture des animations flash (swf) sur un partage réseau</Intitule>
							<Chemin>JS://%AppData%\Mozilla\Firefox\Profiles\Defaut\user.js</Chemin>
							<Variable nom="plugins.flashBlock.enabled" type="BOOLEAN">
								<ValueOn>false</ValueOn>
								<ValueOff>true</ValueOff>
							</Variable>
							<Commentaire>Mettre sur false pour autoriser la lecture flash depuis partage réseau</Commentaire>
						</Regle>'

/home/esu/Console/ListeRegles.xml
