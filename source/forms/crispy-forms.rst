************
Crispy Forms
************

Comme on l'a vu à l'instant, les forms, en Django, c'est le bien. Cela permet de valider des données reçues en entrée et d'afficher (très) facilement des formulaires à compléter par l'utilisateur.

Par contre, c'est lourd. Dès qu'on souhaite peaufiner un peu l'affichage, contrôler parfaitement ce que l'utilisateur doit remplir, modifier les types de contrôleurs, les placer au pixel près, ... Tout ça demande énormément de temps. Et c'est là qu'intervient `Django-Crispy-Forms <http://django-crispy-forms.readthedocs.io/en/latest/>`_. Cette librairie intègre plusieurs frameworks CSS (Bootstrap, Foundation et uni-form) et permet de contrôler entièrement le *layout* et la présentation. 

(c/c depuis le lien ci-dessous)

Pour chaque champ, crispy-forms va :

 * utiliser le ``verbose_name`` comme label.
 * vérifier les paramètres ``blank`` et ``null`` pour savoir si le champ est obligatoire.
 * utiliser le type de champ pour définir le type de la balise ``<input>``.
 * récupérer les valeurs du paramètre ``choices`` (si présent) pour la balise ``<select>``.


http://dotmobo.github.io/django-crispy-forms.html