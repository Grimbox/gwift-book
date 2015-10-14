Single App
==========

Pour commencer, nous allons nous concentrer sur la création d'un site ne contenant qu'une seule application, même si en pratique le site contiendra déjà plusieurs applications fournies pas django, comme nous le verrons plus loin.

Pour prendre un exemple concret, nous allons créer un site permettant de gérer des listes de souhaits, que nous appellerons `gwift` (pour `GiFTs and WIshlisTs` :)).

La première chose à faire est de définir nos besoins du point de vue de l'utilisateur, c'est-à-dire ce que nous souhaitons qu'un utilisateur puisse faire avec l'application.

Ensuite, nous pourrons traduire ces besoins en fonctionnalités et finalement effectuer le développement

Besoins utilisateur du site gwift
---------------------------------

Nous souhaitons développer un site où un utilisateur donné peut créer une liste contenant des souhaits et où d'autres utilisateurs, authentifiés ou non, peuvent choisir les souhaits qu'ils souhaitent réaliser.
Il sera nécessaire de s'authentifier pour : 

 1. Créer une liste associée à l'utilisateur en cours
 1. Ajouter un nouvel élément à une liste
 
Il ne sera pas nécessaire de s'authentifier pour :
 1. Faire une promesse d'offre pour un élément appartenant à une liste, associée à un utilisateur.

L'utilisateur ayant créé une liste pourra envoyer un email directement depuis le site aux personnes avec qui il souhaite partager sa liste, cet email contenant un lien permettant d'accéder à cette liste.

A chaque souhait, on pourrait de manière facultative ajouter un prix. Dans ce cas, le souhait pourrait aussi être subdivisé en plusieurs parts, de manière à ce que plusieurs personnes puissent participer à sa réalisation.

Un souhait pourrait aussi être réalisé plusieurs fois.

Besoins fonctionnels du site gwift
----------------------------------

### Gestion des utilisateurs

Pour gérer les utilisateurs, nous utiliserons ce que Django met par défaut à notre disposition.

### Gestion des listes

#### Modèlisation

Les données suivantes doivent être associées à une liste:
* un identifiant
* un identifiant externe
* un nom
* une description
* le propriétaire
* une date de création
* une date de modification

#### Fonctionnalités

 1. Un utilisateur authentifié doit pouvoir créer, modifier, désactiver et supprimer une liste dont il est le propriétaire
 1. Un utilisateur doit pouvoir associer ou retirer des souhaits à une liste dont il est le propriétaire
 1. Il faut pouvoir accéder à une liste, avec un utilisateur authentifier ou non, *via* son identifiant externe
 1. Il faut pouvoir envoyer un email avec le lien vers la liste, contenant son identifiant externe
 1. L'utilisateur doit pouvoir voir toutes les listes qui lui appartiennent

### Gestion des souhaits

#### Modélisation

Les données suivantes peuvent être associées à un souhait:
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

#### Fonctionnalités

 1. Un utilisateur authentifié doit pouvoir créer, modifier, désactiver et supprimer un souhait dont il est le propriétaire.
 1. On ne peut créer un souhait sans liste associée
 1. Il faut pouvoir fractionner un souhait uniquement si un prix est donné.
 1. Il faut pouvoir accéder à un souhait, avec un utilisateur authentifié ou non.
 1. Il faut pouvoir réaliser un souhait ou une partie seulement, avec un utilisateur authentifié ou non.
 1. Un souhait en cours de réalisation et composé de différente part ne peut plus être modifié.
 1. Un souhait en cours de réalisation ou réalisé ne peut plus être supprimé.
 1. On peut modifier le nombre de fois qu'un souhait doit être réalisé dans la limite des réalisations déjà effectuées.
 
### Gestion des réalisations de souhaits
 
#### Modélisation

Les données suivantes peuvent être associées à une réalisation de souhait:
* identifiant du souhait
* identifiant de l'utilisateur si connu
* identifiant de la personne si utilisateur non connu
* un commentaire
* une date de réalisation

#### Fonctionnalités

 1. L'utilisateur doit pouvoir voir si un souhait est réalisé, en partie ou non.
 1. L'utilisateur doit pouvoir voir la ou les personnes ayant réaliser un souhait.
 1. Il y a autant de réalisation que de parts de souhait réalisées ou de nombre de fois que le souhait est réalisé.
 
### Gestion des personnes réalisants les souhaits et qui ne sont pas connues
 
#### Modélisation

Les données suivantes peuvent être associées à une personne réalisant un souhait:
* un identifiant
* un nom
* une adresse email facultative

#### Fonctionnalités

