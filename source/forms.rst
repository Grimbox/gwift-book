===========
Formulaires
===========

Quand on parle de ``forms``, on ne parle pas uniquement de formulaires Web. On pourrait considérer qu'il s'agit de leur objectif principal, mais on peut également voir un peu plus loin: on peut en fait voir les ``forms`` comme le point d'entrée pour chaque donnée arrivant dans notre application: il s'agit en quelque sorte d'un ensemble de règles complémentaires à celles déjà présentes au niveau du modèle.

L'exemple le plus simple est un fichier ``.csv``: la lecture de ce fichier pourrait se faire de manière très simple, en récupérant les valeurs de chaque colonne et en l'introduisant dans une instance du modèle. Mauvaise idée. Les données fournies par un utilisateur **doivent** **toujours** être validées avant introduction dans la base de données. Notre base de données étant accessible ici par l'ORM, la solution consiste à introduire une couche supplémentaire de validation.

Le flux à suivre est le suivant:

 1. Création d'une instance grâce à un dictionnaire
 2. Validation des informations reçues
 3. Traitement, si la validation a réussi.

On définit un form comme une classe. Comme pour l'ORM, des attributs Meta peuvent être ajoutés, afin de récupérer automatiquement des

##########
Conclusion
##########

 1. Toute donnée entrée par l'utilisateur **doit** passer par une instance de ``form``.
 2. 
