# Modélisation

Comme on l'a vu dans la description des fonctionnalités, on va *grosso modo* avoir besoin des éléments suivants:

 * Des listes de souhaits
 * Des éléments qui composent ces listes
 * Des parts pouvant composer chacun de ces éléments
 * Des utilisateurs pour gérer tout ceci.

Nous proposons dans un premier temps d'éluder la gestion des utilisateurs, et de simplement se concentrer sur les fonctionnalités principales.

## Listes de souhaits

Comme déjà décrit précédemment, les listes de souhaits peuvent s'apparenter simplement à un objet ayant un nom et une description. Pour rappel, voici ce qui avait été défini dans les spécifications:

 * un identifiant
 * un identifiant externe
 * un nom
 * une description
 * le propriétaire
 * une date de création
 * une date de modification

Ouvrez le fichier `wish/models.py` pour y définir ces différents champs.
