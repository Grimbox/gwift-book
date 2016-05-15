**********
Monitoring
**********

Pour lancer et surveiller gunicorn, nous allons utiliser supervisord, qui est un démon sous lunix permettant de lancer d'autre programmes.

On commence par l'installer:

.. code-block:: shell

    $$$ aptitude install supervisor
    
On crée ensuite une fichier de configuration, ``/etc/supervisor/conf.d/gwift.conf``, qui sera lu au démarage de supervisord.

.. code-block:: shell

    [program:gwift]
    command = /webapps/gwift/gwift/bin/gunicorn_start                     ; Command to start
    user = gwift                                                          ; User to run as
    stdout_logfile = /webapps/gwift/gwift/logs/gunicorn_supervisor.log    ; Where to write log messages
    environment=LANG=en_US.UTF-8,LC_ALL=en_US.UTF-8                       ; Set UTF-8 as default encoding
    autostart=true                                                        ; Start the program when supervisord is starting
    autorestart=unexpected                                                ; Restart program if it exited anormaly
    redirect_stdout=true                                                  ; Redirect program output to the log file
    redirect_stderr=true                                                  ; Redirect program error to the log file
    
On peut alors démarer supervisor:


.. code-block:: shell

    $$$ service supervisor start
    
On peut vérifier que notre site est bien en train de tourner, à l'aide de la commande ``supervisorctl``:

.. code-block:: shell

    $$$ supervisorctl status gwift
    gwift                            RUNNING    pid 31983, uptime 0:01:00

Pour gérer le démarage ou l'arrêt de notre application, nous pouvons effectuer les commandes suivantes:

.. code-block:: shell

    $$$ supervisorctl stop gwift
    gwift: stopped
    root@ks3353535:/etc/supervisor/conf.d# supervisorctl start gwift
    gwift: started
    root@ks3353535:/etc/supervisor/conf.d# supervisorctl restart gwift
    gwift: stopped
    gwift: started
