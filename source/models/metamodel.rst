**********
Métamodèle
**********

Sous ce titre franchement pompeux, on va un peu parler de la modélisation du modèle. Quand on prend une classe (par exemple, ``Wishlist`` que l'on a défini ci-dessus), on voit qu'elle hérite par défaut de ``models.Model``. On peut regarder les propriétés définies dans cette classe en analysant le fichier ``lib\site-packages\django\models\base.py``. On y voit notamment que ``models.Model`` hérite de ``ModelBase`` au travers de `six <https://pypi.python.org/pypi/six>`_ pour la rétrocompatibilité vers Python 2.7.

Cet héritage apporte notamment les fonctions ``save()``, ``clean()``, ``delete()``, ... Bref, toutes les méthodes qui font qu'une instance est sait **comment** interagir avec la base de données. La base d'un `ORM <https://en.wikipedia.org/wiki/Object-relational_mapping>`_, en fait.

D'autre part, chaque classe héritant de ``models.Model`` possède une propriété ``objects``. Comme on l'a vu dans la section **Jouons un peu avec la console**, cette propriété permet d'accéder aux objects persistants dans la base de données.
