****************
Authentification
****************

Comme on l'a vu dans la partie sur le modèle, nous souhaitons que le créateur d'une liste puisse retrouver facilement les éléments qu'il aura créé. Ce dont nous n'avons pas parlé cependant, c'est la manière dont l'utilisateur va pouvoir créer son compte et s'authentifier. La `document <https://docs.djangoproject.com/en/stable/topics/auth/>`_ est très complète, nous allons essayer de la simplifier au maximum. Accrochez-vous, le sujet peut être complexe.

On peut résumer le mécanisme d'authentification de la manière suivante:

 * Si vous voulez modifier les informations liées à un utilisateur, orientez-vous vers la modification du modèle. Comme nous le verrons ci-dessous, il existe trois manières de prendre ces modifications en compte.
 * Si vous souhaitez modifier la manière dont l'utilisateur se connecte, alors vous devrez modifier le *backend*.
 
Modification du modèle
======================

Dans un premier temps, Django a besoin de manipuler `des instances de type <https://docs.djangoproject.com/en/1.9/ref/contrib/auth/#user-model>`_ ``django.contrib.auth.User``. Cette classe implémente les champs suivants:

 * ``username``
 * ``first_name``
 * ``last_name``
 * ``email``
 * ``password``
 * ``date_joined``.
 
D'autres champs, comme les groupes auxquels l'utilisateur est associé, ses permissions, savoir s'il est un super-utilisateur, ... sont moins pertinents pour le moment. Avec les quelques champs déjà définis ci-dessus, nous avons de quoi identifier correctement nos utilisateurs. Inutile d'implémenter nos propres classes, puisqu'elles existent déjà :-) 

Si vous souhaitez ajouter un champ, il existe trois manières de faire. 

Extension du modèle existant
----------------------------

Le plus simple consiste à créer une nouvelle classe, et à faire un lien de type ``OneToOne`` vers la classe ``django.contrib.auth.User``. De cette manière, on ne modifie rien à la manière dont Django authentife ses utlisateurs: tout ce qu'on fait, c'est un lien vers une table nouvellement créée, comme on l'a déjà vu au point [...voir l'héritage de modèle]. L'avantage de cette méthode, c'est qu'elle est extrêmement flexible, et qu'on garde les mécanismes Django standard. Le désavantage, c'est que pour avoir toutes les informations de notre utilisateur, on sera obligé d'effectuer une jointure sur le base de données, ce qui pourrait avoir des conséquences sur les performances.

Substitution
------------

Avant de commencer, sachez que cette étape doit être effectuée **avant la première migration**. Le plus simple sera de définir une nouvelle classe héritant de ``django.contrib.auth.User`` et de spécifier la classe à utiliser dans votre fichier de paramètres. Si ce paramètre est modifié après que la première migration ait été effectuée, il ne sera pas pris en compte. Tenez-en compte au moment de modéliser votre application.

.. code-block:: python

    AUTH_USER_MODEL = 'myapp.MyUser'

Notez bien qu'**il ne faut pas** spécifier le package ``.models`` dans cette injection de dépendances.  

Ce qui n'existe pas par contre, ce sont les vues. Django propose donc tout le mécanisme de gestion des utilisateurs, excepté le visuel (hors administration). 