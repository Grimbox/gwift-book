Une application Django
======================

Comme on l'a vu ci-dessus, `django-admin` permet de créer un nouveau projet. Django fait une distinction entre un **projet** et une **application**:

 * Projet: ensemble des applications, paramètres, pages HTML, middlwares, dépendances, ... qui font que votre code fait ce qu'il est sensé faire.
 * Application: *contexte* éventuellement indépendant, permettant d'effectuer une partie isolée de ce que l'on veut faire.

Pour `gwift`, on va notamment avoir une application pour la gestion des listes de souhaits et des éléments, une deuxième application pour la gestion des utilisateurs, voire une troisième application qui gérera les partages entre utilisateurs et listes. On voit bien ici le principe de **contexte**: l'application viendra avec son modèle, ses tests, ses vues, son paramétrage, ... Et pourra éventuellement être réutilisée dans un autre projet. C'est en ça que consistent les [paquets Django](https://www.djangopackages.com/) déjà disponibles: ce sont simplement de petites applications empaquetées pour être réutilisables (eg. [Django-Rest-Framework](https://github.com/tomchristie/django-rest-framework), [Django-Debug-Toolbar](https://github.com/django-debug-toolbar/django-debug-toolbar), ...).
