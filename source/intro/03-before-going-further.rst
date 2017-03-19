****************************************
Construire des applications maintenables
****************************************

Pour cette section, je me base d'un résumé de l'ebook **Building Maintenable Software** disponible chez `O'Reilly <http://shop.oreilly.com/product/0636920049555.do`_ qui vaut clairement le détour pour poser les bases d'un projet.

Ce livre répartit un ensemble de conseils parmi quatre niveaux de composants:

 * Les méthodes et fonctions
 * Les classes
 * Les composants
 * Et de manière plus générale.

Au niveau des méthodes et fonctions
===================================

 * Gardez vos méthodes/fonctions courtes. Pas plus de 15 lignes, en comptant les commentaires. Des exceptions sont possibles, mais dans une certaine mesure uniquement (pas plus de 6.9% de plus de 60 lignes; pas plus de 22.3% de plus de 30 lignes, au plus 43.7% de plus de 15 lignes et au moins 56.3% en dessous de 15 lignes). Oui, c'est dur à tenir, mais faisable.
 * Conserver une complexité de McCabe en dessous de 5, c'est-à-dire avec quatre branches au maximum. A nouveau, si on a une méthode avec une complexité cyclomatique de 15, la séparer en 3 fonctions avec une complexité de 5 conservera globalement le nombre 15, mais rendra le code de chacune de ces méthodes plus lisible, plus maintenable.
 * N'écrivez votre code qu'une seule fois: évitez les duplications, copie, etc., c'est juste mal: imaginez qu'un bug soit découvert dans une fonction; il devra alors être corrigé dans toutes les fonctions qui auront été copiées/collées. C'est aussi une forme de régression.
 * Conservez de petites interfaces. Quatre paramètres, pas plus. Au besoin, refactorisez certains paramètres dans une classe, plus facile à tester.

Au niveau des classes
=====================

 * Privilégiez un couplage faible entre vos classes. Ceci n'est pas toujours possible, mais dans la mesure du possible, éclatez vos classes en fonction de leur domaine de compétences. L'implémentation du service ``UserNotificationsService`` ne doit pas forcément se trouver embarqué dans une classe ``UserService``. De même, pensez à passer par une interface (commune à plusieurs classes), afin d'ajouter une couche d'abstraction. La classe appellante n'aura alors que les méthodes offertes par l'interface comme points d'entrée.

Au niveau des composants
========================

 * Tout comme pour les classes, il faut conserver un couplage faible au niveau des composants également. Une manière d'arriver à ce résultat est de conserver un nombre de points d'entrée restreint, et d'éviter qu'on ne puisse contacter trop facilement des couches séparées de l'architecture. Pour une architecture n-tiers par exemple, la couche d'abstraction à la base de données ne peut être connue que des services; sans cela, au bout de quelques semaines, n'importe quelle couche de présentation risque de contacter directement la base de données, "juste parce qu'elle en a la possibilité". Vous pourrez également passer par des interfaces, afin de réduire le nombre de points d'entrée connus par un composant externe (qui ne connaîtra par exemple que `IFileTransfer` avec ses méthodes `put` et `get`, et non pas les détails d'implémentation complet d'une classe `FtpFileTransfer` ou `SshFileTransfer`).
 * Conserver un bon balancement au niveau des composants: évitez qu'un composant **A** ne soit un énorme mastodonte, alors que le composant juste à côté n'est capable que d'une action. De cette manière, les nouvelles fonctionnalités seront mieux réparties parmi les différents systèmes, et les responsabilités plus faciles à gérer. Un conseil est d'avoir un nombre de composants compris entre 6 et 12 (idéalement, 12), et que ces composants soit approximativement de même taille.

De manière plus générale
========================

 * Conserver une densité de code faible: il n'est évidemment pas possible d'implémenter n'importe quelle nouvelle fonctionnalité en moins de 20 lignes de code; l'idée ici est que la réécriture du projet ne prenne pas plus de 20 hommes/mois. Pour cela, il faut (activement) passer du temps à réduire la taille du code existant: soit en faisant du refactoring (intensif?), soit en utilisant des librairies existantes, soit en explosant un système existant en plusieurs sous-systèmes communiquant entre eux. Mais surtout en évitant de copier/coller bêtement du code existant.
 * Automatiser les tests, ajouter un environnement d'intégration continue dès le début du projet et vérifier par des outils les points ci-dessus.

***********
En pratique
***********

