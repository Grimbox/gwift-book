# Single App

Pour commencer, nous allons nous concentrer sur la création d'un site ne contenant qu'une seule application, même si en pratique le site contiendra déjà plusieurs applications fournies pas django, comme nous le verrons plus loin.

Pour prendre un exemple concret, nous allons créer un site permettant de gérer des listes de souhaits, que nous appellerons `gwift` (pour `GiFTs and WIshlisTs` :)).

La première chose à faire est de définir nos besoins du point de vue de l'utilisateur, c'est-à-dire ce que nous souhaitons qu'un utilisateur puisse faire avec l'application.

Ensuite, nous pourrons traduire ces besoins en fonctionnalités et finalement effectuer le développement

Besoins utilisateur du site gwift
---------------------------------

Nous souhaitons développer un site où un utilisateur donné peut créer une liste contenant des souhaits et où d'autres utilisateurs peuvent choisir les souhaits qu'il souhaite réaliser.
Il ne sera pas nécessaire de s'authentifier pour réaliser un souhait mais bien pour créer une liste.

L'utilisateur ayant créé une liste pourra envoyer un email directement depuis le site aux personnes avec qui il souhaite partager sa liste, ce dernier contenant la manière d'y accéder.

A chaque souhait, on pourrait de manière facultative ajouter un prix. Dans ce cas, le souhait pourrait aussi être subdivisé en plusieurs part, de manière à être offert par plusieurs autres personnes.

Un souhait pourrait aussi être réalisé plusieurs fois

Besoins fonctionnels du site gwift
----------------------------------

### Gestion des utilisateurs

Pour gérer les utilisateurs, nous utiliserons directement ce que django met à notre disposition

### Gestion des listes

#### Modèlisation

Les données suivantes doivent être associées à une liste:

* un identifiant
* un nom
* une description

#### Fonctionnalités

 1. Il faut pouvoir créer, modifier, désactiver et supprimer une liste, avec un utilisateur authentifié
 2. Il faut pouvoir y associer ou retirer des souhaits avec un utilisateur authentifié
 3. Il faut pouvoir accéder à une liste, avec un utilisateur authentifier ou non, via le uid.
 4. Il faut pouvoir envoyer un email avec le lien vers la liste, contenant l'uid.
 5. L'utilisateur doit pouvoir voir toutes les listes qui lui appartiennent

### Gestion des souhaits

#### Modélisation

Les données suivantes peuvent être associées à un souhait:
* un nom
* une description
* une image
* un prix facultatif
* un nombre (1 par défaut)
* un nombre de part facultatif, si un prix est fourni
* la liste à laquelle il appartient

#### Fonctionnalités

 1. Il faut pouvoir créer, modifier, désactiver et supprimer un souhait, avec un utilisateur authentifié
 2. On ne peut créer un souahit sans liste associée
 3. Il faut pouvoir fractionner un souhait uniquement si un prix est donné.
 4. Il faut pouvoir accéder à un souhait, avec un utilisateur authentifier ou non.
 5. Il faut pouvoir réaliser un souhait ou une partie seulement, avec un utilisateur authentifier ou non.
