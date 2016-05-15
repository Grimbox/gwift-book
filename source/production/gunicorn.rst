*************
Gunicorn
*************

Nous allons utiliser ``gunicorn`` comme serveur d'applications, le serveur fourni par django n'étant pas fait pour être utilisé en production.

Gunicorn a déjà été installé lors de la préparation de l'environnement. De même que ``setproctitle``, qui est nécessaire pour donner le nom de l'application aux processus python lancés par gunicorn.

Nous pouvons donc directement tester s'il fonctionne:

.. code-block:: shell

    (gwift)gwift@gwift:~$ gunicorn gwift.wsgi:application --bind esever_name.com:8000
    
Et en se rendant sur server_name.com:8000/admin, on obtient la même chose qu'avec le serveur de django:

.. image:: production/admin_without_static.png
    :align: center
    
Nous allons maintenant créer un fichier qui se chargera de lancer gunicorn correctement, que l'on sauve dans ``/webapps/gwift/gwift/bin/gunicorn_start``:

.. code-block:: shell

    #!/bin/bash

    # Define settings for gunicorn
    NAME="gwift"                                      # Name of the application
    DJANGODIR=/webapps/gwift/gwift/gwift              # Django project directory
    SOCKFILE=/webapps/gwift/gwift/run/gunicorn.sock   # we will communicte using this unix socket
    USER=gwift                                        # the user to run as
    GROUP=webapps                                     # the group to run as
    NUM_WORKERS=3                                     # how many worker processes should Gunicorn spawn
    DJANGO_SETTINGS_MODULE=gwift.settings             # which settings file should Django use
    DJANGO_WSGI_MODULE=gwift.wsgi                     # WSGI module name

    echo "Starting $NAME as `whoami`"

    # Activate the virtual environment
    source /webapps/gwift/.virtualenvs/gwift/bin/activate
    cd $DJANGODIR
    export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
    export PYTHONPATH=$DJANGODIR:$PYTHONPATH

    # Create the run directory if it doesn't exist
    RUNDIR=$(dirname $SOCKFILE)
    test -d $RUNDIR || mkdir -p $RUNDIR

    # Start your Django Unicorn
    # Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
    exec gunicorn ${DJANGO_WSGI_MODULE}:application \
    --name $NAME \
    --workers $NUM_WORKERS \
    --user=$USER --group=$GROUP \
    --bind=unix:$SOCKFILE \
    --log-level=debug \
    --log-file=-

Explications:

 * NUM_WORKERS : gunicorn lance autant de worker que ce nombre. Un worker représente l'équivallant d'une instance de django et ne peut traiter qu'une requête à la fois. Traditionnellement, on créé autant de worker que le double du nombre de processeurs plus un.
 * SOCKFILE : on configure gunicorn pour communiquer via un socket unix, ce qui est plus efficace de le faire par tcp/ip
 
Le script se charge donc de définir les options de configuration de gunicorn, de lancer l'environnement virtuel et ensuite gunicorn.

On peut le tester avec la commande suivante (hors environnement virtuel):

.. code-block:: shell

    gwift@gwift:~$ source /webapps/gwift/gwift/bin/gunicorn_start

Et avec un petit ``ps`` dans un autre shell:

.. code-block:: shell

    gwift@gwift:~$ ps -u gwift -F
    UID        PID  PPID  C    SZ   RSS PSR STIME TTY          TIME CMD
    gwift    31983 15685  0 18319 15084   1 Apr29 ?        00:00:01 gunicorn: master [gwift]                                                                                                                                                     
    gwift    31992 31983  0 35636 29312   1 Apr29 ?        00:00:00 gunicorn: worker [gwift]                                                                                                                                                     
    gwift    31993 31983  0 35634 29280   2 Apr29 ?        00:00:00 gunicorn: worker [gwift]                                                                                                                                                     
    gwift    31994 31983  0 35618 29228   0 Apr29 ?        00:00:00 gunicorn: worker [gwift]
    
On voit donc bien qu'il y a un maître et trois workers.