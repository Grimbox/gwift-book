************************
Gestion des utilisateurs
************************

Dans les spécifications, nous souhaitions pouvoir associer un utilisateur à une liste (*le propriétaire*) et un utilisateur à une part (*le donateur*). Par défaut, Django offre une gestion simplifiée des utilisateurs (pas de connexion LDAP, pas de double authentification, ...): juste un utilisateur et un mot de passe. Pour y accéder, un paramètre par défaut est défini dans votre fichier de settings: ``AUTH_USER_MODEL``.

