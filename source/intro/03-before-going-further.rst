**************************
Avant d'aller plus loin...
**************************

Avant d'aller plus loin, donc, un petit point sur les conventions, les tests (unitaires, orientés comportement, basés sur la documentation, ...), la gestion de verstion du code et sur la documentation. Plus que dans tout langage compilé, ceux-ci sont pratiquement obligatoires. Vous pourrez les voir comme une perte de temps dans un premier temps, mais nous vous promettons qu'ils vous en feront gagner par la suite.

PEP8
====

Le langage Python fonctionne avec un système d'améliorations basées sur des propositions: les PEP, ou "Python Enhancement Proposal". Chacune d'entre elles doit être approuvée par le `Benevolent Dictator For Life <http://fr.wikipedia.org/wiki/Benevolent_Dictator_for_Life>`_.

La PEP qui nous intéresse plus particulièrement pour la suite est la `PEP-8 <https://www.python.org/dev/peps/pep-0008/>`_, ou "Style Guide for Python Code". Elle spécifie des conventions d'organisation et de formatage de code Python, quelles sont les conventions pour l'indentation, le nommage des variables et des classes, etc. En bref, elle décrit comment écrire du code proprement pour que d'autres développeurs puissent le reprendre facilement, ou simplement que votre base de code ne dérive lentement vers un seuil de non-maintenabilité.

Sur cette base, un outil existe et listera l'ensemble des conventions qui ne sont pas correctement suivies dans votre projet: pep8. Pour l'installer, passez par pip. Lancez ensuite la commande pep8 suivie du chemin à analyser (``.``, le nom d'un répertoire, le nom d'un fichier ``.py``, ...). Si vous souhaitez uniquement avoir le nombre d'erreur de chaque type, saisissez les options ``--statistics -qq``.

.. code-block:: shell

    $ pep8 . --statistics -qq

    7       E101 indentation contains mixed spaces and tabs
    6       E122 continuation line missing indentation or outdented
    8       E127 continuation line over-indented for visual indent
    23      E128 continuation line under-indented for visual indent
    3       E131 continuation line unaligned for hanging indent
    12      E201 whitespace after '{'
    13      E202 whitespace before '}'
    86      E203 whitespace before ':'

Si vous ne voulez pas être dérangé sur votre manière de coder, et que vous voulez juste avoir un retour sur une analyse de votre code, essayez ``pyflakes``: il analysera vos sources à la recherche de sources d'erreurs possibles (imports inutilisés, méthodes inconnues, etc.).

Finalement, la solution qui couvre ces deux domaines existe et s'intitule `flake8 <https://github.com/PyCQA/flake8>`_. Sur base la même interface que ``pep8``, vous aurez en plus tous les avantages liés à ``pyflakes`` concernant votre code source.


Tests et couverture de code
===========================

La couverture de code donne un pourcentage lié à la quantité de code couvert par les testss.
Attention que celle-ci ne permet pas de vérifier que le code est **bien** testé, elle permet juste de vérifier que le code est **testé**. En Python, il existe le paquet `coverage <https://pypi.python.org/pypi/coverage/>`_, qui se charge d'évaluer le pourcentage de code couvert par les tests. Si cela vous intéresse, ajoutez-le dans le fichier ``requirements/base.txt``, et lancez une couverture de code grâce à la commande ``coverage``. La configuration peut se faire dans un fichier ``.coveragerc`` que vous placerez à la racine de votre projet, et qui sera lu lors de l'exécution.

.. code-block:: shell

    # requirements/base.text
    [...]
    coverage

