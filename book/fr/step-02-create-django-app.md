Une application Django
======================

Comme on l'a vu ci-dessus, `django-admin` permet de créer un nouveau projet. Django fait une distinction entre un **projet** et une **application**:

 * Projet: ensemble des applications, paramètres, pages HTML, middlwares, dépendances, ... qui font que votre code fait ce qu'il est sensé faire.
 * Application: *contexte* éventuellement indépendant, permettant d'effectuer une partie isolée de ce que l'on veut faire.

Pour `gwift`, on va notamment avoir une application pour la gestion des listes de souhaits et des éléments, une deuxième application pour la gestion des utilisateurs, voire une troisième application qui gérera les partages entre utilisateurs et listes.

On voit bien ici le principe de **contexte**: l'application viendra avec son modèle, ses tests, ses vues, son paramétrage, ... Et pourra éventuellement être réutilisée dans un autre projet. C'est en ça que consistent les [paquets Django](https://www.djangopackages.com/) déjà disponibles: ce sont simplement de petites applications empaquetées pour être réutilisables (eg. [Django-Rest-Framework](https://github.com/tomchristie/django-rest-framework), [Django-Debug-Toolbar](https://github.com/django-debug-toolbar/django-debug-toolbar), ...).

manage.py
---------

Comme expliqué un peu plus haut, le fichier `manage.py` est un *wrapper* sur les commandes `django-admin`. A partir de maintenant, nous n'utiliserons plus que celui-là pour tout ce qui touchera à la gestion de notre projet:

 * `manage.py check` pour vérifier que votre projet ne rencontre aucune erreur
 * `manage.py runserver` pour lancer un serveur de développement
 * `manage.py test` pour découvrir les tests unitaires disponibles et les lancer.

La liste complète peut être affichée avec `manage.py help`. Vous remarquerez que ces commandes sont groupées:

 * **auth**: création d'un nouveau super-utilisateur, changer le mot de passe pour un utilisateur existant.
 * **django**: vérifier la *compliance* du projet, lancer un *shell*, *dumper* les données de la base, effectuer une migration du schéma, ...
 * **sessions**: suppressions des sessions en cours
 * **staticfiles**: gestion des fichiers statiques et lancement du serveur de développement.

Nous verrons plus tard comment ajouter de nouvelles commandes.

Structure d'une application
---------------------------

Maintenant que l'on a vu à quoi servait `manage.py`, on peut créer notre nouvelle application grâce à la commande `manage.py startapp <label>`.
Cette application servira à structurer les listes de souhaits, les éléments qui les composent et les parties que chaque utilisateur pour offrir. Essayez de trouver un nom éloquent, court et qui résume bien ce que fait l'application. Pour nous, ce sera donc `wish`. C'est parti pour `manage.py startapp wish`!

```shell
$ cd gwift
$ python manage.py startapp wish
```

Résultat? Django nous a créé un répertoire `wish`, dans lequel on trouve les fichiers suivants:

```shell
$ ls -l wish
admin.py  __init__.py  migrations  models.py  tests.py  views.py
```

En résumé, chaque fichier a la fonction suivante:

 * `admin.py` servira à structurer l'administration de notre application. Chaque information peut en effet être administrée facilement au travers d'une interface générée à la volée par le framework. On y reviendra par la suite.
 * `__init__.py` pour que notre répertoire `wish` soit converti en package Python.
 * `migrations/`, dossier dans lequel seront stockées toutes les différentes migrations de notre application.
 * `models.py` pour représenter et structurer nos données.
 * `tests.py` pour les tests unitaires.
 * `views.py` pour définir ce que nous pouvons faire avec nos données.
