.. -*- coding: utf-8 -*-
.. Copyright |copy| 2012, 2019 by `Olivier Bonaventure <http://inl.info.ucl.ac.be/obo>`_, Christoph Paasch et Grégory Detal
.. Ce fichier est distribué sous une licence `creative commons <http://creativecommons.org/licenses/by-sa/3.0/>`_

   
.. _declarations:
 
Déclarations
=============

Durant les chapitres précédents, nous avons principalement utilisé des variables locales. Celles-ci sont déclarées à l'intérieur des fonctions où elles sont utilisées. La façon dont les variables sont déclarées est importante dans un programme écrit en langage C. Dans cette section nous nous concentrerons sur des programmes C qui sont écrits sous la forme d'un seul fichier source. Nous verrons plus tard comment découper un programme en plusieurs modules qui sont répartis dans des fichiers différents et comment les variables peuvent y être déclarées.

La première notion importante concernant la déclaration des variables est leur :term:`portée`. La portée d'une variable peut être définie comme étant la partie du programme où la variable est accessible et où sa valeur peut être modifiée. Le langage C définit deux types de portée à l'intérieur d'un fichier C. La première est la :term:`portée globale`. Une variable qui est définie en dehors de toute définition de fonction a une portée globale. Une telle variable est accessible dans toutes les fonctions présentes dans le fichier. La variable ``g`` dans l'exemple ci-dessous a une portée globale.

.. code-block:: c

   float g;   // variable globale

   int f(int i) {
   int n;   // variable locale
   // ...
   for(int j=0;j<n;j++) {  // variable locale
     // ...
     }
   //...
   for(int j=0;j<n;j++) {  // variable locale
     // ...
     }
   }


Dans un fichier donné, il ne peut évidemment pas y avoir deux variables globales qui ont le même identifiant. Lorsqu'une variable est définie dans un `bloc`, la portée de cette variable est locale à ce bloc. On parle dans ce cas de :term:`portée locale`. La variable locale n'existe pas avant le début du bloc et n'existe plus à la fin du bloc. Contrairement aux identifiants de variables globales qui doivent être uniques à l'intérieur d'un fichier, il est possible d'avoir plusieurs variables locales qui ont le même identifiant à l'intérieur d'un fichier. C'est fréquent notamment pour les définitions d'arguments de fonction et les variables de boucles. Dans l'exemple ci-dessus, les variables ``n`` et ``j`` ont une portée locale. La variable ``j`` est définie dans deux blocs différents à l'intérieur de la fonction ``f``.


Le programme :download:`/C/S3-src/portee.c` illustre la façon dont le compilateur C gère la portée de différentes variables.

.. literalinclude:: /C/S3-src/portee.c
   :encoding: utf-8
   :language: c
   :start-after: ///AAA
   :end-before: ///BBB

Ce programme contient deux variables qui ont une portée globale : ``g1`` et ``g2``. Ces deux variables sont définies en dehors de tout bloc. En pratique, elles sont généralement déclarées au début du fichier, même si le compilateur C accepte un définition en dehors de tout bloc et donc par exemple en fin de fichier. La variable globale ``g1`` n'est définie qu'une seule fois. Par contre, la variable ``g2`` est définie avec une portée globale et est redéfinie à l'intérieur de la fonction ``f`` ainsi que dans la boucle ``for`` de la fonction ``main``. Redéfinir une variable globale de cette façon n'est pas du tout une bonne pratique, mais cela peut arriver lorsque par mégarde on importe un fichier header qui contient une définition de variable globale. Dans ce cas, le compilateur C utilise la variable qui est définie dans le bloc le plus proche. Pour la variable ``g2``, c'est donc la variable locale ``g2`` qui est utilisée à l'intérieur de la boucle ``for`` ou de la fonction ``f``.

Lorsqu'un identifiant de variable locale est utilisé à plusieurs endroits dans un fichier, c'est la définition la plus proche qui est utilisée. L'exécution du programme ci-dessus illustre cette utilisation des variables globales et locales.

.. literalinclude:: /C/S3-src/portee.out
   :encoding: utf-8
   :language: console

.. note:: Utilisation des variables

 En pratique, les variables globales doivent être utilisées de façon parcimonieuse et il faut limiter leur utilisation aux données qui doivent être partagées par plusieurs fonctions à l'intérieur d'un programme. Lorsqu'une variable globale a été définie, il est préférable de ne pas réutiliser son identifiant pour une variable locale. Au niveau des variables locales, les premières versions du langage C imposaient leur définition au début des blocs. Les standards récents [C99]_ autorisent la déclaration de variables juste avant leur première utilisation un peu comme en Java.

Les versions récentes de C [C99]_ permettent également de définir des variables dont la valeur sera constante durant toute l'exécution du programme. Ces déclarations de ces constants sont préfixées par le mot-clé ``const`` qui joue le même rôle que le mot clé ``final`` en Java.

.. literalinclude:: /C/S3-src/const.c
   :encoding: utf-8
   :language: c
   :start-after: ///AAA
   :end-before: ///BBB


