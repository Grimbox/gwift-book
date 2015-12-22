*********
Templates
*********

Avant de commencer à interagir avec nos données au travers de listes, formulaires et IHM sophistiquées, quelques mots sur les templates: il s'agit en fait de *squelettes* de présentation, recevant en entrée un dictionnaire contenant des clés-valeurs et ayant pour but de les afficher dans le format que vous définirez. En intégrant un ensemble de *tags*, cela vous permettra de greffer les données reçues en entrée dans un patron prédéfini.

Une page HTML basique ressemble à ceci:

.. code-block:: html

    <!doctype html>
    <html>
        <head>
            <meta charset="utf-8">
            <meta http-equiv="x-ua-compatible" content="ie=edge">
            <title></title>
        </head>
        <body>
            <p>Hello world!</p>
        </body>
    </html>

Notre première vue permettra de récupérer la liste des objets de type ``Wishlist`` que nous avons définis dans le fichier ``wish/models.py``. Supposez que cette liste soit accessible *via* la clé ``wishlists`` d'un dictionnaire passé au template. Elle devient dès lors accessible grâce aux tags ``{% for wishlist in wishlists %}``. A chaque tour de boucle, on pourra directement accéder à la variable ``{{ wishlist }}``. De même, il sera possible d'accéder aux propriétés de cette objet de la même manière: ``{{ wishlist.id }}``, ``{{ wishlist.description }}``, ... et d'ainsi respecter la mise en page que nous souhaitons.

En reprenant l'exemple de la page HTML définie ci-dessus, on pourra l'agrémenter de la manière suivante:

.. code-block:: html

    <!doctype html>
    <html>
        <head>
            <meta charset="utf-8">
            <meta http-equiv="x-ua-compatible" content="ie=edge">
            <title></title>
        </head>
        <body>
            <p>Mes listes de souhaits</p>
            <ul>
            {% for wishlist in wishlists %}
              <li>{{ wishlist.name }}: {{ wishlist.description }}</li>
            {% endfor %}
            </ul>
        </body>
    </html>


Vous pouvez déjà copié ce contenu dans un fichier ``templates/wsh/list.html``, on en aura besoin par la suite.

Structure et configuration
==========================

Il est conseillé que les templates respectent la structure de vos différentes applications, mais dans un répertoire à part. Par convention, nous les placerons dans un répertoire ``templates``. La hiérarchie des fichiers devient alors celle-ci:

.. code--block:: bash

    $ tree templates/
    templates/
    └── wish
        └── list.html

Par défaut, Django cherchera les templates dans les répertoirer d'installation. Vous devrez vous éditer le fichier ``gwift/settings.py`` et ajouter, dans la variable ``TEMPLATES``, la clé ``DIRS`` de la manière suivante:

.. code-block:: python

    TEMPLATES = [
        {
            ...
            'DIRS': [ 'templates' ],
            ...
        },
    ]

Builtins
========

Django vient avec un ensemble de *tags*. On a vu la boucle ``for`` ci-dessus, mais il existe `beaucoup d'autres tags nativement présents <https://docs.djangoproject.com/fr/1.9/ref/templates/builtins/>`_. Les principaux sont par exemple:

 * ``{% if ... %} ... {% elif ... %} ... {% else %} ... {% endif %}``: permet de vérifier une condition et de n'afficher le contenu du bloc que si la condition est vérifiée.
 * Opérateurs de comparaisons: ``<``, ``>``, ``==``, ``in``, ``not in``.
 * Regroupements avec le tag ``{% regroup ... by ... as ... %}``.
 * ``{% url %}``
 * ...
