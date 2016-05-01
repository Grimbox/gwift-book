************
Mise en page
************


Pour que nos pages soient un peu plus *eye-candy* que ce qu'on a présenté ci-dessus, nous allons modifié notre squelette pour qu'il se base sur `Bootstrap <http://getbootstrap.com/>`_. Nous placerons une barre de navigation principale, la possibilité de se connecter pour l'utilisateur et définirons quelques emplacements à utiliser par la suite. Reprenez votre fichier ``base.html`` et modifiez le comme ceci:

.. code-block:: html

    Blah



En fonction de vos affinités, vous pourriez également passer par `PluCSS <http://plucss.pluxml.org/>`_, `Pure <http://purecss.io/>`_, `Knacss <http://knacss.com/>`_, `Cascade <http://www.cascade-framework.com/>`_, `Semantic <http://semantic-ui.com/>`_ ou `Skeleton <http://getskeleton.com/>`_. Pour notre plus grand bonheur, les frameworks de ce type pullulent. Reste à choisir le bon. 

*A priori*, si vous relancez le serveur de développement maintenant, vous devriez déjà voir les modifications... Mais pas les images, ni fichiers statiques.

Fichiers statiques
==================

Si vous vous rendez sur la page ``localhost:8000/static/img/favicon.ico``, vous ne verrez rien qu'une page d'erreur. En fait, par défaut, les fichiers statiques sont récupérés grâce à deux handlers: ``django.contrib.staticfiles.finders.FileSystemFinder`` et ``django.contrib.staticfiles.finders.AppDirectoriesFinder``. En fait, Django va considérer un répertoire ``static`` à l'intérieur de chaque application. Si deux fichiers portent le même nom, le premier trouvé sera pris. Pour plus de facilité, il est possible de définir des valeurs supplémentaires dans votre fichier de configuration, en ajoutant `des valeurs à la variable <https://docs.djangoproject.com/en/1.9/ref/settings/#std:setting-STATICFILES_DIRS>`_ ``STATICFILES_DIR``:

.. code-block:: python

    # gwift/settings.py
    
    STATICFILES_DIRS = [
        "/home/special.polls.com/polls/static",
    ]

Vérifiez également que la variable ``STATIC_URL`` est correctement définie. Vous pourrez maintenant accéder aux fichiers statiques en chargeant le templatetags *built-in* dans votre squelette, via la commande ``{% load staticfiles %}``. Cette étape à un intérêt énorme lorsque vous passerez votre application en production: ici, nous parlons d'un serveur de développement. Il suffit que vos fichiers soient servis par Nginx, que l'URL change, et vous serez bon pour modifier toutes vos pages, ce qui est impensable. 