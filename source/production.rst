==================
Mise en production
==================

Le serveur que django met à notre disposition est prévu uniquement pour le développement.

Pour une mise ne production, il nous faut donc quelque chose de plus solide:

 * Nginx comme serveur principal
 * Gunicorn comme serveur d'application
 * PostgreSQL comme base de données

Voir http://michal.karzynski.pl/blog/2013/06/09/django-nginx-gunicorn-virtualenv-supervisor/
Et http://tutos.readthedocs.org/en/latest/source/ndg.html

.. include:: production/environment.rst
.. include:: production/postgresql.rst
.. include:: production/gunicorn.rst
.. include:: production/nginx.rst

