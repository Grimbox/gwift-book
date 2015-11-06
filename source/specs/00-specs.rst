********************
Besoins utilisateurs
********************

Nous souhaitons développer un site où un utilisateur donné peut créer une liste contenant des souhaits et où d'autres utilisateurs, authentifiés ou non, peuvent choisir les souhaits qu'ils souhaitent réaliser.

Il sera nécessaire de s'authentifier pour : 

 * Créer une liste associée à l'utilisateur en cours
 * Ajouter un nouvel élément à une liste
 
Il ne sera pas nécessaire de s'authentifier pour :
 * Faire une promesse d'offre pour un élément appartenant à une liste, associée à un utilisateur.

L'utilisateur ayant créé une liste pourra envoyer un email directement depuis le site aux personnes avec qui il souhaite partager sa liste, cet email contenant un lien permettant d'accéder à cette liste.

A chaque souhait, on pourrait de manière facultative ajouter un prix. Dans ce cas, le souhait pourrait aussi être subdivisé en plusieurs parts, de manière à ce que plusieurs personnes puissent participer à sa réalisation.

Un souhait pourrait aussi être réalisé plusieurs fois.

********************
Besoins fonctionnels
********************

Gestion des utilisateurs
========================

Pour gérer les utilisateurs, nous utiliserons ce que Django met par défaut à notre disposition.

Gestion des listes
==================

Modèlisation
------------

Les données suivantes doivent être associées à une liste:

 * un identifiant
 * un identifiant externe
 * un nom
 * une description
 * le propriétaire
 * une date de création
 * une date de modification

Fonctionnalités
---------------

  * Un utilisateur authentifié doit pouvoir créer, modifier, désactiver et supprimer une liste dont il est le propriétaire
  * Un utilisateur doit pouvoir associer ou retirer des souhaits à une liste dont il est le propriétaire
  * Il faut pouvoir accéder à une liste, avec un utilisateur authentifier ou non, *via* son identifiant externe
  * Il faut pouvoir envoyer un email avec le lien vers la liste, contenant son identifiant externe
  * L'utilisateur doit pouvoir voir toutes les listes qui lui appartiennent

Gestion des souhaits
====================

Modélisation
------------

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

Fonctionnalités
---------------

 * Un utilisateur authentifié doit pouvoir créer, modifier, désactiver et supprimer un souhait dont il est le propriétaire.
 * On ne peut créer un souhait sans liste associée
 * Il faut pouvoir fractionner un souhait uniquement si un prix est donné.
 * Il faut pouvoir accéder à un souhait, avec un utilisateur authentifié ou non.
 * Il faut pouvoir réaliser un souhait ou une partie seulement, avec un utilisateur authentifié ou non.
 * Un souhait en cours de réalisation et composé de différente part ne peut plus être modifié.
 * Un souhait en cours de réalisation ou réalisé ne peut plus être supprimé.
 * On peut modifier le nombre de fois qu'un souhait doit être réalisé dans la limite des réalisations déjà effectuées.
 
Gestion des réalisations de souhaits
====================================
 
Modélisation
------------

Les données suivantes peuvent être associées à une réalisation de souhait:

 * identifiant du souhait
 * identifiant de l'utilisateur si connu
 * identifiant de la personne si utilisateur non connu
 * un commentaire
 * une date de réalisation

Fonctionnalités
---------------

 * L'utilisateur doit pouvoir voir si un souhait est réalisé, en partie ou non.
 * L'utilisateur doit pouvoir voir la ou les personnes ayant réaliser un souhait.
 * Il y a autant de réalisation que de parts de souhait réalisées ou de nombre de fois que le souhait est réalisé.
 
Gestion des personnes réalisants les souhaits et qui ne sont pas connues
========================================================================
 
Modélisation
------------

Les données suivantes peuvent être associées à une personne réalisant un souhait:

 * un identifiant
 * un nom
 * une adresse email facultative

Fonctionnalités
---------------

