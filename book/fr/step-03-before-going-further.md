Avant d'aller plus loin...
==========================

Avant d'aller plus loin, donc, un petit point sur les conventions, les tests (unitaires, orientés comportement, basés sur la documentation, ...) et sur la documentation. Plus que dans tout langage compilé, ceux-ci sont pratiquement obligatoires. Vous pourrez les voir comme une perte de temps dans un premier temps, mais nous vous promettons qu'ils vous en feront gagner par la suite.

## PEP8

Le langage Python fonctionne avec un système d'améliorations basées sur des propositions: les PEP, ou "Python Enhancement Proposal". Chacune d'entre elles doit être approuvée par le [Benevolent Dictator For Life](http://fr.wikipedia.org/wiki/Benevolent_Dictator_for_Life).

La PEP qui nous intéresse plus particulièrement pour la suite est la [PEP-8](https://www.python.org/dev/peps/pep-0008/), ou "Style Guide for Python Code". Elle spécifie des conventions d'organisation et de formatage de code Python, quelles sont les conventions pour l'indentation, le nommage des variables et des classes, ... En bref, elle décrit comment écrire du code proprement pour que d'autres développeurs puissent le reprendre facilement, ou simplement que votre base de code ne dérive lentement vers un seuil de non-maintenabilité.

Sur cette base, un outil existe et listera l'ensemble des conventions qui ne sont pas correctement suivies dans votre projet: pep8. Pour l'installer, passez par pip. Lancez ensuite la commande pep8 suivie du chemin à analyser (., le nom d'un répertoire, le nom d'un fichier `.py`, ...). Si vous souhaitez uniquement avoir le nombre d'erreur de chaque type, saisissez les options `--statistics -qq`.

```shell
$ pep8 . --statistics -qq

7       E101 indentation contains mixed spaces and tabs
6       E122 continuation line missing indentation or outdented
8       E127 continuation line over-indented for visual indent
23      E128 continuation line under-indented for visual indent
3       E131 continuation line unaligned for hanging indent
12      E201 whitespace after '{'
13      E202 whitespace before '}'
86      E203 whitespace before ':'
```

Si vous ne voulez pas être dérangé sur votre manière de coder, et que vous voulez juste avoir un retour sur une analyse de votre code, essayez `pyflakes`: il analysera vos sources à la recherche de sources d'erreurs possibles (imports inutilisés, méthodes inconnues, etc.).

Finalement, la solution qui couvre ces deux domaines existe et s'intitule [flake8](https://github.com/PyCQA/flake8). Sur base la même interface que `pep8`, vous aurez en plus tous les avantages liés à `pyflakes` concernant votre code source.

## Tests et couverture de code

La couverture de code donne un pourcentage lié à la quantité de code couvert par les testss.
Attention que celle-ci ne permet pas de vérifier que le code est **bien** testé, elle permet juste de vérifier que le code est **testé**. Pour chaque fonction ou *statement* présent.


## Documentation

Il existe plusieurs manières de générer la documentation d'un projet. Les plus connues sont [Sphinx](http://sphinx-doc.org/) et [MkDocs](http://www.mkdocs.org/). Le premier a l'avantage d'être plus reconnu dans la communauté Python que l'autre, de pouvoir *parser* le code pour en extraire la documentation et de pouvoir lancer des [tests orientés documentation](https://duckduckgo.com/?q=documentation+driven+development&t=ffsb). A contrario, votre syntaxe devra respecter [ReStructuredText](https://en.wikipedia.org/wiki/ReStructuredText). Le second a l'avantage d'avoir une syntaxe plus simple à apprendre et à comprendre, mais est plus limité dans son résultat.

Dans l'immédiat, nous nous contenterons d'avoir des modules documentés (quelle que soit la méthode Sphinx/MkDocs/...). Dans la continuié avec `Flake8`, il existe un greffon qui vérifie la présence de commentaires au niveau des méthodes et modules développés.

```shell
pip install flake8_docstrings
```

Lancez ensuite `flake8` avec la commande `flake8 . --exclude="migrations"`. Sur notre projet (presque) vide, le résultat sera le suivant:

```shell
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
```

Bref, on le voit: nous n'avons que très peu de modules, et aucun d'eux n'est commenté.
