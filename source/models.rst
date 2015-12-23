============
Modélisation
============

L'ORM de Django permet de travailler uniquement avec une définition de classes, et de faire en sorte que le lien avec la base de données soit géré uniquement de manière indirecte, par Django lui-même. On peut schématiser ce comportement par  une classe = une table.

Comme on l'a vu dans la description des fonctionnalités, on va *grosso modo* avoir besoin des éléments suivants:

 * Des listes de souhaits
 * Des éléments qui composent ces listes
 * Des parts pouvant composer chacun de ces éléments
 * Des utilisateurs pour gérer tout ceci.

Nous proposons dans un premier temps d'éluder la gestion des utilisateurs, et de simplement se concentrer sur les fonctionnalités principales.
Cela nous donne ceci:

.. code-block:: python

    # wish/models.py

    from django.db import models


    class Wishlist(models.Model):
        pass


    class Item(models.Model):
        pass


    class Part(models.Model):
        pass


Les classes sont créées, mais vides. Entrons dans les détails.

[Ajouter pourquoi on hérite de ``models.Model``, etc.)

.. include:: models/models.rst

.. include:: models/key-points.rst

.. include:: models/refactoring.rst

.. include:: models/user-management.rst

.. include:: models/console.rst

