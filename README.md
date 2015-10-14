# Installation

## Prérequis

`sudo aptitude install nodejs`.
Après cela, lance `npm install` qui ira récupérer le contenu du fichier `package.json`.

## Editeur

Il existe un éditeur pour Gitbook, qui offre pas mal de fonctionnalités sans avoir à tripatouiller la documentation; il est disponible à [l'adresse suivante](https://www.gitbook.com/editor/linux).

Pour l'installation, un petit `dpkg -i gitbook-editor.x.y.z.deb`.
Seul soucis: un compte Gitbook est requis.

# Initialisation

L'initiation du contenu peut se faire une fois que le module `gitbook-cli`aura été installé, grâce à la commande `nodejs node_modules/gitbook-cli/bin/gitbook.js init <folder>`.
Cette commande se base sur le fichier `SUMMARY.md` pour générer l'arborescence correcte des fichiers (vides, dans un premier temps).

# Compilation

 * `nodejs node_modules/gitbook-cli/bin/gitbook.js build`
 * `nodejs node_modules/gitbook-cli/bin/gitbook.js serve`

## Formats supportés

Pour les formats autres que HTML (PDF, Mobi & ePub), il faut installer `Calibre` grâce à un `aptitude install Calibre`. Attention qu'il y a un bon petit 300MB de dépendances...
