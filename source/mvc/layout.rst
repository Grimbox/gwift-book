************
Mise en page
************


Pour que nos pages soient un peu plus *eye-candy* que ce qu'on a présenté ci-dessus, nous allons modifié notre squelette pour qu'il se base sur `Bootstrap <http://getbootstrap.com/>`_. Nous placerons une barre de navigation principale, la possibilité de se connecter pour l'utilisateur et définirons quelques emplacements à utiliser par la suite. Reprenez votre fichier ``base.html`` et modifiez le comme ceci:

.. code-block:: html

    {% load staticfiles %}

    <!DOCTYPE html>
    <!--[if IE 9]><html class="lt-ie10" lang="en" > <![endif]-->
    <html class="no-js" lang="en">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" rel="stylesheet">
        <script src="//code.jquery.com/jquery.min.js"></script>
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
        <link href='https://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css'>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
        <link href="{% static 'css/style.css' %}" rel="stylesheet">
        <link rel="icon" href="{% static 'img/favicon.ico' %}" />
        <title>Gwift</title>
    </head>

    <body class="base-body">

        <!-- navigation -->
        <div class="nav-wrapper">
            <div id="nav">
                <nav class="navbar navbar-default navbar-static-top navbar-shadow">
                    <div class="container-fluid">
                        <div class="navbar-header">
                            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#menuNavbar">
                                <span class="icon-bar"></span>
                                <span class="icon-bar"></span>
                                <span class="icon-bar"></span>
                            </button>
                            <a class="navbar-brand" href="/">
                                <img src="{% static 'img/gwift-20x20.png' %}" />
                            </a>
                        </div>
                        <div class="collapse navbar-collapse" id="menuNavbar">                        
                            {% include "_menu_items.html" %}
                        </div>
                    </div>
                </nav>
            </div>
        </div>
        <!-- end navigation -->

        <!-- content -->
        <div class="container">
            <div class="row">
                <div class="col-md-8">
                    {% block content %}{% endblock %}
                </div>
            </div>
        </div>
        <!-- end content -->
        
        <!-- footer -->
        <footer class="footer">
            {% include "_footer.html" %}
        </footer>
        <!-- end footer -->
    </body>
    </html>

Quelques remarques:

 * La première ligne du fichier inclut le *tag* ``{% load staticfiles %}``. On y reviendra par la suite, mais en gros, cela permet de faciliter la gestion des fichiers statiques, notamment en les appelent grâce à la commande ``{% static 'img/header.png' %}`` ou ``{% static 'css/app_style.css' %}``. 
 * La balise ``<head />`` est bourée d'appel vers des ressources stockées sur des :abbr:`CDN (Content Delivery Networks)`.
 * Les balises ``{% block content %} {% endblock %}`` permettent de faire hériter du contenu depuis une autre page. On l'utilise notamment dans notre page ``templates/wish/list.html``.
 * Pour l'entête et le bas de page, on fait appel aux balises ``{% include 'nom_du_fichier.html' %}``: ces fichiers sont des fichiers physiques, placés sur le filesystem, juste à côté du fichier ``base.html``. De façon bête et méchante, cela inclut juste du contenu HTML. Le contenu des fichiers ``_menu_items.html`` et ``_footer.html`` est copié ci-dessous.
 
.. code-block:: html

    <!-- gwift/templates/wish/list.html -->
    
    {% extends "base.html" %}

    {% block content %}
        <p>Mes listes de souhaits</p>
        <ul>
        {% for wishlist in wishlists %}
            <li>{{ wishlist.name }}: {{ wishlist.description }}</li>
        {% endfor %}
        </ul>
    {% endblock %}


 
.. code-block:: html

    <!-- gwift/templates/_menu_items.html -->
    <ul class="nav navbar-nav">
        <li class="">
            <a href="#">
                <i class="fa fa-calendar"></i> Mes listes
            </a>
        </li>
    </ul>
    <ul class="nav navbar-nav navbar-right">
        <li class="">
            <a href="#">
                <i class="fa fa-user"></i> Login / Register
            </a>
        </li>
    </ul>
 
.. code-block:: html
    
    <!-- gwift/templates/_footer.html -->
    <div class="container">
        Copylefted '16
    </div>

En fonction de vos affinités, vous pourriez également passer par `PluCSS <http://plucss.pluxml.org/>`_, `Pure <http://purecss.io/>`_, `Knacss <http://knacss.com/>`_, `Cascade <http://www.cascade-framework.com/>`_, `Semantic <http://semantic-ui.com/>`_ ou `Skeleton <http://getskeleton.com/>`_. Pour notre plus grand bonheur, les frameworks de ce type pullulent. Reste à choisir le bon. 

*A priori*, si vous relancez le serveur de développement maintenant, vous devriez déjà voir les modifications... Mais pas les images, ni tout autre fichier statique.

Fichiers statiques
==================

Si vous ouvrez la page et que vous lancez la console de développement (F12, sur la majorité des navigateurs), vous vous rendrez compte que certains fichiers ne sont pas disponibles. Il s'agit des fichiers suivants:

 * ``/static/css/style.css``
 * ``/static/img/favicon.ico``
 * ``/static/img/gwift-20x20.png``.

En fait, par défaut, les fichiers statiques sont récupérés grâce à deux handlers: ``django.contrib.staticfiles.finders.FileSystemFinder`` et ``django.contrib.staticfiles.finders.AppDirectoriesFinder``. En fait, Django va considérer un répertoire ``static`` à l'intérieur de chaque application. Si deux fichiers portent le même nom, le premier trouvé sera pris. Par facilité, et pour notre développement, nous placerons les fichiers statiques dans le répertoire ``gwift/static``. On y trouve donc: 

.. code-block:: shell

    [inclure un tree du répertoire gwift/static]

Pour indiquer à Django que vous souhaitez aller y chercher vos fichiers, il faut initialiser la `variable <https://docs.djangoproject.com/en/stable/ref/settings/#std:setting-STATICFILES_DIRS>`_ ``STATICFILES_DIRS`` dans le fichier ``settings/base.py``. Vérifiez également que la variable ``STATIC_URL`` est correctement définie.

.. code-block:: python

    # gwift/settings/base.py
    
    STATIC_URL = '/static/'
    
.. code-block:: python

    # gwift/settings/dev.py
    
    STATICFILES_DIRS = [
        os.path.join(BASE_DIR, "static"),
    ]

En production par contre, nous ferons en sorte que le contenu statique soit pris en charge par le front-end Web (Nginx), raison pour laquelle cette variable n'est initialisée que dans le fichier des paramètres liés au développement.

Au final, cela ressemble à ceci:

.. image:: mvc/my-first-wishlists.png
	 :align: center