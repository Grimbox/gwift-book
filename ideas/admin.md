# Administration

Un schéma relationnel demande à l'utilisateur de définir un ensemble de tables, permettant de représenter et stocker de l'information de manière pérenne. Plus précisément, chacune de ces tables devra 


L'ORM de Django permet de définir travailler uniquement avec une définition de classes, et de faire en sorte que le lien avec la base de données soit géré uniquement de manière indirecte, par Django lui-même. On peut schématiser ce comportement par  une classe = une table 

Lors de la définition d'une nouvelle classe, et puisque l'ORM se base sur Active Records, il peut être intéressant de définir une valeur pour les options suivantes:

 * `def __str__(self)`: retournera une chaîne de caractère pour toute instance de la classe
 * `def get_absolute_url(self)` : retourne l'URI à laquelle on peut envoyer une requête pour obtenir le maximum d'informations concernant cette instance. Par exemple: `return reverse('myapp.views.details', args=[self.id])`. Lorsqu'on en aura besoin, il suffira d'appeler cette méthode pour atterrir d'office sur la bonne page
   * class Meta:
    * ordering = ['-field1', 'field2']
    * verbose_name = 'my class in singular'
    * verbose_name_plural = 'my class when is in a list!'

Titre
-----

Le titre de l'administration peut être modifié de deux manières: 

 1. Soit en modifiant le template de l'administration
 2. Soit en ajoutant l'assignation suivante dans le fichier `urls.py`: `admin.site.site_header = "SuperBook Secret Area`.

Greffons
--------

L'interface d'administration est extensible dans une certaine mesure. Notamment utiliser django_extensions pour avoir les ForeignKey auto-complétées. 

# Autre

# Administration

L'administration de Django est l'une des fonctionnalités qui saute le plus au yeux lorsqu'on présente le framework à un nouveau-venu: sur base du modèle défini dans les différentes applications, Django peut générer automagiquement les formulaires d'entrée de données, les pages de listing, des fonctions de recherche, ... Tout ça avec très très peu de lignes de code.

L'un des problèmes par contre est que cette partie d'administration n'est pas destinée aux utilisateurs: c'est plus pour un *super-utilisateur* ou un gestionnaire que pour un utilisateur *lambda*.