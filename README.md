# Django

[Django](https://www.djangoproject.com/) est l'un des frameworks Web proposant une très bonne intégration des composants, et une flexibilité bien pensée: chacun des composants permet de définir son contenu de manière poussée, en respectant des contraintes logiques et faciles à retenir.

En restant dans les sentiers battus, votre projet suivra le patron de conception `MVC` (Modèle-Vue-Controleur), avec une petite variante sur les termes utilisés: Django les nomme respectivement Modèle-Template-Vue:

 * Le modèle (`models.py`) fait le lien avec la base de données et permet de définir les champs et leur type à associer à une table. *Grosso modo*, une table SQL correspondra à une classe d'un modèle Django.
 * La vue (`views.py`), qui joue le rôle de contrôleur: *a priori*, tous les traitements, la récupération des données, etc. doit passer par ce composant et ne doit (pratiquement) pas être généré à la volée, directement à l'affichage d'une page.
 * Le template, qui s'occupe de la mise en forme: c'est le composant qui va s'occuper de transformer les données en un affichage compréhensible (avec l'aide du navigateur) pour l'utilisateur.