Par rapport aux points repris ci-dessus, l'environnement Python et le framework Django proposent un ensemble d'outils intégrés qui permettent de répondre à chaque point. Avant d'aller plus loin, donc, un petit point sur les conventions, les tests (unitaires, orientés comportement, basés sur la documentation, ...), la gestion de version du code et sur la documentation. Plus que dans tout langage compilé, ceux-ci sont pratiquement obligatoires. Vous pourrez les voir comme une perte de temps dans un premier temps, mais nous vous promettons qu'ils vous en feront gagner par la suite.

PEP8
====

Le langage Python fonctionne avec un système d'améliorations basées sur des propositions: les PEP, ou "**Python Enhancement Proposal**". Chacune d'entre elles doit être approuvée par le `Benevolent Dictator For Life <http://fr.wikipedia.org/wiki/Benevolent_Dictator_for_Life>`_.

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

PEP257
======

.. todo:: à remplir avec ``pydocstyle``.

Tests
=====

Comme tout bon *framework* qui se respecte, Django embarque tout un environnement facilitant le lancement de tests; chaque application est créée par défaut avec un fichier **tests.py**, qui inclut la classe ``TestCase`` depuis le package ``django.test``:

.. code-block:: python

    from django.test import TestCase
    
    class TestModel(TestCase):
        def test_str(self):
            raise NotImplementedError('Not implemented yet')

Idéalement, chaque fonction ou méthode doit être testée afin de bien en valider le fonctionnement, indépendamment du reste des composants. Cela permet d'isoler chaque bloc de manière unitaire, et permet de ne pas rencontrer de régression lors de l'ajout d'une nouvelle fonctionnalité ou de la modification d'une existante. Il existe plusieurs types de tests (intégration, comportement, ...); on ne parlera ici que des tests unitaires.

Avoir des tests, c'est bien. S'assurer que tout est testé, c'est mieux. C'est là qu'il est utile d'avoir le pourcentage de code couvert par les différents tests, pour savoir ce qui peut être amélioré.

Couverture de code
==================

La couverture de code est une analyse qui donne un pourcentage lié à la quantité de code couvert par les tests. Attention qu'il ne s'agit pas de vérifier que le code est **bien** testé, mais juste de vérifier **quelle partie** du code est testée. En Python, il existe le paquet `coverage <https://pypi.python.org/pypi/coverage/>`_, qui se charge d'évaluer le pourcentage de code couvert par les tests. Ajoutez-le dans le fichier ``requirements/base.txt``, et lancez une couverture de code grâce à la commande ``coverage``. La configuration peut se faire dans un fichier ``.coveragerc`` que vous placerez à la racine de votre projet, et qui sera lu lors de l'exécution.

.. code-block:: shell

    # requirements/base.text
    [...]
    coverage
    django_coverage_plugin

