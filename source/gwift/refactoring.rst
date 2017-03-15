***********
Refactoring
***********

On constate que plusieurs classes possèdent les propriétés ``created_at`` et ``updated_at``, initialisées aux mêmes valeurs. Pour gagner en cohérence, nous allons créer une classe dans laquelle nous définirons ces deux champs, et nous ferons en sorte que les classes ``Wishlist``, ``Item`` et ``Part`` en héritent. Django gère trois sortes d'héritage:

 * L'héritage par classe abstraite
 * L'héritage classique
 * L'héritage par classe proxy.


Classe abstraite
================

L'héritage par classe abstraite consiste à déterminer une classe mère qui ne sera jamais instanciée. C'est utile pour définir des champs qui se répèteront dans plusieurs autres classes et surtout pour respecter le principe de DRY. Comme la classe mère ne sera jamais instanciée, ces champs seront en fait dupliqués physiquement, et traduits en SQL, dans chacune des classes filles.

.. code-block:: python

    # wish/models.py

    class AbstractModel(models.Model):
        class Meta:
            abstract = True

        created_at = models.DateTimeField(auto_now_add=True)
        updated_at = models.DateTimeField(auto_now=True)


    class Wishlist(AbstractModel):
        pass


    class Item(AbstractModel):
        pass


    class Part(AbstractModel):
        pass

En traduisant ceci en SQL, on aura en fait trois tables, chacune reprenant les champs `created_at` et `updated_at`, ainsi que son propre identifiant:

.. code-block:: sql

  --$ python manage.py sql wish
  BEGIN;
  CREATE TABLE "wish_wishlist" (
      "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
      "created_at" datetime NOT NULL,
      "updated_at" datetime NOT NULL
  )
  ;
  CREATE TABLE "wish_item" (
      "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
      "created_at" datetime NOT NULL,
      "updated_at" datetime NOT NULL
  )
  ;
  CREATE TABLE "wish_part" (
      "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
      "created_at" datetime NOT NULL,
      "updated_at" datetime NOT NULL
  )
  ;

  COMMIT;



Héritage classique
==================

L'héritage classique est généralement déconseillé, car il peut introduire très rapidement un problème de performances: en reprenant l'exemple introduit avec l'héritage par classe abstraite, et en omettant l'attribut `abstract = True`, on se retrouvera en fait avec quatre tables SQL:

 * Une table ``AbstractModel``, qui reprend les deux champs ``created_at`` et ``updated_at``
 * Une table ``Wishlist``
 * Une table ``Item``
 * Une table ``Part``.

.. code-block:: sql

    --$ python manage.py sql wish

    BEGIN;
    CREATE TABLE "wish_abstractmodel" (
       "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
       "created_at" datetime NOT NULL,
       "updated_at" datetime NOT NULL
    )
    ;
    CREATE TABLE "wish_wishlist" (
       "abstractmodel_ptr_id" integer NOT NULL PRIMARY KEY REFERENCES "wish_abstractmodel" ("id")
    )
    ;
    CREATE TABLE "wish_item" (
       "abstractmodel_ptr_id" integer NOT NULL PRIMARY KEY REFERENCES "wish_abstractmodel" ("id")
    )
    ;
    CREATE TABLE "wish_part" (
       "abstractmodel_ptr_id" integer NOT NULL PRIMARY KEY REFERENCES "wish_abstractmodel" ("id")
    )
    ;

    COMMIT;

Le problème est que les identifiants seront définis et incrémentés au niveau de la table mère. Pour obtenir les informations héritées, nous seront obligés de faire une jointure. En gros, impossible d'obtenir les données complètes pour l'une des classes de notre travail de base sans effectuer un *join* sur la classe mère.

Dans ce sens, cela va encore... Mais imaginez que vous définissiez une classe `Wishlist`, de laquelle héritent les classes `ChristmasWishlist` et `EasterWishlist`: pour obtenir la liste complètes des listes de souhaits, il vous faudra faire une jointure **externe** sur chacune des tables possibles, avant même d'avoir commencé à remplir vos données. Il est parfois nécessaire de passer par cette modélisation, mais en étant conscient des risques inhérents.

Classe proxy
============

Lorsqu'on définit une classe de type **proxy**, on fait en sorte que cette nouvelle classe ne définisse aucun nouveau champ sur la classe mère. Cela ne change dès lors rien à la traduction du modèle de données en SQL, puisque la classe mère sera traduite par une table, et la classe fille ira récupérer les mêmes informations dans la même table: elle ne fera qu'ajouter ou modifier un comportement dynamiquement, sans ajouter d'emplacements de stockage supplémentaires.

Nous pourrions ainsi définir les classes suivantes:

.. code-block:: python

    # wish/models.py

    class Wishlist(models.Model):
        name = models.CharField(max_length=255)
        description = models.CharField(max_length=2000)
        expiration_date = models.DateField()

        @staticmethod
        def create(self, name, description, expiration_date=None):
            wishlist = Wishlist()
            wishlist.name = name
            wishlist.description = description
            wishlist.expiration_date = expiration_date
            wishlist.save()
            return wishlist

    class ChristmasWishlist(Wishlist):
        class Meta:
            proxy = True

        @staticmethod
        def create(self, name, description):
            christmas = datetime(current_year, 12, 31)
            w = Wishlist.create(name, description, christmas)
            w.save()


    class EasterWishlist(Wishlist):
        class Meta:
            proxy = True

        @staticmethod
        def create(self, name, description):
            expiration_date = datetime(current_year, 4, 1)
            w = Wishlist.create(name, description, expiration_date)
            w.save()


