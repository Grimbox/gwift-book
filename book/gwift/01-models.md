# Modélisation

Comme on l'a vu dans la description des fonctionnalités, on va *grosso modo* avoir besoin des éléments suivants:

 * Des listes de souhaits
 * Des éléments qui composent ces listes
 * Des parts pouvant composer chacun de ces éléments
 * Des utilisateurs pour gérer tout ceci.

Nous proposons dans un premier temps d'éluder la gestion des utilisateurs, et de simplement se concentrer sur les fonctionnalités principales.
Cela nous donne ceci: 

```python
# wish/models.py

from django.db import models


class Wishlist(models.Model):
    pass


class Item(models.Model):
    pass


class Part(models.Model):
    pass
```

Les classes sont créées, mais vides. Entrons dans les détails.

## Listes de souhaits

Comme déjà décrit précédemment, les listes de souhaits peuvent s'apparenter simplement à un objet ayant un nom et une description. Pour rappel, voici ce qui avait été défini dans les spécifications:

 * un identifiant
 * un identifiant externe
 * un nom
 * une description
 * une date de création
 * une date de modification

Notre classe `Wishlist` peut être étoffée de la manière suivante:

```python
# wish/models.py

class Wishlist(models.Model):
 
    name = models.CharField(max_length=255)
    description = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    external_id = models.UUIDField(unique=True, default=uuid.uuid4, editable=False)    
```

Que peut-on constater? 

 1. Que s'il n'est pas spécifié, un identifiant `id` sera automatiquement généré et accessible dans le modèle.
 1. Que chaque type de champs (`DateTimeField`, `CharField`, `UUIDField`, ...) a ses propres paramètres d'initialisation. Il est intéressant de les apprendre ou de se référer à la documentation en cas de doute:
    * La propriété `created_at` est gérée automatiquement par Django grâce à l'attribut `auto_now_add`: de cette manière, lors d'un **ajout**, une valeur par défaut ("*maintenant*") sera attribuée à cette propriété
    * La propriété `updated_at` est également gérée automatique, cette fois grâce à l'attribut `auto_now` initialisé à `True`: lors d'une **mise à jour**, la propriété se verra automatiquement assigner la valeur du moment présent. Cela ne permet évidemment pas de gérer un historique complet et ne nous dira pas **quels champs** ont été modifiés, mais cela nous conviendra dans un premier temps.
    * La propriété `external_id` est de type `UUIDField`. Lorsqu'une nouvelle instance sera instanciée, cette propriété prendra la valeur générée par la fonction `uuid.uuid4()`. *A priori*, chacun des types de champs possède une propriété `default`, qui permet d'initialiser une valeur sur une nouvelle instance.

A présent, notre classe 

## Elements

## Parties

## Refactoring

On constate que chaque classe possède les propriétés `created_at` et `updated_at`, initialisées aux mêmes valeurs. Pour gagner en cohérence, nous allons créer une classe dans laquelle nous définirons ces deux champs, et nous ferons en sorte que les classes `Wishlist`, `Item` et `Part` en héritent. Django gère trois sortes d'héritage: 

 1. L'héritage par classe abstraite
 1. L'héritage classique
 1. L'héritage par classe proxy.
 
### Classe abstraite

L'héritage par classe abstraite consiste à déterminer une classe mère qui ne sera jamais instanciée. C'est utile pour définir des champs qui se répèteront dans plusieurs autres classes et surtout pour respecter le principe de DRY. Comme la classe mère ne sera jamais instanciée, ces champs seront en fait dupliqués physiquement, et traduits en SQL, dans chacune des classes filles. 

```python
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
```

En traduisant ceci en SQL, on aura en fait trois tables, chacune reprenant les champs `created_at` et `updated_at`, ainsi que son propre identifiant.

### Héritage classique

L'héritage classique est généralement déconseillé, car il peut introduire très rapidement un problème de performances: en reprenant l'exemple introduit avec l'héritage par classe abstraite, et en omettant l'attribut `abstract = True`, on se retrouvera en fait avec quatre tables SQL:

 * Une table `AbstractModel`, qui reprend les deux champs `created_at` et `updated_at`
 * Une table `Wishlist`
 * Une table `Item`
 * Une table `Part`.

Le problème est que les identifiants seront définis et incrémentés au niveau de la table mère, et que pour obtenir les informations héritées, nous seront obligés de faire une jointure. En gros, impossible d'obtenir les données complètes pour l'une des classes de notre travail de base sans effectuer un *join* sur la classe mère. Dans ce sens, cela va encore... Mais imaginez que vous définissiez une classe `Wishlist`, de laquelle héritent les classes `ChristmasWishlist` et `EasterWishlist`: pour obtenir la liste complètes des listes de souhaits, il vous faudra faire une jointure externe sur chacune des tables possibles, avant même d'avoir commencé à remplir vos données. La [dénormalisation] entre rapidement en jeu pour garder des performances correctes. 

### Classe proxy

Lorsqu'on définit une classe de type **proxy**, on fait en sorte que cette nouvelle classe ne définisse aucun nouveau champ sur la classe mère. Cela ne change dès lors rien à la traduction du modèle de données en SQL, puisque la classe mère sera traduite par une table, et la classe fille ira récupérer les mêmes informations dans la même table: elle ne fera qu'ajouter ou modifier un comportement dynamiquement, sans ajouter d'emplacements de stockage supplémentaires.

Nous pourrions ainsi défiinr les classes suivantes:

```python
# wish/models.py

class Wishlist(models.Model):
    name = models.CharField(max_length=255)
    description = models.CharField(max_length=2000)
    expiration_date = models.DateField()

    @staticmethod
    def create(self, name, description):
        wishlist = Wishlist()
        wishlist.name = name
        wishlist.description = description
        wishlist.save()
        return wishlist

class ChristmasWishlist(Wishlist):

    @staticmethod
    def create(self, name, description):
        w = Wishlist.create(name, description)
        w.expiration_date = datetime(current_year, 12, 31)
        w.save()


class EasterWishlist(Wishlist):

    @staticmethod
    def create(self, name, description):
        w = Wishlist.create(name, description)
        w.expiration_date = datetime(current_year, 4, 1)
        w.save()

``` 

Cette représentation viole plusieurs principes suivis par Django et ne sert qu'à représenter une classe Proxy. Nous verrons plus loin qu'il sera plus facile de créer des formulaires dépendant de notre modèle `Wishlist` et dans lequel la date d'expiration sera fixée, plutôt que de créer de nouvelles classes modèles.

## Gestion des utilisateurs

Dans les spécifications, nous souhaitions pouvoir associer un utilisateur à une liste (*le propriétaire*) et un utilisateur à une part (*le donateur*). Par défaut, Django offre une gestion simplifiée des utilisateurs (pas de connexion LDAP, pas de double authentification, ...): juste un utilisateur et un mot de passe. Pour y accéder, un paramètre par défaut est défini dans votre fichier de settings: `AUTH_USER_MODEL`.

