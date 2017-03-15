=============
Documentation
=============

Documentation: be obsessed!

On en a déjà parlé plus haut, il existe un standard en Python pour la définition de la documentation du code: RST (et par extension, Sphinx, qui est le représentatn *de facto* pour la récupération du code d'une application et sa présentation dans un format souhaité: HTML, ePub, Latex, PDF, ...).

Python étant un langage interprété fortement typé, il est plus que conseillé, au même titre que les tests unitaires, de documenter son code.
Cela impose une certaine rigueur, mais améliore énormément la qualité (et la reprise) du code par une tierce personne. Cela implique aussi de **tout** documenter: les modules, les paquets, les classes, les fonctions, méthodes, ... Tout doit avoir un *docstring* associé :-).

Plusieurs modules de documentation existent, mais nous allons nous concentrer sur Sphinx, qui semble être le plus complet et qui permet d'héberger directement sa documentation sur `ReadTheDocs.org <https://readthedocs.org/>`_. Nous allons également faire en sorte que cette documentation soit compatible avec Django, puisque c'est le but de notre projet.

------
Sphinx
------

Commencez par installer Sphinx et ajoutez le dans le fichier ``requirements/base.txt``. *A priori*, il n'est pas nécessaire de spécifier une version: Sphinx est un outil périphérique, qui ne dépendra pas des autres librairies. Une fois que ce sera fait, exécutez la commande ``sphinx-quickstart``, afin d'initier la documentation pour notre projet:

.. code-block:: shell

    $ sphinx-quickstart.exe
    Welcome to the Sphinx 1.3.3 quickstart utility.

    Please enter values for the following settings (just press Enter to
    accept a default value, if one is given in brackets).

    Enter the root path for documentation.
    > Root path for the documentation [.]: ./docs
    > Separate source and build directories (y/n) [n]: n
    > Name prefix for templates and static dir [_]: _
    > Project name: Gwift
    > Author name(s): Fred & Ced
    > Project version: 0.1
    > Project release [0.1]:
    > Project language [en]: fr
    > Source file suffix [.rst]: .rst
    > Name of your master document (without suffix) [index]:
    > Do you want to use the epub builder (y/n) [n]: n
    Please indicate if you want to use one of the following Sphinx extensions:
    > autodoc: automatically insert docstrings from modules (y/n) [n]: y
    > doctest: automatically test code snippets in doctest blocks (y/n) [n]: y
    > intersphinx: link between Sphinx documentation of different projects (y/n) [n] n
    > todo: write "todo" entries that can be shown or hidden on build (y/n) [n]: y
    > coverage: checks for documentation coverage (y/n) [n]: y
    > pngmath: include math, rendered as PNG images (y/n) [n]: n
    > mathjax: include math, rendered in the browser by MathJax (y/n) [n]: n
    > ifconfig: conditional inclusion of content based on config values (y/n) [n]: n
    > viewcode: include links to the source code of documented Python objects (y/n) [n]: y
    > Create Makefile? (y/n) [y]: y
    > Create Windows command file? (y/n) [y]: y

    Creating file ./docs\conf.py.
    Creating file ./docs\index.rst.
    Creating file ./docs\Makefile.
    Creating file ./docs\make.bat.

    Finished: An initial directory structure has been created.

Deux-trois petites choses à modifier pour que Sphinx puisse intéragir avec Django. Ouvrez le fichier ``docs/conf.py`` et modifier ou ajoutez les variables suivantes:

.. code-block:: python

    # docs/conf.py

    sys.path.insert(0, os.path.abspath('../gwift'))
    sys.path.insert(0, os.path.abspath('.'))

    from django.conf import settings
    settings.configure()

    html_theme = 'sphinx_rtd_theme'

De cette manière, on modifie le thème utilisé lors de la génération des pages HTML, en remplaçant le thème Alabaster par le thème ReadTheDocs, on demande à Sphinx d'initier l'environnement Django existant, et on lui demande également d'aller chercher les informations dans le répertoire courant, mais également dans le répertoire ``../gwift``.
Sans cela, les références que l'on fera dans la documentation ne seront pas récupérées.
