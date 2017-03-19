===============
Tests unitaires
===============

*************
Méthodologies
*************

Pourquoi s'ennuyer à écrire des tests? 
======================================

Traduit grossièrement depuis un article sur `https://medium.com <https://medium.com/javascript-scene/what-every-unit-test-needs-f6cd34d9836d#.kfyvxyb21>`_:

    Vos tests sont la première et la meilleure ligne de défense contre les défauts de programmation. Ils sont 
    
    Les tests unitaires combinent de nombreuses fonctionnalités, qui en fait une arme secrète au service d'un développement réussi:
    
    1. Aide au design: écrire des tests avant d'écrire le code vous donnera une meilleure perspective sur le design à appliquer aux API.
    2. Documentation (pour les développeurs): chaque description d'un test 
    3. Tester votre compréhension en tant que développeur: 
    4. Assurance qualité: des tests, 
    5. 


Why Bother with Test Discipline?
================================

Your tests are your first and best line of defense against software defects. Your tests are more important than linting & static analysis (which can only find a subclass of errors, not problems with your actual program logic). Tests are as important as the implementation itself (all that matters is that the code meets the requirement — how it’s implemented doesn’t matter at all unless it’s implemented poorly).

Unit tests combine many features that make them your secret weapon to application success:

 1. Design aid: Writing tests first gives you a clearer perspective on the ideal API design.
 2. Feature documentation (for developers): Test descriptions enshrine in code every implemented feature requirement.
 3. Test your developer understanding: Does the developer understand the problem enough to articulate in code all critical component requirements?
 4. Quality Assurance: Manual QA is error prone. In my experience, it’s impossible for a developer to remember all features that need testing after making a change to refactor, add new features, or remove features.
 5. Continuous Delivery Aid: Automated QA affords the opportunity to automatically prevent broken builds from being deployed to production.

Unit tests don’t need to be twisted or manipulated to serve all of those broad-ranging goals. Rather, it is in the essential nature of a unit test to satisfy all of those needs. These benefits are all side-effects of a well-written test suite with good coverage.

“What are you testing?”
===========================================

 1. What component aspect are you testing?
 2. What should the feature do? What specific behavior requirement are you testing?


Couverture de code
==================

On a vu au chapitre 1 qu'il était possible d'obtenir une couverture de code, c'est-à-dire un pourcentage.

Comment tester ?
================

Il y a deux manières d'écrire les tests: soit avant, soit après l'implémentation. Oui, idéalement, les tests doivent être écrits à l'avance. Entre nous, on ne va pas râler si vous faites l'inverse, l'important étant que vous le fassiez. Une bonne métrique pour vérifier l'avancement des tests est la couverture de code.

Pour l'exemple, nous allons écrire la fonction ``percentage_of_completion`` sur la classe ``Wish``, et nous allons spécifier les résultats attendus avant même d'implémenter son contenu. Prenons le cas où nous écrivons la méthode avant son test:

.. code-block:: python

    class Wish(models.Model):

        [...]

        @property
        def percentage_of_completion(self):
            """
            Calcule le pourcentage de complétion pour un élément.
            """
            number_of_linked_parts = WishPart.objects.filter(wish=self).count()
            total = self.number_of_parts * self.numbers_available
            percentage = (number_of_linked_parts / total)
            return percentage * 100

Lancez maintenant la couverture de code. Vous obtiendrez ceci: 

.. code-block:: shell

    $ coverage run --source "." src/manage.py test wish
    $ coverage report
    
    Name                             Stmts   Miss Branch BrPart  Cover
    ------------------------------------------------------------------
    src\gwift\__init__.py                0      0      0      0   100%
    src\gwift\settings\__init__.py       4      0      0      0   100%
    src\gwift\settings\base.py          14      0      0      0   100%
    src\gwift\settings\dev.py            8      0      2      0   100%
    src\manage.py                        6      0      2      1    88%
    src\wish\__init__.py                 0      0      0      0   100%
    src\wish\admin.py                    1      0      0      0   100%
    src\wish\models.py                  36      5      0      0    88%
    ------------------------------------------------------------------
    TOTAL                               69      5      4      1    93%

