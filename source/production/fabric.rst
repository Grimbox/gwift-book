*****************************
Automatisation du déploiement
*****************************

Pour automatiser le déploiement, il existe `Fabric <http://www.fabfile.org/>`_. 

 * **Problème**: cette librairie n'existe que pour Python2.7. 
 * **Avantage**: on peut écrire du code semblable à `ceci <https://github.com/UrLab/incubator/blob/master/fabfile.py>`_...

.. code-block:: python

    from fabric.api import run, cd
    from fabric.context_managers import prefix


    def deploy():
        code_dir = '/home/www-data/incubator'
        with cd(code_dir), prefix('source ve/bin/activate'):
            run('sudo supervisorctl stop incubator')
            run("./save_db.sh")
            run("git pull")
            run("pip install -r requirements.txt --upgrade -q")
            run("./manage.py collectstatic --noinput -v 0")
            run("./manage.py makemigrations")
            run("./manage.py migrate")
            run('sudo supervisorctl start incubator')

En gros: 

 1. On se place dans le bon répertoire
 2. On arrête le superviseur
 3. On sauve les données de la base de données
 4. On charge la dernière version depuis le dépôt Git
 5. On met les dépendances à jour (en mode silencieux)
 6. On agrège les fichiers statiques
 7. On lance les migrations
 8. Et on relance le superviseur.
 
Avec un peu de chances, l'instance est à jour.