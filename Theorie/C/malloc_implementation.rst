.. -*- coding: utf-8 -*-
.. Copyright |copy| 2012, 2020 by `Olivier Bonaventure <http://inl.info.ucl.ac.be/obo>`_, Etienne Rivière, Christoph Paasch et Grégory Detal
.. Ce fichier est distribué sous une licence `creative commons <http://creativecommons.org/licenses/by-sa/3.0/>`_

   
.. _declarations:
 
Gestion de la mémoire dynamique
===============================

Nous avons vu dans la section précédente comment allouer et libérer de la mémoire dans le :term:`heap` en utilisant les fonctions de la librairie standard `malloc(3)`_ et `free(3)`_ ainsi que leurs dérivées.

Pour rappel, les signatures de ces fonctions sont les suivantes :

.. code-block:: c

   void *malloc(size_t size);
   void free(void *ptr);

`malloc(3)`_ renvoie un pointeur vers une zone de mémoire du :term:`heap` de taille *minimum* ``size``.
`free(3)`_ permet de libérer une zone mémoire précédemment réservée indiquée par le pointeur ``ptr``.
Cette fonction a un comportement indéterminé si elle est appelée avec un pointeur ne correspondant pas à une zone mémoire réservée et non encore libérée.

La gestion du :term:`heap` est sous la responsabilité d'un algorithme de gestion de mémoire dynamique.
L'objectif de cet algorithme est double. Premièrement, il doit retourner des zones réservées qui ne se chevauchent pas entre elles et contiennent au moins le nombre d'octets demandés. Deuxièmement, il doit permettre de *recycler* la mémoire des zones libérées pour pouvoir les utiliser de nouveau pour héberger de nouvelles zones réservées.

Dans cette section, nous étudierons les principes et la mise en œuvre des algorithmes de gestion de mémoire dynamique.
Nous ne couvrirons pas la mise en œuvre de l'appel `realloc(3)`_ dans le cadre de ce cours.

Gestion du heap 
---------------

L'adresse de départ du :term:`heap` est toujours l'octet qui suit le segment des données non-initialisées.
Son adresse de fin est appelée le *program break* sous Linux.
Au démarrage d'un programme sous Linux, l'adresse de départ et l'adresse de fin identiques.
Cela implique que la taille du :term:`heap` initiale est de 0.

Deux appels système permettent de changer la valeur du *program break* et donc d'augmenter la taille du :term:`heap`.
Ces deux appels sont définis dans ``<unistd.h>`` :

.. code-block:: c

   #include <unistd.h>
   int brk(void *addr);
   void *sbrk(intptr_t increment);

L'appel ``brk`` permet de fixer le *program break* a une valeur arbitraire.
Sa valeur de retour est 0 lorsque l'opération est un succès.
L'appel ``sbrk`` permet d'incrémenter la valeur du *program break* d'un nombre d'octets fourni en argument, et retourne la nouvelle valeur  du *program break*.
Appeler ``sbrk`` avec un argument de 0 permet de lire la valeur actuelle du *program break* sans la modifier.
La figure suivante illustre le fonctionnement de l'appel ``sbrk`` pour réserver 1 Giga-octet de mémoire pour le :term:`heap`.

.. figure:: figures/sbrk.png
   :align: center
   :scale: 20

Les deux appels ``brk`` et ``sbrk`` peuvent échouer, en particulier lorsque la valeur demandée pour le *program break* résulte pour le programme en un dépassement de la taille maximale autorisée pour ce programme.
Cette taille maximale dépend des paramètres du système et des autorisations de l'utilisateur.
On peut la connaître en utilisant l'utilitaire `ulimit(1posix)`_.

En pratique, un programme utilisateur n'utilise jamais les appels ``brk`` et ``sbrk`` mais fait appel aux fonction de l'algorithme de gestion de mémoire dynamique, c'est à dire `malloc(3)`_ et `free(3)`_.
La mise en oeuvre de  `malloc(3)`_ détermine ainsi quand il est nécessaire d'utiliser ``sbrk`` pour étendre la taille de la :term:`heap` afin de répondre à une demande d'allocation, et la mise en oeuvre de `free(3)`_ peut de façon similaire décider de réduire la taille du :term:`heap` en appelant ``sbrk`` avec un argument négatif.