Si vous générez le rapport HTML avec la commande ``coverage html`` et que vous ouvrez le fichier ``coverage_html_report/src_wish_models_py.html``, vous verrez que les méthodes en rouge ne sont pas testées. 
*A contrario*, la couverture de code atteignait **98%** avant l'ajout de cette nouvelle méthode. 

Pour cela, on va utiliser un fichier ``tests.py`` dans notre application ``wish``. *A priori*, ce fichier est créé automatiquement lorsque vous initialisez une nouvelle application.

.. code-block:: shell

    from django.test import TestCase

    class TestWishModel(TestCase):
        def test_percentage_of_completion(self):
            """
            Vérifie que le pourcentage de complétion d'un souhait 
            est correctement calculé. 
            
            Sur base d'un souhait, on crée quatre parts et on vérifie 
            que les valeurs s'étalent correctement sur 25%, 50%, 75% et 100%. 
            """
            wishlist = Wishlist(name='Fake WishList', 
                                description='This is a faked wishlist')
            wishlist.save()
                
            wish = Wish(wishlist=wishlist, 
                        name='Fake Wish', 
                        description='This is a faked wish',
                        number_of_parts=4)
            wish.save()
            
            part1 = WishPart(wish=wish, comment='part1')
            part1.save()
            self.assertEqual(25, wish.percentage_of_completion)
            
            part2 = WishPart(wish=wish, comment='part2')
            part2.save()
            self.assertEqual(50, wish.percentage_of_completion)
            
            part3 = WishPart(wish=wish, comment='part3')
            part3.save()
            self.assertEqual(75, wish.percentage_of_completion)
            
            part4 = WishPart(wish=wish, comment='part4')
            part4.save()
            self.assertEqual(100, wish.percentage_of_completion)

L'attribut ``@property`` sur la méthode ``percentage_of_completion()`` va nous permettre d'appeler directement la méthode ``percentage_of_completion()`` comme s'il s'agissait d'une propriété de la classe, au même titre que les champs ``number_of_parts`` ou ``numbers_available``. Attention que ce type de méthode contactera la base de données à chaque fois qu'elle sera appelée. Il convient de ne pas surcharger ces méthodes de connexions à la base: sur de petites applications, ce type de comportement a très peu d'impacts, mais ce n'est plus le cas sur de grosses applications ou sur des méthodes fréquemment appelées. Il convient alors de passer par un mécanisme de **cache**, que nous aborderons plus loin.

En relançant la couverture de code, on voit à présent que nous arrivons à 99%: 

.. code-block:: shell

    $ coverage run --source='.' src/manage.py test wish; coverage report; coverage html;
    .
    ----------------------------------------------------------------------
    Ran 1 test in 0.006s

    OK
    Creating test database for alias 'default'...
    Destroying test database for alias 'default'...
    Name                             Stmts   Miss Branch BrPart  Cover
    ------------------------------------------------------------------
    src\gwift\__init__.py                0      0      0      0   100%
    src\gwift\settings\__init__.py       4      0      0      0   100%
    src\gwift\settings\base.py          14      0      0      0   100%
    src\gwift\settings\dev.py            8      0      2      0   100%
    src\manage.py                        6      0      2      1    88%
    src\wish\__init__.py                 0      0      0      0   100%
    src\wish\admin.py                    1      0      0      0   100%
    src\wish\models.py                  34      0      0      0   100%
    src\wish\tests.py                   20      0      0      0   100%
    ------------------------------------------------------------------
    TOTAL                               87      0      4      1    99%

En continuant de cette manière (ie. Ecriture du code et des tests, vérification de la couverture de code), on se fixe un objectif idéal dès le début du projet. En prenant un développement en cours de route, fixez-vous comme objectif de ne jamais faire baisser la couverture de code.

*********************
Quelques liens utiles
*********************

 * `Django factory boy <https://github.com/rbarrois/django-factory_boy/tree/v1.0.0>`_

