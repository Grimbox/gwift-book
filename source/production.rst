==================
Mise en production
==================

Le serveur que django met à notre disposition est prévu uniquement pour le développement: inutile de passer par du code Python pour charger des fichiers statiques (feuilles de style, fichiers JavaScript, images, ...). De même, la base de donnée doit supporter plus qu'un seul utilisateur: SQLite fonctionne très bien dès lors qu'on se limite à un seul utilisateur... Sur une application Web, il est plus que probable que vous rencontriez rapidement des erreurs de base de données verrouillée pour écriture par un autre processus. Il est donc plus que bénéfique de passer sur quelque chose de plus solide. 

Pour une mise ne production, la proposition *de facto* est la suivante:

 * Nginx comme serveur principal
 * Gunicorn comme serveur d'application
 * Supervisorctl pour le monitoring
 * PostgreSQL comme base de données.
 
C'est celle-ci que nous allons décrire ci-dessous.
 
Il est évidemment possible de configurer des connecteurs vers d'autres bases de données (Oracle, MSSQL ou MySQL), mais il ne nous est pas possible de décrire tous les cas d'utilisation.  

Voir http://michal.karzynski.pl/blog/2013/06/09/django-nginx-gunicorn-virtualenv-supervisor/
Et http://tutos.readthedocs.org/en/latest/source/ndg.html

.. include:: production/environment.rst
.. include:: production/postgresql.rst
.. include:: production/gunicorn.rst
.. include:: production/nginx.rst
.. include:: production/fabric.rst
