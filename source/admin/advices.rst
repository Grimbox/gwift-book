**************
Administration
**************

L'administration de Django est l'une des fonctionnalités qui saute le plus au yeux lorsqu'on présente le framework à un nouveau-venu: sur base du modèle défini dans les différentes applications, Django peut générer automagiquement les formulaires d'entrée de données, les pages de listing, des fonctions de recherche, ... Tout ça avec très très peu de lignes de code.

L'un des problèmes par contre est que cette partie d'administration n'est pas destinée aux utilisateurs: c'est plus pour un *super-utilisateur* ou un gestionnaire que pour un utilisateur *lambda*.

Lors de la définition d'une nouvelle classe, et puisque l'ORM se base sur Active Records, il peut être intéressant de définir une valeur pour les options suivantes:

Une représentation textuelle
============================

Surcharger la fonction ``def __str__(self)`` sur la classe permettra de retourner une chaîne de caractère qui représentera l'instance de la classe. Cette information est utilisée un peu partout dans le code, et donnera une meilleure idée de ce qu'on manipule. 
En plus, c'est aussi ceci qui est appelé lorsque l'admin de Django historisera une action (et ceci sera inaltérable).

URL absolue
===========

La méthode `def get_absolute_url(self)` retourne l'URL à laquelle on peut envoyer une requête pour obtenir le maximum d'informations
concernant cette instance.

Par exemple:

.. code-block:: python

    def get_absolute_url(self):
        return reverse('myapp.views.details', args=[self.id])


Lorsqu'on en aura besoin, il suffira d'appeler cette méthode pour atterrir d'office sur la page de détails pour cette instance.

Meta
====

.. code-block:: python

    class Meta:
        ordering = ['-field1', 'field2']
        verbose_name = 'my class in singular'
        verbose_name_plural = 'my class when is in a list!'


Titre
=====

Le titre de l'administration peut être modifié de deux manières:

 * Soit en modifiant le template de l'administration
 * Soit en ajoutant l'assignation suivante dans le fichier `urls.py`: `admin.site.site_header = "SuperBook Secret Area`.

Greffons
========

L'interface d'administration est extensible dans une certaine mesure. Notamment utiliser ``django_extensions`` pour avoir les ForeignKey auto-complétées.