Il y a deux façons de définir des constantes dans les versions récentes de C [C99]_. La première est via la macro ``#define`` du préprocesseur. Cette macro permet de remplacer une chaîne de caractères (par exemple ``M_PI`` qui provient de `math.h`_) par un nombre ou une autre chaîne de caractères. Ce remplacement s'effectue avant la compilation. Dans le cas de ``M_PI`` ci-dessus, le préprocesseur remplace toute les occurrences de cette chaîne de caractères par la valeur numérique de :math:`\pi`. Lorsqu'une variable ``const`` est utilisée, la situation est un peu différente. Le préprocesseur n'intervient pas. Par contre, le compilateur réserve une zone mémoire pour la variable qui a été définie comme constante. Cela a deux avantages par rapport à l'utilisation de ``#define``. Premièrement, il est possible de définir comme constante n'importe quel type de données en C, y compris des structures ou des pointeurs alors qu'avec un ``#define`` on ne peut définir que des nombres ou des chaînes de caractères. Ensuite, comme une ``const`` est stockée en mémoire, il est possible d'obtenir son adresse et de l'examiner via un :term:`debugger`.

.. _unions:

Unions et énumérations
======================

Les structures que nous avons présentées précédemment permettent de combiner plusieurs données de types primitifs différents entre elles. Outre ces structures (``struct``), le langage C supporte également les ``enum`` et les ``union``. Le mot-clé ``enum`` est utilisé pour définir un type énuméré, c'est-à-dire un type de donnée qui permet de stocker un nombre fixe de valeurs. Quelques exemples classiques sont repris dans le fragment de programme ci-dessous :

.. literalinclude:: /C/S3-src/enum.c
   :encoding: utf-8
   :language: c
   :start-after: ///AAA
   :end-before: ///BBB

Le premier ``enum`` permet de définir le type de données ``day`` qui contient une valeur énumérée pour chaque jour de la semaine. L'utilisation d'un type énuméré rend le code plus lisible que simplement l'utilisation de constantes définies via le préprocesseur.

.. literalinclude:: /C/S3-src/enum.c
   :encoding: utf-8
   :language: c
   :start-after: ///CCC
   :end-before: ///DDD

En pratique, lors de la définition d'un type énuméré, le compilateur C associe une valeur entière à chacune des valeurs énumérées. Une variable permettant de stocker la valeur d'un type énuméré occupe la même zone mémoire qu'un entier.

Outre les structures, le langage C supporte également les unions. Alors qu'une structure permet de stocker plusieurs données dans une même zone mémoire, une ``union`` permet de réserver une zone mémoire pour stocker une données parmi plusieurs types possibles. Une ``union`` est parfois utilisée pour minimiser la quantité de mémoire utilisée pour une structure de données qui peut contenir des données de plusieurs types. Pour bien comprendre la différence entre une ``union`` et une ``struct``, considérons l'exemple ci-dessous.

.. literalinclude:: /C/S3-src/union.c
   :encoding: utf-8
   :language: c
   :start-after: ///AAA
   :end-before: ///BBB


Une union, ``u`` et une structure, ``s`` sont déclarées dans ce fragment de programme.

.. literalinclude:: /C/S3-src/union.c
   :encoding: utf-8
   :language: c
   :start-after: ///CCC
   :end-before: ///DDD

La structure ``s`` peut contenir à la fois un entier et un caractère. Par contre, l'``union`` ``u``, peut elle contenir un entier (``u.i``) *ou* un caractère (``u.c``), mais jamais les deux en même temps.
Le compilateur C alloue la taille pour l'``union`` de façon à ce qu'elle puisse contenir le type de donnée se trouvant dans l'``union`` nécessitant le plus de mémoire. Si les unions sont utiles dans certains cas très particulier, il faut faire très attention à leur utilisation. Lorsqu'une ``union`` est utilisée, le compilateur C fait encore moins de vérifications sur les types de données et le code ci-dessous est considéré comme valide par le compilateur :

.. literalinclude:: /C/S3-src/union.c
   :encoding: utf-8
   :language: c
   :start-after: ///EEE
   :end-before: ///FFF

Lors de son exécution, la zone mémoire correspondant à l'union ``u`` sera simplement interprétée comme contenant un ``char``, même si on vient d'y stocker un entier. En pratique, lorsqu'une ``union`` est vraiment nécessaire pour des raisons d'économie de mémoire, on préférera la placer dans une ``struct`` en utilisant un type énuméré qui permet de spécifier le type de données qui est présent dans l'``union``.

.. literalinclude:: /C/S3-src/union.c
   :encoding: utf-8
   :language: c
   :start-after: ///BBB
   :end-before: ///XXX

Le programmeur pourra alors utiliser cette structure en indiquant explicitement le type de données qui y est actuellement stocké comme suit.

.. literalinclude:: /C/S3-src/union.c
   :encoding: utf-8
   :language: c
   :start-after: ///FFF
   :end-before: ///GGG
