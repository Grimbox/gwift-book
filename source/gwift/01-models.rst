************
Modélisation
************

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

Notre classe ``Wishlist`` peut être définie de la manière suivante:

.. code-block:: python

    # wish/models.py

    class Wishlist(models.Model):

        name = models.CharField(max_length=255)
        description = models.TextField()
        created_at = models.DateTimeField(auto_now_add=True)
        updated_at = models.DateTimeField(auto_now=True)
        external_id = models.UUIDField(unique=True, default=uuid.uuid4, editable=False)

Que peut-on constater?

 * Que s'il n'est pas spécifié, un identifiant ``id`` sera automatiquement généré et accessible dans le modèle. Si vous souhaitez malgré tout spécifier que ce soit un champ en particulier qui devienne la clé primaire, il suffit de l'indiquer grâce à l'attribut ``primary_key=True``.
 * Que chaque type de champs (``DateTimeField``, ``CharField``, ``UUIDField``, etc.) a ses propres paramètres d'initialisation. Il est intéressant de les apprendre ou de se référer à la documentation en cas de doute.

Au niveau de notre modélisation:

 * La propriété ``created_at`` est gérée automatiquement par Django grâce à l'attribut ``auto_now_add``: de cette manière, lors d'un **ajout**, une valeur par défaut ("*maintenant*") sera attribuée à cette propriété.
 * La propriété ``updated_at`` est également gérée automatique, cette fois grâce à l'attribut ``auto_now`` initialisé à ``True``: lors d'une **mise à jour**, la propriété se verra automatiquement assigner la valeur du moment présent. Cela ne permet évidemment pas de gérer un historique complet et ne nous dira pas **quels champs** ont été modifiés, mais cela nous conviendra dans un premier temps.
 * La propriété ``external_id`` est de type ``UUIDField``. Lorsqu'une nouvelle instance sera instanciée, cette propriété prendra la valeur générée par la fonction ``uuid.uuid4()``. *A priori*, chacun des types de champs possède une propriété ``default``, qui permet d'initialiser une valeur sur une nouvelle instance.

********
Souhaits
********

Nos souhaits ont besoin des propriétés suivantes:

 * un identifiant
 * l'identifiant de la liste auquel le souhait est lié
 * un nom
 * une description
 * le propriétaire
 * une date de création
 * une date de modification
 * une image permettant de le représenter.
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

*****
Parts
*****


Les parts ont besoins des propriétés suivantes:

 * un identifiant
 * identifiant du souhait
 * identifiant de l'utilisateur si connu
 * identifiant de la personne si utilisateur non connu
 * un commentaire
 * une date de réalisation
 
Elles constituent la dernière étape de notre modélisation et représente la réalisation d'un souhait. Il y aura autant de part d'un souhait que le nombre de souhait à réaliser fois le nombre de part.

Elles permettent à un utilisateur de participer au souhait émis par un autre utilisateur. Pour les modéliser, une part est liée d'un côté à un souhait, et d'autre part à un utilisateur. Cela nous donne ceci:

.. code-block:: python

    from django.contrib.auth.models import User

    class WishPart(models.Model):

        wish = models.ForeignKey(Wish)
        user = models.ForeignKey(User, null=True)
        unknown_user = models.ForeignKey(UnknownUser, null=True)
        comment = models.TextField(null=True, blank=True)
        done_at = models.DateTimeField(auto_now_add=True)

La classe ``User`` référencée au début du snippet correspond à l'utilisateur qui sera connecté. Ceci est géré par Django. Lorsqu'une requête est effectuée et est transmise au serveur, cette information sera disponible grâce à l'objet ``request.user``, transmis à chaque fonction ou *Class-based-view*. C'est un des avantages d'un framework tout intégré: il vient *batteries-included* et beaucoup de détails ne doivent pas être pris en compte. Pour le moment, nous nous limiterons à ceci. Par la suite, nous verrons comment améliorer la gestion des profils utilisateurs, comment y ajouter des informations et comment gérer les cas particuliers.

La classe ``UnknownUser`` permet de représenter un utilisateur non enregistré sur le site et est définie au point suivant.


*********************
Utilisateurs inconnus
*********************

.. todo:: je supprimerais pour que tous les utilisateurs soient gérés au même endroit.

Pour chaque réalisation d'un souhait par quelqu'un, il est nécessaire de sauver les données suivantes, même si l'utilisateur n'est pas enregistré sur le site:

 * un identifiant
 * un nom
 * une adresse email. Cette adresse email sera unique dans notre base de données, pour ne pas créer une nouvelle occurence si un même utilisateur participe à la réalisation de plusieurs souhaits.

Ceci nous donne après implémentation:

.. code-block:: python

    class UnkownUser(models.Model):
	
        name = models.CharField(max_length=255)
        email = models.CharField(email = models.CharField(max_length=255, unique=True)


