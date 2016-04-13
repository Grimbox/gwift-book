*********
A retenir
*********

Constructeurs
=============

Si vous décidez de définir un constructeur sur votre modèle, ne surchargez pas la méthode ``__init__``: créez plutôt une méthode static de type ``create()``, en y associant les paramètres obligatoires ou souhaités:

.. code-block:: python

    class Wishlist(models.Model):

        @staticmethod
        def create(name, description):
            w = Wishlist()
            w.name = name
            w.description = description
            w.save()
            return w

    class Item(models.Model):

        @staticmethod
        def create(name, description, wishlist):
            i = Item()
            i.name = name
            i.description = description
            i.wishlist = wishlist
            i.save()
            return i

Relations
=========

Types de relations
------------------

 * ForeignKey
 * ManyToManyField
 * OneToOneField

Dans les examples ci-dessus, nous avons vu les relations multiples (1-N), représentées par des **ForeignKey** d'une classe A vers une classe B. Il existe également les champs de type **ManyToManyField**, afin de représenter une relation N-N. Il existe également les champs de type **OneToOneField**, pour représenter une relation 1-1.
Dans notre modèle ci-dessus, nous n'avons jusqu'à présent eu besoin que des relations 1-N: la première entre les listes de souhaits et les souhaits; la seconde entre les souhaits et les parts.

Mise en pratique
----------------

Dans le cas de nos listes et de leurs souhaits, on a la relation suivante:

.. code-block:: python

    # wish/models.py

    class Wishlist(models.Model):
        pass


    class Item(models.Model):
        wishlist = models.ForeignKey(Wishlist)

Depuis le code, à partir de l'instance de la classe ``Item``, on peut donc accéder à la liste en appelant la propriété ``wishlist`` de notre instance. *A contrario*, depuis une instance de type ``Wishlist``, on peut accéder à tous les éléments liés grâce à ``<nom de la propriété>_set``; ici ``item_set``.

Lorsque vous déclarez une relation 1-1, 1-N ou N-N entre deux classes, vou pouvez d'ajouter l'attribut ``related_name``. Cet attribut permet de nommer la relation inverse.

.. code-block:: python

    # wish/models.py

    class Wishlist(models.Model):
        pass


    class Item(models.Model):
        wishlist = models.ForeignKey(Wishlist, related_name='items')

A partir de maintenant, on peut accéder à nos propriétés de la manière suivante:

.. code-block:: python

    # $ python manage.py shell

    >>> from wish.models import Wishlist, Item
    >>> w = Wishlist('Liste de test', 'description')
    >>> w = Wishlist.create('Liste de test', 'description')
    >>> i = Item.create('Element de test', 'description', w)
    >>>
    >>> i.wishlist
    <Wishlist: Wishlist object>
    >>>
    >>> w.items.all()
    [<Item: Item object>]

Remarque: si, dans une classe A, plusieurs relations sont liées à une classe B, Django ne saura pas à quoi correspondra la relation inverse. Pour palier à ce problème et pour gagner en cohérence, on fixe alors une valeur à l'attribut ``related_name``.
