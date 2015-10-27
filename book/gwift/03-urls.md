URLs
====

La gestion des URLs permet *grosso modo* d'assigner une adresse paramétrée ou non à une fonction Python. La manière simple consiste à modifier le fichier `gwift/settings.py` pour y ajouter nos correspondances. Par défaut, le fichier ressemble à ceci: 

```python
# gwift/urls.py

from django.conf.urls import include, url
from django.contrib import admin

urlpatterns = [
    url(r'^admin/', include(admin.site.urls)),
]
```

Le champ `urlpatterns` associe un ensemble d'adresses à des fonctions. Dans le fichier *nu*, seul le *pattern* `^admin/` [^1] est défini, et inclut toutes les adresses qui sont définies dans le fichier `admin.site.urls`. Reportez-vous à l'installation de l'environnement: ce fichier contient les informations suivantes:

[^1] Rappelez-vous de vos expressions régulières: `^` indique le début de la chaîne.

```python
# admin.site.urls.py

```

## Reverse


