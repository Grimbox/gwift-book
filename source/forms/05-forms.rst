*****
Forms
*****

Les forms ne s'appliquent pas uniquement pour les rendus de formulaires dans votre page web, mais pour toute information qui doit être entrée dans la base de données. Ils jouent en fait plusieurs rôles: validation des données (en plus de celles déjà définies au niveau du modèle), contrôle de la manière dans les champs doivent être visualisables, ... et agissent comme une colle entre l'utilisateur et la modélisation de vos tables et structures de données.

Dépendance avec le modèle
=========================

Un **form** peut dépendre d'une autre classe Django. Pour cela, il suffit de fixer l'attribut `model` au niveau de la `class Meta` dans la définition.

.. code-block:: python

    from django import forms

    from wish.models import Wishlist

    class WishlistCreateForm(forms.ModelForm):
        class Meta:
            model = Wishlist
            fields = ('name', 'description')


De cette manière, notre form dépendra automatiquement des champs déjà déclarés dans la classe ``Wishlist``. Cela suit le principe de `DRY <don't repeat yourself>`_, et évite qu'une modification ne pourrisse le code: en testant les deux champs présent dans l'attribut ``fields``, nous pourrons nous assurer de faire évoluer le formulaire en fonction du modèle sur lequel il se base.

Contrôle du rendu
=================

Le formulaire permet également de contrôler le rendu qui sera appliqué lors de la génération de la page. Si les champs dépendent du modèle sur lequel se base le formulaire, ces widgets doivent être initialisés dans l'attribut ``Meta``. Sinon, ils peuvent l'être directement au niveau du champ.

.. code-block:: python

    from django import forms
    from datetime import date
    from .models import Accident

    class AccidentForm(forms.ModelForm):
        class Meta:
            model = Accident
            fields = ('gymnast', 'educative', 'date', 'information')
            widgets = {
                'date' : forms.TextInput(
                         attrs={
                            'class' : 'form-control',
                            'data-provide' : 'datepicker',
                            'data-date-format' : 'dd/mm/yyyy',
                            'placeholder' : date.today().strftime("%d/%m/%Y")
                         }),
                'information' : forms.Textarea(
                                attrs={
                                    'class' : 'form-control',
                                    'placeholder' : 'Context (why, where, ...)'
                                })
