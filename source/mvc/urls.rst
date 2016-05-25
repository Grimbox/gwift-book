****
URLs
****

La gestion des URLs permet *grosso modo* d'assigner une adresse paramétrée ou non à une fonction Python. La manière simple consiste à modifier le fichier `gwift/settings.py` pour y ajouter nos correspondances. Par défaut, le fichier ressemble à ceci:

.. code-block:: python

    # gwift/urls.py

    from django.conf.urls import include, url
    from django.contrib import admin

    urlpatterns = [
        url(r'^admin/', include(admin.site.urls)),
    ]

Le champ `urlpatterns` associe un ensemble d'adresses à des fonctions. Dans le fichier *nu*, seul le *pattern* `admin`_ est défini, et inclut toutes les adresses qui sont définies dans le fichier `admin.site.urls`. Reportez-vous à l'installation de l'environnement: ce fichier contient les informations suivantes:

.. _`admin`: Rappelez-vous de vos expressions régulières: `^` indique le début de la chaîne.

.. code-block:: python

    # admin.site.urls.py

Reverse
=======

En associant un nom ou un libellé à chaque URL, il est possible de récupérer sa *traduction*. Cela implique par contre de ne plus toucher à ce libellé par la suite...

Dans le fichier ``urls.py``, on associe le libellé ``wishlists`` à l'URL ``r'^$`` (c'est-à-dire la racine du site):  

.. code-block:: python

    from wish.views import WishListList

    urlpatterns = [
        url(r'^admin/', include(admin.site.urls)),
        url(r'^$', WishListList.as_view(), name='wishlists'),
    ]

De cette manière, dans nos templates, on peut à présent construire un lien vers la racine avec le tags suivant: 

.. code-block:: html

    <a href="{% url 'wishlists' %}">{{ yearvar }} Archive</a>

De la même manière, on peut également récupérer l'URL de destination pour n'importe quel libellé, de la manière suivante:

.. code-block:: python

    from django.core.urlresolvers import reverse_lazy
    
    wishlists_url = reverse_lazy('wishlists')