Contraintes
-----------

Un algorithme de gestion de mémoire dynamique obéit aux besoins et contraintes suivants :

- Il est nécessaire de conserver de l'information (des méta-données) sur les blocs alloués et libérés.
- Le segment :term:`heap` doit être utilisé pour stocker ces méta-données. Les autres segments de la mémoire sont en effet dédiés aux informations du programme lui-même (segments *text*, segments de données initialisées et non initialisées, etc.). Il n'est donc possible de stocker les méta-données utilisées par l'algorithme que dans le segment :term:`heap` lui même. Ces méta-données seront donc *intercalées* avec les zones de mémoire allouées utilisées par l'application.

Par ailleurs, il est généralement nécessaire que les zones mémoires allouées soient *alignées*. Cela veut dire que l'adresse de début de chaque zone, ainsi que la taille de la zone, doivent être des multiples d'un *facteur d'alignement*. 
Ce facteur est de 8 octets sous Linux.
Une zone réservée sera ainsi toujours d'une taille multiple du facteur d'alignement.
Par exemple, sous Linux une demande pour 17 octets réservera en réalité 24 octets, le multiple de 8 supérieur le plus proche.
On appelle cette extension de la zone demandé le *padding*.

L'alignement permet tout d'abord de faire des hypothèses sur les adresses retournées (les bits de poids faibles sont toujours à 0 : avec un facteur d'alignement de 8 les trois derniers bits des adresses retournées par `malloc(3)`_ valent ainsi 0).
L'alignement facilite aussi la mise en oeuvre et l'efficacité des algorithmes de gestion de mémoire dynamique.
L'exemple ci-dessous illustre l'alignement utilisé par `malloc(3)`_ sous Linux.

.. literalinclude:: /C/src/malloc_align.c
   :encoding: utf-8
   :language: c
   :start-after: ///AAA
   :end-before: ///BBB

L'exécution de ce programme produit la sortie standard suivante.

.. literalinclude:: /C/src/malloc_align.out
   :encoding: utf-8
   :language: console

On peut observer que la zone réservée pour  ``b`` est située 16 octets plus loin que celle pour ``a`` même si cette dernière ne demandait qu'une zone de 1 octet.
Il est intéressant d'analyser ce résultat.
On observe tout d'abord que, bien qu'elle soit une multiple de 8, le facteur d'alignement, l'adresse ``0x8e29010`` n'ait pas été retournée pour ``b``, ce qui aurait pourtant laissé un espace de 8 octets pour ``a``.
La raison est que la zone nécessaire pour ``a`` ne contient pas seulement les octets retournés mais aussi des métadonnées nécessaires à l'algorithme de gestion de la mémoire dynamique.
La zone réservée pour ``c`` est elle encore 16 octets plus loin que celle pour ``b``, son adresse de démarrage est ainsi alignée sur le facteur d'alignement de 8.

Objectifs
---------

On mesure la qualité d'un algorithme de gestion de mémoire dynamique selon **trois critères** principaux.

**Premièrement**, les appels aux fonctions `malloc(3)`_ et `free(3)`_ doivent idéalement s'exécuter le plus rapidement possible, et ce temps d'exécution doit varier le moins possible entre plusieurs appels. Ces fonctions sont effectivement utilisées de manière intensive par de nombreux programmes, et les appels à `malloc(3)`_ et `free(3)`_ peuvent se trouver dans des chemins de code critiques dont la performance ne doit pas varier au cours du temps ou ne doit pas varier en fonction de la quantité de données manipulées par le programme.

**Deuxièmement**, l'algorithme doit utiliser la mémoire disponible de manière *efficace*. Il doit pour cela réduire la *fragmentation*. On distingue la fragmentation externe et la fragmentation interne :

- La fragmentation externe mesure à quel point l'espace mémoire complet est fragmenté avec de nombreuses zones libres intercalées entre des zones réservées. On peut voir un exemple de deux heaps dans l'illustration ci-dessous. Les espaces alloués sont représentés en jaune. Dans la heap du haut, on observe que l'espace disponible est fragmenté en de nombreux *trous* entre les espaces alloués. Une requête d'allocation, représentée en vert, ne peut pas être servie car il n'existe pas de trou de taille suffisante pour la placer. Il est donc nécessaire, dans ce cas, d'augmenter la taille du :term:`heap`. En revanche, dans la heap du dessous, l'espace disponible est réparti en de moins nombreux trous et il est possible de répondre à la demande d'allocation sans augmenter la taille du :term:`heap`.

.. figure:: figures/fragmentation.png
   :align: center
   :scale: 20

- La fragmentation interne mesure l'espace *perdu* pour chaque allocation, qui n'est pas utilisé pour stocker des donnés. Cela inclut l'espace de padding, mais aussi l'espace utilisé pour les métadonnées. Dans l'exemple plus haut, l'espace nécessaire pour la zone ``a`` de 1 octet demandé fait 16 octets, ce qui résulte en une fragmentation interne de 15 octets.

.. note:: La défragmentation n'est pas une option

 On pourrait être tenté de proposer un mécanisme pour revisiter l'allocation des zones allouées dans le but de réduire la fragmentation.
 Cela n'est malheureusement pas possible : les pointeurs vers les zones allouées ont été retournés à l'application et il n'est pas possible de les changer après le retour de `malloc(3)`_.
 Il faut donc prendre en compte l'objectif de réduction de la fragmentation lors des appels à `malloc(3)`_ et `free(3)`_.

**Troisièmement**, les espaces mémoires réservés par des appels `malloc(3)`_ successifs doivent être idéalement proches les uns des autres. Cette propriété de *localité* est importante pour maximiser l'utilisation du cache du processeur, dont l'utilité dépend de cette notion de localité. Les principes simplifiés du fonctionnement d'un cache sont détaillés ci-dessous.
Par ailleurs, les espaces mémoires réservés doivent 

.. note:: Le principe de localité et le cache du processeur

 Pour comprendre le principe de localité il nous faut comprendre le principe de cache.
 Dans notre modèle de système informatique présenté précédemment, nous avons considéré que le processeur effectuait des opérations de lecture et d'écriture directement vers la mémoire principale.
 L'évolution de la technologie a été telle que désormais la vitesse d'exécution d'un processeur est très largement supérieure à la vitesse à laquelle ou peut accéder à la mémoire : un processeur peut ainsi attendre des centaines de cycles avant de recevoir le résultat d'une opération de lecture en mémoire.
 Pour pallier ce problème, les processeurs sont équipés de *mémoire cache*.
 Cette mémoire est plus performante que la mémoire principale : sa latence d'accès est plus faible. 
 Elle est aussi beaucoup plus chère.
 La mémoire cache ne contient donc qu'un petit sous-ensemble des données utilisées par le programme, sous forme de lignes de cache dont la taille est généralement de quelques douzaines d'octets (par exemple, 64 octets).
 La mémoire principale n'est utilisée que si l'adresse lue n'est pas déjà présente dans le cache.
 En pratique, une grande partie des accès à la mémoire est servie par le cache grâce à la localité des accès : localité temporelle (une même donnée est lue plusieurs fois dans un intervalle de temps court) et la localité spatiale (si une donnée est lue alors il y a une forte probabilité que la donnée présente dans les octets suivants le soit aussi -- par exemple lors du parcours d'une structure de données).
 
 Afin de favoriser la localité et donc l'utilité de la mémoire cache, il est préférable que des appels à `malloc(3)`_ successifs renvoient des zones mémoires qui se jouxtent, et qui auront ainsi plus de chance d'être placées dans la même ligne de cache.

Enfin, il est préférable qu'un algorithme de gestion de la mémoire dynamique soit robuste et qu'il facilite le déboguage.
Par exemple, il est préférable que l'on puisse vérifier, lors d'un appel à `free(3)`_ que l'adresse soit vérifiable comme étant effectivement une adresse précédemment retournée par un appel à `malloc(3)`_.

Algorithmes
-----------

Il existe de très nombreux algorithmes de gestion de la mémoire dynamique, dont certains sont très sophistiqués.
L'objectif de ce cours n'est pas de les présenter de façon exhaustive mais d'illustrer le compromis entre performance, localité, et coût en mémoire des méta-données.
Il permet par ailleurs de montrer un exemple concret de la séparation entre mécanisme et politique, typique de la philosophie des systèmes UNIX.

Dans les descriptions ci-dessous, on considèrera que la mémoire est divisée en cases pouvant contenir chacune, soit un entier, soit une adresse (un pointeur).
Un bloc est composé de plusieurs cases.
Pour chaque bloc, il est nécessaire de stocker deux types de méta-données : la longueur de ce bloc, et s'il s'agit d'un bloc réservé, ou d'un bloc libre (i.e., un "trou").
Une méthode simple pour stocker les méta-données est de réserver une case avant le bloc de données réservé, comme l'illustre la figure ci-dessous.
La case de méta-données (*header* en anglais), en jaune, augmente donc de une case l'espace nécessaire pour héberger la zone demandée de 4 blocs en vert.
Ici la taille stockée dans la case de méta-données sera donc de 5 cases, et le bloc sera marquée comme réservée.

.. figure:: figures/malloc_imp1.png
   :align: center
   :scale: 20

.. note:: Utilisation du bit de poids faible pour stocker l'état d'un bloc

 On note que si la taille des blocs en octets est toujours un multiple de 2 (ce qui est le cas dans notre exemple ou chaque case peut contenir un int) alors on a l'assurance que le bit de poids faible sera de valeur 0.
 On peut tirer partie de cela pour stocker s'il s'agit d'un bloc libre ou d'un bloc réservé : il suffit d'une valeur binaire (par exemple, 0 indique un bloc libre, 1 indique un bloc réservé).
 On peut alors utiliser les opérations de manipulations de bit pour forcer à 1 ou 0 la valeur de ce bit, et un masque binaire pour lire sa valeur.
 Ainsi, si ``c`` est la valeur du compteur stockée dans le bloc on peut obtenir son état en utilisant ``c & 0x1``, forcer sa valeur à 1 en utilisant ``c = c | 0x1;`` ou enfin forcer sa valeur à 0 avec ``c = c & ~0x1;``

Utilisation d'une liste implicite
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

L'algorithme le plus simple utilisant le principe de case de header utilise une liste implicite.
Cet algorithme peut trouver un bloc libre en suivant, un à un, les cases de header et en parcourant l'ensemble des blocs réservés et libres, comme illustré dans la figure ci-dessous.

.. figure:: figures/malloc_imp2.png
   :align: center
   :scale: 20

Le parcours de cette liste peut ressembler alors au pseudo-code suivant, où ``p`` est un pointeur vers une case mémoire :

.. code-block:: c

   p = start; 
   while (p < end &&           // fin de liste ?
          ((*p & 0x1) != 0 ||  // déjà alloué
           *p <= len))         // trou trop petit
       p = p + (*p & ~0x1);    // progresse vers le prochain bloc

On notera ici l'utilisation conjointe d'opérateurs binaires (``&``)  pour accéder à la valeur du bit de poids faible du header, et des opérateurs logiques (``&&`` et ``||``).

Le parcours de la liste va trouver, s'il existe, un espace assez grand pour accueillir la zone dont la création est demandée.
Cette zone peut être trop grande et doit donc être scindé en une zone réservée et une nouvelle zone libre, comme illustré par la figure ci-dessous.

.. figure:: figures/malloc_imp3.png
   :align: center
   :scale: 20



Cette structure de données et le parcours de liste associé constituent le *mécanisme* permettant de gérer l'allocation de la mémoire.
Tou




Une fois un trou (bloc libre) de taille suffisante trouvé, 

Une première appro


