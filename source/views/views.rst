****
Vues
****

Une vue correspond à un contrôleur dans le pattern MVC. Tout ce que vous pourrez définir au niveau du fichier ``views.py`` fera le lien entre le modèle stocké dans la base de données et ce avec quoi l'utilisateur pourra réellement interagir (le ``template``).

Chaque vue peut etre représentée de deux manières: soit par des fonctions, soit par des classes. Le comportement leur est propre, mais le résultat reste identique. Le lien entre l'URL à laquelle l'utilisateur accède et son exécution est faite au travers du fichier ``gwift/urls.py``, comme on le verra par la suite.

Function Based Views
====================

Les fonctions (ou ``FBV`` pour *Function Based Views*) permettent une implémentation classique des contrôleurs. Au fur et à mesure de votre implémentation, on se rendra compte qu'il y a beaucoup de répétitions dans ce type d'implémentation: elles ne sont pas obsolètes, mais dans certains cas, il sera préférable de passer par les classes.

Pour définir la liste des ``WishLists``  actuellement disponibles, on précédera de la manière suivante:

 1. Définition d'une fonction qui va récupérer les objets de type ``WishList`` dans notre base de données. La valeur de retour sera la construction d'un dictionnaire (le *contexte*) qui sera passé à un template HTML. On démandera à ce template d'effectuer le rendu au travers de la fonction ``render``, qui est importée par défaut dans le fichier ``views.py``.
 2. Construction d'une URL qui permettra de lier l'adresse à l'exécution de la fonction.
 3. Définition du squelette.

Définition de la fonction
-------------------------

.. code-block:: python

		# wish/views.py

		from django.shortcuts import render
		from .models import Wishlist

		def wishlists(request):
		    w = Wishlist.objects.all()
		    return render(request, 'wish/list.html',{ 'wishlists': w })

Construction de l'URL
---------------------

.. code-block:: python

		# gwift/urls.py

		from django.conf.urls import include, url
		from django.contrib import admin

		from wish import views as wish_views

		urlpatterns = [
		    url(r'^admin/', include(admin.site.urls)),
		    url(r'^$', wish_views.wishlists, name='wishlists'),
		]

Définition du squelette
-----------------------

A ce stade, vérifiez que la variable ``TEMPLATES`` est correctement initialisée dans le fichier ``gwift/settings.py`` et que le fichier ``templates/wish/list.html`` ressemble à ceci:

.. code-block:: html

		<!doctype html>
		<html>
		    <head>
		        <meta charset="utf-8">
		        <meta http-equiv="x-ua-compatible" content="ie=edge">
		        <title></title>
		    </head>
		    <body>
		        <p>Mes listes de souhaits</p>
		        <ul>
		        {% for wishlist in wishlists %}
		          <li>{{ wishlist.name }}: {{ wishlist.description }}</li>
		        {% endfor %}
		        </ul>
		    </body>
		</html>

Exécution
---------

A présent, ajoutez quelques listes de souhaits grâce à un *shell*, puis lancez le serveur:

.. code-block:: shell

		$ python manage.py shell
		>>> from wish.models import Wishlist
		>>> Wishlist.create('Décembre', "Ma liste pour les fêtes de fin d'année")
		<Wishlist: Wishlist object>
		>>> Wishlist.create('Anniv 30 ans', "Je suis vieux! Faites des dons!")
		<Wishlist: Wishlist object>

Lancez le serveur grâce à la commande ``python manage.py runserver``, ouvrez un navigateur quelconque et rendez-vous à l'adresse `http://localhost:8000 <http://localhost:8000>`_. Vous devriez obtenir le résultat suivant:

.. image:: views/my-first-wishlists.png
	 :align: center

Rien de très sexy, aucune interaction avec l'utilisateur, très peu d'utilisation des variables contextuelles, mais c'est un bon début! =)

Class Based Views
=================

Les classes, de leur côté, implémente le *pattern* objet et permettent d'arriver facilement à un résultat en très peu de temps, parfois même en définissant simplement quelques attributs, et rien d'autre. Pour l'exemple, je vais définir deux classes qui donnent exactement le même résultat que la fonction ``wishlists`` ci-dessus. Une première fois en utilisant une classe générique vierge, et ensuite en utilisant une classe de type ``ListView``.

Classe générique
----------------

blah

ListView
--------

Les classes génériques implémentent un aspect bien particulier de la représentation d'un modèle, en utilisant très peu d'attributs. Les principales classes génériques sont de type ``ListView``, [...]. L'implémentation consiste, exactement comme pour les fonctions, à:

 1. Définir la classe
 2. Créer l'URL
 3. Définir le squelette.

.. code-block:: python

		# wish/views.py

		from django.views.generic import ListView

		from .models import Wishlist

		class WishListList(ListView):
		    context_object_name = 'wishlists'
		    model = Wishlist
		    template_name = 'wish/list.html'


.. code-block:: python

		# gwift/urls.py

		from django.conf.urls import include, url
		from django.contrib import admin

		from wish.views import WishListList

		urlpatterns = [
		    url(r'^admin/', include(admin.site.urls)),
		    url(r'^$', WishListList.as_view(), name='wishlists'),
		]

C'est tout. Lancez le serveur, le résultat sera identique. Par inférence, Django construit beaucoup d'informations: si on n'avait pas spécifié les variables ``context_object_name`` et ``template_name``, celles-ci auraient pris les valeurs suivantes:

 * ``context_object_name``: ``wishlist_list`` (ou plus précisément, le nom du modèle suivi de ``_list``)
 * ``template_name``: ``wish/wishlist_list.html`` (à nouveau, le fichier généré est préfixé du nom du modèle).