.. code-block:: shell

    # .coveragerc to control coverage.py
    [run]
    branch = True
    omit = ../*migrations*

    [report]
    ignore_errors = True

    [html]
    directory = coverage_html_report

.. code-block:: shell

    $ coverage run --source "." manage.py test
    $ coverage report

    Name                      Stmts   Miss  Cover
    ---------------------------------------------
    gwift\gwift\__init__.py       0      0   100%
    gwift\gwift\settings.py      17      0   100%
    gwift\gwift\urls.py           5      5     0%
    gwift\gwift\wsgi.py           4      4     0%
    gwift\manage.py               6      0   100%
    gwift\wish\__init__.py        0      0   100%
    gwift\wish\admin.py           1      0   100%
    gwift\wish\models.py         49     16    67%
    gwift\wish\tests.py           1      1     0%
    gwift\wish\views.py           6      6     0%
    ---------------------------------------------
    TOTAL                        89     32    64%

    $ coverage html

Ceci vous affichera non seulement la couverture de code estimée, et générera également vos fichiers sources avec les branches non couvertes. Pour gagner un peu de temps, n'hésitez pas à créer un fichier ``Makefile`` à la racine du projet. L'exemple ci-dessous permettra, grâce à la commande ``make coverage``, d'arriver au même résultat que ci-dessus:

.. code-block:: shell

    # Makefile for gwift
    #

    # User-friendly check for coverage
    ifeq ($(shell which coverage >/dev/null 2>&1; echo $$?), 1)
      $(error The 'coverage' command was not found. Make sure you have coverage installed)
    endif

    .PHONY: help coverage

    help:
    	@echo "  coverage to run coverage check of the source files."

    coverage:
    	coverage run --source='.' manage.py test; coverage report; coverage html;
    	@echo "Testing of coverage in the sources finished."

Complexité de McCabe
====================

La `complexité cyclomatique <https://fr.wikipedia.org/wiki/Nombre_cyclomatique>`_ (ou complexité de McCabe) peut s'apparenter à une [...]

A nouveau, un greffon pour ``flake8`` existe et donnera une estimation de la complexité de McCabe pour les fonctions trop complexes. Installez-le avec `pip install mccabe`, et activez-le avec le paramètre `--max-complexity`. Toute fonction dans la complexité est supérieure à 10 est considérée comme trop complexe.

// TODO

Documentation
=============

Il existe plusieurs manières de générer la documentation d'un projet. Les plus connues sont `Sphinx <http://sphinx-doc.org/>`_ et `MkDocs <http://www.mkdocs.org/>`_. Le premier a l'avantage d'être plus reconnu dans la communauté Python que l'autre, de pouvoir *parser* le code pour en extraire la documentation et de pouvoir lancer des `tests orientés documentation <https://duckduckgo.com/?q=documentation+driven+development&t=ffsb>`_. A contrario, votre syntaxe devra respecter `ReStructuredText <https://en.wikipedia.org/wiki/ReStructuredText>`_. Le second a l'avantage d'avoir une syntaxe plus simple à apprendre et à comprendre, mais est plus limité dans son résultat.

Dans l'immédiat, nous nous contenterons d'avoir des modules documentés (quelle que soit la méthode Sphinx/MkDocs/...). Dans la continuié de `Flake8`, il existe un greffon qui vérifie la présence de commentaires au niveau des méthodes et modules développés.

.. code-block:: shell

    pip install flake8_docstrings

Lancez ensuite `flake8` avec la commande `flake8 . --exclude="migrations"`. Sur notre projet (presque) vide, le résultat sera le suivant:

.. code-block:: shell

    $ flake8 . --exclude="migrations"
    .\gwift\manage.py:1:1: D100  Missing docstring in public module
    .\gwift\gwift\__init__.py:1:1: D100  Missing docstring in public module
    .\gwift\gwift\urls.py:1:1: D400  First line should end with a period (not 'n')
    .\gwift\wish\__init__.py:1:1: D100  Missing docstring in public module
    .\gwift\wish\admin.py:1:1: D100  Missing docstring in public module
    .\gwift\wish\admin.py:1:1: F401 'admin' imported but unused
    .\gwift\wish\models.py:1:1: D100  Missing docstring in public module
    .\gwift\wish\models.py:1:1: F401 'models' imported but unused
    .\gwift\wish\tests.py:1:1: D100  Missing docstring in public module
    .\gwift\wish\tests.py:1:1: F401 'TestCase' imported but unused
    .\gwift\wish\views.py:1:1: D100  Missing docstring in public module
    .\gwift\wish\views.py:1:1: F401 'render' imported but unused


Bref, on le voit: nous n'avons que très peu de modules, et aucun d'eux n'est commenté.

En plus de cette méthode, Django permet également de rendre la documentation accessible depuis son interface d'administration.

Gestion de version du code
==========================

Il existe plusiseurs outils permettant de gérer les versions du code, dont les plus connus sont `git <https://git-scm.com/>`_ et `mercurial <https://www.mercurial-scm.org/>`_.

Dans notre cas, nous utilisons git et hebergons le code et le livre directement sur le gitlab de `framasoft <https://git.framasoft.org/>`_

