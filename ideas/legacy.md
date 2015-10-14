Quand on intègre une nouvelle application Django dans un environement existant, la première étape est de se câbler sur la base de données existantes; 

 1. Soit l'application sur laquelle on se greffe restera telle quelle; 
  2. Soit l'application est **remplacée** par la nouvelle application Django.

  Dans le premier cas, il convient de créer une application et de spécifier pour chaque classe l'attribute `managed = False` dans le `class Meta:` de la définition.
  Dans le second, il va falloir câbler deux-trois éléments avant d'avoir une intégration complète (comprendre: avec une interface d'admin, les migrations, les tests unitaires et tout le brol :))

  `python manage.py inspectdb > models.py`
