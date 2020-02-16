*****
Nginx
*****

FrontEnd
========

Nginx est là pour agir en tant que front-end Web. A moins d'avoir configuré un mécanisme de cache type `Varnish <https://www.varnish-cache.org/>`_, c'est lui qui va recevoir la requête envoyée par l'utilisateur, gérer les fichiers et les informations statiques, et transmettre toute la partie dynamique vers Gunicorn. 

Pour l'installer, on effectue la commande suivante:

.. code-block:: shell

    $$$ aptitude install nginx

L'exemple ci-dessous se compose de plusieurs grandes parties: commune (par défaut), static, uploads, racine.

Partie commune
--------------
 
 * Sur quel port Nginx doit-il écouter ? [80]
 * client_max_body_size ?? [4G]
 * Quel est le nom du serveur ? [ domain_name ]
 * keepalive ?? 
 * La compression Gzip doit-elle être activée ?
 * Avec quels paramètres ? [gzip_comp_level 7, gzip_proxied any] 
 * Quels types de fichiers GZip doit-il prendre en compte ?
 * Où les fichiers de logs doivent-ils être stockés ? [/logs/access.log & /logs/error.log]

Fichiers statiques
------------------

Pour les fichiers statiques, on définit un chemin ``/static`` dans le fichier de configuration, dans lequel on augmente le taux de compression et où on définit une durée de vie d'une semaine. En cas de non-présence du fichier, une erreur 404 est levée. 

Uploads
-------

La partie ``uploads`` est très proche des autres fichiers statiques. Attention cependant que dans ce cas-ci, la configuration ne gérera pas l'authentification des utilisateurs pour l'accès à des ressources téléversées: si une personne possède le lien vers un fichier téléversé et qu'elle le transmet à quelqu'un d'autre, cette deuxième personne pourra y accéder sans aucun problème. 

Si vous souhaitez implémenter un mécanisme d'accès géré, supprimez cette partie et implémenter la vôtre, directement dans l'application. Vous perdrez en performances, mais gagnerez en sécurité et en fonctionnalités.

Racine
------

La partie racine de votre domaine ou sous-domaine fera simplement le *pass_through* vers l'instance Gunicorn via un socket unix. En gros, et comme déjà expliqué, Gunicorn tourne en local et écoute un socket; la requête qui arrive sur le port 80 ou 443 est prise en compte par NGinx, puis transmise à Gunicorn sur le socket. Ceci est complétement transparent pour l'utilisateur de notre application.

On délare un upstream pour préciser à nginx comment envoyer les requêtes à gunicorn:

.. code-block:: shell

    upstream gwift_server {                                                                                                                                                                                                                      
        # fail_timeout=0 means we always retry an upstream even if it failed                                                                                                                                                                       
        # to return a good HTTP response (in case the Unicorn master nukes a                                                                                                                                                                       
        # single worker for timing out).                                                                                                                                                                                                           
                                                                                                                                                                                                                                                    
        server unix:/directory/to/gunicorn.sock fail_timeout=0;                                                                                                                                                                         
    }

Au final
--------

.. code-block:: shell

    upstream gwift_server {                                                                                                                                                                                                                      
        # fail_timeout=0 means we always retry an upstream even if it failed                                                                                                                                                                       
        # to return a good HTTP response (in case the Unicorn master nukes a                                                                                                                                                                       
        # single worker for timing out).                                                                                                                                                                                                           
                                                                                                                                                                                                                                                    
        server unix:/directory/to/gunicorn.sock fail_timeout=0;                                                                                                                                                                         
    }
    
    server {
        listen 80;
        client_max_body_size 4G;
        server_name sever_name.com www.sever_name.com;
        keepalive_timeout 5;

        gzip on;
        gzip_comp_level 7;
        gzip_proxied any;
        gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript application/javascript text/x-js;

        access_log {{ cwd }}/logs/access.log timed_combined;
        error_log {{ cwd }}/logs/error.log;

        location /static/ {
                alias /webapps/gwift/gwift/static;
                gzip on;
                gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript application/javascript text/x-js;
                gzip_comp_level 9;
                expires 1w;
                try_files $uri $uri/ =404;
        }

        location /uploads/ {
                alias {{ uploads_folder }}/;
                gzip on;
                gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript application/javascript text/x-js;
                gzip_comp_level 9;
                expires 1w;
                try_files $uri $uri/ =404;
        }

        location / {
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header Host $http_host;
                proxy_redirect off;

                proxy_pass http://gwift_server;
        }   
    }

Dans notre cas, et à adapter suivant les besoins, nous avons créé le fichier ``/etc/nginx/sites-available/gwift``, ainsi qu'un lien symbolique dans ``/etc/nginx/sites-enabled/gwift`` pour l'activer. Ensuite, nous pouvons redémarer nginx:

.. code-block:: shell

    $$$ service nginx restart

Si on se connecte à notre server sur www.sever_name.com/admin, nous obtenons le site suivant:

.. image:: production/admin_with_static.png
    :align: center

Où l'on peut voir que la mise en forme est correcte, ce qui signifie que les fichiers statics sont bien servis par nginx.

Modules complémentaires
=======================

PageSpeed
---------

Si le module `PageSpeed <https://github.com/pagespeed/ngx_pagespeed>`_ est installé, profitez-en pour ajouter la configuration suivante, à la fin de votre fichier de configuration:

.. code-block:: shell

    pagespeed on;
    pagespeed EnableFilters collapse_whitespace,insert_dns_prefetch,rewrite_images,combine_css,combine_javascript,flatten_css_imports,inline_css,rewrite_css,;
    # Needs to exist and be writable by nginx.
    pagespeed FileCachePath /var/nginx_pagespeed_cache;

    # Ensure requests for pagespeed optimized resources go to the pagespeed handler
    # and no extraneous headers get set.
    location ~ "\.pagespeed\.([a-z]\.)?[a-z]{2}\.[^.]{10}\.[^.]+" {
        add_header "" "";
    }
    location ~ "^/ngx_pagespeed_static/" { }
    location ~ "^/ngx_pagespeed_beacon$" { }
    location /ngx_pagespeed_statistics { allow 127.0.0.1; deny all; }
    location /ngx_pagespeed_global_statistics { allow 127.0.0.1; deny all; }
    location /ngx_pagespeed_message { allow 127.0.0.1; deny all; }

L'intérêt est le suivant:

 * Optimise les images (dégage les métadonnées, redimensionnement dynamique, compression)
 * Minification des fichiers JavaScript
 * Extension de la durée de vie du cache
 * Légère réécriture des fichiers HTML
 * `et plus encore <https://developers.google.com/speed/pagespeed/module/config_filters#level>`_.