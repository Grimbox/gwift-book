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

******************
Listes de souhaits
******************

Comme déjà décrit précédemment, les listes de souhaits peuvent s'apparenter simplement à un objet ayant un nom et une description. Pour rappel, voici ce qui avait été défini dans les spécifications:

 * un identifiant
 * un identifiant externe
 * un nom
 * une description
 * une date de création
 * une date de modification

Notre classe ``Wishlist`` peut être décrite de la manière suivante:

.. code-block:: python

    # wish/models.py

    class Wishlist(models.Model):

        name = models.CharField(max_length=255)
        description = models.TextField()
        created_at = models.DateTimeField(auto_now_add=True)
        updated_at = models.DateTimeField(auto_now=True)
        external_id = models.UUIDField(unique=True, default=uuid.uuid4,
                                        editable=False)

Que peut-on constater?

 * Que s'il n'est pas spécifié, un identifiant ``id`` sera automatiquement généré et accessible dans le modèle.
 * Que chaque type de champs (``DateTimeField``, ``CharField``, ``UUIDField``, ...) a ses propres paramètres d'initialisation. Il est intéressant de les apprendre ou de se référer à la documentation en cas de doute.

Au niveau de notre modélisation:

 * La propriété ``created_at`` est gérée automatiquement par Django grâce à l'attribut ``auto_now_add``: de cette manière, lors d'un **ajout**, une valeur par défaut ("*maintenant*") sera attribuée à cette propriété.
 * La propriété ``updated_at`` est également gérée automatique, cette fois grâce à l'attribut ``auto_now`` initialisé à ``True``: lors d'une **mise à jour**, la propriété se verra automatiquement assigner la valeur du moment présent. Cela ne permet évidemment pas de gérer un historique complet et ne nous dira pas **quels champs** ont été modifiés, mais cela nous conviendra dans un premier temps.
 * La propriété ``external_id`` est de type ``UUIDField``. Lorsqu'une nouvelle instance sera instanciée, cette propriété prendra la valeur générée par la fonction ``uuid.uuid4()``. *A priori*, chacun des types de champs possède une propriété ``default``, qui permet d'initialiser une valeur sur une nouvelle instance.

********
Souhaits
********

Nos souhaits ont besoin des propriétés suivantes:

 * un identifiant
 * identifiant de la liste
 * un nom
 * une description
 * le propriétaire
 * une date de création
 * une date de modification
 * une image
 * un nombre (1 par défaut)
 * un prix facultatif
 * un nombre de part facultatif, si un prix est fourni.

Après implémentation, cela ressemble à ceci:

.. code-block:: python

    # wish/models.py

    class Wish(models.Model):

        wishlist = models.ForeignKey(Wishlist)
        name = models.CharField(max_length=255)
        description = models.TextField()
        created_at = models.DateTimeField(auto_now_add=True)
        updated_at = models.DateTimeField(auto_now=True)
        picture = models.ImageField()
        numbers_available = models.IntegerField(default=1)
        number_of_parts = models.IntegerField(null=True)
        estimated_price = models.DecimalField(max_digits=19, decimal_places=2,
                                                null=True)

A nouveau, que peut-on constater ?

 * Les clés étrangères sont gérées directement dans la déclaration du modèle. Un champ de type `ForeignKey <https://docs.djangoproject.com/en/1.8/ref/models/fields/#django.db.models.ForeignKey>`_ permet de déclarer une relation 1-N entre deux classes. Dans la même veine, une relation 1-1 sera représentée par un champ de type `OneToOneField <https://docs.djangoproject.com/en/1.8/topics/db/examples/one_to_one/>`_, alors qu'une relation N-N utilisera un `ManyToManyField <https://docs.djangoproject.com/en/1.8/topics/db/examples/many_to_many/>`_.
 * L'attribut ``default`` permet de spécifier une valeur initiale, utilisée lors de la construction de l'instance. Cet attribut peut également être une fonction.
 * Pour rendre un champ optionnel, il suffit de lui ajouter l'attribut ``null=True``.
 * Comme cité ci-dessus, chaque champ possède des attributs spécifiques. Le champ ``DecimalField`` possède par exemple les attributs ``max_digits`` et ``decimal_places``, qui nous permettra de représenter une valeur comprise entre 0 et plus d'un milliard (avec deux chiffres décimaux).
 * L'ajout d'un champ de type ``ImageField`` nécessite l'installation de ``pillow`` pour la gestion des images. Nous l'ajoutons donc à nos pré-requis, dans le fichier ``requirements/base.txt``.

