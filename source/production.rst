******************
Mise en production
******************

Le serveur que django met à notre disposition est prévu uniquement pour le développement: inutile de passer par du code Python pour charger des fichiers statiques (feuilles de style, fichiers JavaScript, images, ...). De même, la base de donnée doit supporter plus qu'un seul utilisateur: SQLite fonctionne très bien dès lors qu'on se limite à un seul utilisateur... Sur une application Web, il est plus que probable que vous rencontriez rapidement des erreurs de base de données verrouillée pour écriture par un autre processus. Il est donc plus que bénéfique de passer sur quelque chose de plus solide. 

Pour une mise ne production, le standard *de facto* est le suivant:

 * Nginx comme serveur principal
 * Gunicorn comme serveur d'application
 * Supervisorctl pour le monitoring
 * PostgreSQL comme base de données.
 
C'est celle-ci que nous allons décrire ci-dessous.
 
Il est évidemment possible de configurer des connecteurs vers d'autres bases de données (Oracle, MSSQL ou MySQL), mais il ne nous est pas possible de décrire tous les cas d'utilisation. Nous allons nous limiter au    
 
Les points suivants décrivent les étapes nécessaires à la mise en place de ces outils.

***Remarque***: dans ce qui suit, les commandes exécutées en root seront précédées de $$$.

Voir http://michal.karzynski.pl/blog/2013/06/09/django-nginx-gunicorn-virtualenv-supervisor/
Et http://tutos.readthedocs.org/en/latest/source/ndg.html

Ne pas oublier la génération des fichiers statiques !

.. include:: production/postgresql.rst
.. include:: production/environment.rst
.. include:: production/gunicorn.rst
.. include:: production/monitoring.rst
.. include:: production/nginx.rst
.. include:: production/fabric.rst