.. code-block:: shell

    # .coveragerc to control coverage.py
    [run]
    branch = True
    omit = ../*migrations*
    plugins = 
        django_coverage_plugin

    [report]
    ignore_errors = True

    [html]
    directory = coverage_html_report
    

.. todo:: le bloc ci-dessous est à revoir pour isoler la configuration.

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

Ceci vous affichera non seulement la couverture de code estimée, et générera également vos fichiers sources avec les branches non couvertes. Pour gagner un peu de temps, n'hésitez pas à créer un fichier ``Makefile`` que vous placerez à la racine du projet. L'exemple ci-dessous permettra, grâce à la commande ``make coverage``, d'arriver au même résultat que ci-dessus:

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

La `complexité cyclomatique <https://fr.wikipedia.org/wiki/Nombre_cyclomatique>`_ (ou complexité de McCabe) peut s'apparenter à mesure de difficulté de compréhension du code, en fonction du nombre d'embranchements trouvés dans une même section. Quand le cycle d'exécution du code rencontre une condition, il peut soit rentrer dedans, soit passer directement à la suite. Par exemple:

.. code-block:: python

    if True == True:
        pass # never happens
    
    # continue ...

La condition existe, mais on ne passera jamais dedans. A l'inverse, le code suivant aura une complexité pourrie à cause du nombre de conditions imbriquées:

.. code-block:: python

    def compare(a, b, c, d, e):
        if a == b:
            if b == c:
                if c == d:
                    if d == e:
                        print('Yeah!')
                        return 1

Potentiellement, les tests unitaires qui seront nécessaires à couvrir tous les cas de figure seront au nombre de quatre: le cas par défaut (a est différent de b, rien ne se passe), puis les autres cas, jusqu'à arriver à l'impression à l'écran et à la valeur de retour. La complexité cyclomatique d'un bloc est évaluée sur base du nombre d'embranchements possibles; par défaut, sa valeur est de 1. Si on rencontre une condition, elle passera à 2, etc. 

Pour l'exemple ci-dessous, on va en fait devoir vérifier au moins chacun des cas pour s'assurer que la couverture est complète. On devrait donc trouver:

 1. Un test pour entrer (ou non) dans la condition ``a == b``
 2. Un test pour entrer (ou non) dans la condition ``b == c``
 3. Un test pour entrer (ou non) dans la condition ``c == d``
 4. Un test pour entrer (ou non) dans la condition ``d == e``
 5. Et s'assurer que n'importe quel autre cas retournera la valeur ``None``.
 
On a donc bien besoin de minimum cinq tests pour couvrir l'entièreté des cas présentés.

Le nombre de tests unitaires nécessaires à la couverture d'un bloc est au minimum égal à la complexité cyclomatique de ce bloc. Une possibilité pour améliorer la maintenance du code est de faire baisser ce nombre, et de le conserver sous un certain seuil. Certains recommandent de le garder sous une complexité de 10; d'autres de 5.

.. note::

    Evidemment, si on refactorise un bloc pour en extraire une méthode, cela   n'améliorera pas sa complexité cyclomatique globale

A nouveau, un greffon pour ``flake8`` existe et donnera une estimation de la complexité de McCabe pour les fonctions trop complexes. Installez-le avec `pip install mccabe`, et activez-le avec le paramètre ``--max-complexity``. Toute fonction dans la complexité est supérieure à cette valeur sera considérée comme trop complexe.

Documentation
=============

Il existe plusieurs manières de générer la documentation d'un projet. Les plus connues sont `Sphinx <http://sphinx-doc.org/>`_ et `MkDocs <http://www.mkdocs.org/>`_. Le premier a l'avantage d'être plus reconnu dans la communauté Python que l'autre, de pouvoir *parser* le code pour en extraire la documentation et de pouvoir lancer des `tests orientés documentation <https://duckduckgo.com/?q=documentation+driven+development&t=ffsb>`_. A contrario, votre syntaxe devra respecter `ReStructuredText <https://en.wikipedia.org/wiki/ReStructuredText>`_. Le second a l'avantage d'avoir une syntaxe plus simple à apprendre et à comprendre, mais est plus limité dans son résultat.

Dans l'immédiat, nous nous contenterons d'avoir des modules documentés (quelle que soit la méthode Sphinx/MkDocs/...). Dans la continuié de ``Flake8``, il existe un greffon qui vérifie la présence de commentaires au niveau des méthodes et modules développés.

.. note::

    voir si il ne faudrait pas mieux passer par pydocstyle.

.. code-block:: shell

    $ pip install flake8_docstrings

Lancez ensuite `flake8` avec la commande ``flake8 . --exclude="migrations"``. Sur notre projet (presque) vide, le résultat sera le suivant:

.. code-block:: shell

    $ flake8 . --exclude="migrations"
    .\src\manage.py:1:1: D100  Missing docstring in public module
    .\src\gwift\__init__.py:1:1: D100  Missing docstring in public module
    .\src\gwift\urls.py:1:1: D400  First line should end with a period (not 'n')
    .\src\wish\__init__.py:1:1: D100  Missing docstring in public module
    .\src\wish\admin.py:1:1: D100  Missing docstring in public module
    .\src\wish\admin.py:1:1: F401 'admin' imported but unused
    .\src\wish\models.py:1:1: D100  Missing docstring in public module
    .\src\wish\models.py:1:1: F401 'models' imported but unused
    .\src\wish\tests.py:1:1: D100  Missing docstring in public module
    .\src\wish\tests.py:1:1: F401 'TestCase' imported but unused
    .\src\wish\views.py:1:1: D100  Missing docstring in public module
    .\src\wish\views.py:1:1: F401 'render' imported but unused


Bref, on le voit: nous n'avons que très peu de modules, et aucun d'eux n'est commenté.

En plus de cette méthode, Django permet également de rendre la documentation accessible depuis son interface d'administration.

PyLint
======

PyLint est la version **++**, pour ceux qui veulent un code propre et sans bavure.

.. todo:: à développer

Gestion de version du code
==========================

Il existe plusiseurs outils permettant de gérer les versions du code, dont les plus connus sont `git <https://git-scm.com/>`_ et `mercurial <https://www.mercurial-scm.org/>`_.

Dans notre cas, nous utilisons git et hebergons le code et le livre directement sur le gitlab de `framasoft <https://git.framasoft.org/>`_

