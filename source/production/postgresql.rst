 
**********
PostgreSQL
**********

On commence par installer PostgreSQL.

Par exemple, dans le cas de debian, on exécute la commande suivante:

.. code-block:: shell

    $$$ aptitude install postgresql postgresql-contrib
    
Ensuite, on crée un utilisateur pour la DB:

.. code-block:: shell

    $$$ su - postgres
    postgres@gwift:~$ createuser --interactive -P
    Enter name of role to add: gwift_user  
    Enter password for new role: 
    Enter it again: 
    Shall the new role be a superuser? (y/n) n
    Shall the new role be allowed to create databases? (y/n) n
    Shall the new role be allowed to create more new roles? (y/n) n
    postgres@gwift:~$
    
Finalement, on peut créer la DB:

.. code-block:: shell

    postgres@gwift:~$ createdb --owner gwift_user gwift
    postgres@gwift:~$ exit
    logout
    $$$