*******
Parts
*******


Les parts ont besoins des propriétés suivantes:

 * un identifiant
 * identifiant du souhait
 * identifiant de l'utilisateur si connu
 * identifiant de la personne si utilisateur non connu
 * un commentaire
 * une date de réalisation
 
Elles constituent la dernière étape de notre modélisation et représente la réalisation d'un souhait. Il y aura autant de part d'un souhait que le nombre de souhait à réaliser fois le nombre de part.

Elles permettent à un utilisateur de participer au souhait émis par un autre utilisateur. Pour les modéliser, un part est liée d'un côté à un souhait, et d'autre part à un utilisateur. Cela nous donne ceci:

.. code-block:: python

    from django.contrib.auth.models import User

    class WishPart(models.Model):

        wish = models.ForeignKey(Wish)
        user = models.ForeignKey(User)
	    unknown_user = models.ForeignKey(UnknownUser)
        comment = models.TextField()
        done_at = models.DateTimeField()

La classe ``User`` référencée au début du snippet correspond à l'utilisateur géré par Django. Cette instance est accessible à chaque requête transmise au serveur, et est accessible grâce à l'objet ``request.user``, transmis à chaque fonction ou *Class-based-view*. C'est un des avantages d'un framework tout intégré: il vient *batteries-included* et beaucoup de détails ne doivent pas être pris en compte. Pour le moment, nous nous limiterons à ceci. Par la suite, nous verrons comment améliorer la gestion des profils utilisateurs, comment y ajouter des informations et comment gérer les cas particuliers.

La classe ``UnknownUser`` permet de représenter un utilisateur non enregistré sur le site et est définie au point suivant.

Maintenant que la classe ``Part`` est définie, il nous est également possible de calculer le pourcentage d'avancement pour la réalisation d'un souhait. Pour cela, il nous suffit d'ajouter une nouvelle méthode au niveau de la classe ``Wish``, qui va calculer le nombre de parts déjà promises, et nous donnera l'avancement par rapport au nombre total de parts disponibles:

.. code-block:: python

    class Wish(models.Model):

        [...]

        @property
        def percentage(self):
            """
            Calcule le pourcentage de complétion pour un élément.
            """
            number_of_linked_parts = Part.objects.filter(wish=self).count()
            total = self.number_of_parts * self.numbers_available
            percentage = (number_of_linked_parts / total)
            return percentage * 100

L'attribut ``@property`` va nous permettre d'appeler directement la méthode ``percentage()`` comme s'il s'agissait d'une propriété de la classe, au même titre que les champs ``number_of_parts`` ou ``numbers_available``. Attention que ce type de méthode fera un appel à la base de données à chaque appel. Il convient de ne pas surcharger ces méthodes de connexions à la base: sur de petites applications, ce type de comportement a très peu d'impacts. Ce n'est plus le cas sur de grosses applications ou sur des méthodes fréquemment appelées. Il convient alors de passer par un mécanisme de **cache**, que nous aborderons plus loin.

*********************
Utilisateurs inconnus
*********************

Pour chaque réalisation d'un souhait par quelqu'un, il est nécessaire de sauver les données suivantes, même si l'utilisateur n'est pas enregistré sur le site:

 * un identifiant
 * un nom
 * une adresse email

Ce qui donne après implémentation:

.. code-block:: python

    class UnkownUser(models.Model):
	
        name = models.CharField(max_length=255)
        email = models.CharField(max_length=255)

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

************************
Gestion des utilisateurs
************************

Dans les spécifications, nous souhaitions pouvoir associer un utilisateur à une liste (*le propriétaire*) et un utilisateur à une part (*le donateur*). Par défaut, Django offre une gestion simplifiée des utilisateurs (pas de connexion LDAP, pas de double authentification, ...): juste un utilisateur et un mot de passe. Pour y accéder, un paramètre par défaut est défini dans votre fichier de settings: ``AUTH_USER_MODEL``.
