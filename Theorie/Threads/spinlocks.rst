.. -*- coding: utf-8 -*-
.. Copyright |copy| 2020 by Etienne Rivière
.. Ce fichier est distribué sous une licence `creative commons <http://creativecommons.org/licenses/by-sa/3.0/>`_

   
.. _declarations:
 
Mise en oeuvre des verrous
==========================

Cette nouvelle section décrira la mise en œuvre des verrous (mutex) au sein d'un système d'exploitation. Elle couvrira les algorithmes classiques fondés sur des registres en lecture/écriture ainsi que des solutions plus efficaces utilisant les opérations atomiques.


.. Algorithme de Peterson
.. ^^^^^^^^^^^^^^^^^^^^^^
..
.. .. todo:: Algorithme de Dijkstra, [Dijkstra1965]_
..
.. .. todo:: Algorithme de Dekker
..
.. .. todo:: Lamport A New Solution of Dijkstra's Concurrent Programming Problem Communications of the ACM 17, 8   (August 1974), 453-455. (bakery algorithm)
..
.. .. todo:: Autres algorithmes [Alagarsamy2003]_
..
..
.. Le problème de l'exclusion mutuelle a intéressé de nombreux informaticiens depuis le début des années 1960s [Dijkstra1965]_ et différentes solutions à ce problème ont été proposées. Plusieurs d'entre elles sont analysées en détails dans [Alagarsamy2003]_. Dans cette section, nous nous concentrerons sur une de ces solutions proposées par G. Peterson en 1981 [Peterson1981]_. Cette solution permet à plusieurs threads de coordonner leur exécution de façon à éviter une violation de section critique en utilisant uniquement des variables accessibles à tous les threads. La solution proposée par Peterson permet de gérer `N` threads [Peterson1981]_ mais nous nous limiterons à sa version permettant de coordonner deux threads.
..
.. Une première solution permettant de coordonner deux threads en utilisant des variables partagées pourrait être de s'appuyer sur une variable qui permet de déterminer quel est le thread qui peut entrer en section critique. Dans l'implémentation ci-dessous, la variable partagée ``turn`` est utilisée par les deux threads et permet de coordonner leur exécution. ``turn`` peut prendre les valeurs ``0`` ou ``1``. Le premier thread exécute la boucle ``while (turn != 0) { }``. Prise isolément, cette boucle pourrait apparaître comme une boucle inutile (``turn==0`` avant son exécution)  ou une boucle infinie (``turn==1`` avant son exécution). Un tel raisonnement est incorrect lorsque la variable ``turn`` peut être modifiée par les deux threads. En effet, si ``turn`` vaut ``1`` au début de la boucle ``while (turn != 0) { }``, la valeur de cette variable peut être modifiée par un autre thread pendant l'exécution de la boucle et donc provoquer son arrêt.
..
.. .. code-block:: c
..
..   // thread 1
..   while (turn!=0)
..   { /* loop */ }
..   section_critique();
..   turn=1;
..   // ...
..
..   // thread 2
..   while (turn!=1)
..   { /* loop */ }
..   section_critique();
..   turn=0;
..
.. Il est intéressant d'analyser ces deux threads en détails pour déterminer si ils permettent d'éviter une violation de section critique et respectent les 4 contraintes précisées plus haut. Dans ces deux threads, pour qu'une violation de section critique puisse se produire, il faudrait que les deux threads passent en même temps la boucle ``while`` qui précède la section critique. Imaginons que le premier thread est entré dans sa section critique. Puisqu'il est sorti de sa boucle ``while``, cela implique que la variable ``turn`` a la valeur ``0``. Sinon, le premier thread serait toujours en train d'exécuter sa boucle ``while``. Examinons maintenant le fonctionnement du second thread. Pour entrer dans sa section critique, celui-ci va exécuter la boucle ``while (turn != 1){ }``. A ce moment, ``turn`` a la valeur ``0``. La boucle dans le second thread va donc s'exécuter en permanence. Elle ne s'arrêtera que si la valeur de ``turn`` change. Or, le premier thread ne pourra changer la valeur de ``turn`` que lorsqu'il aura quitté sa section critique. Cette solution évite donc toute violation de la section critique. Malheureusement, elle ne fonctionne que si il y a une alternance stricte entre les deux threads. Le second s'exécute après le premier qui lui même s'exécute après le second, ... Cette alternance n'est évidemment pas acceptable.
..
.. Analysons une seconde solution. Celle-ci utilise un tableau ``flag`` contenant deux drapeaux, un par thread. Ces deux drapeaux sont initialisés à la valeur ``false``. Pour plus de facilité, nous nommons les threads en utilisant la lettre ``A`` pour le premier et ``B`` pour le second. Le drapeau ``flag[x]`` est modifié par le thread ``x`` et sa valeur est testée par l'autre thread.
..
.. .. code-block:: c
..
..    #define A 0
..    #define B 1
..    int flag[];
..    flag[A]=false;
..    flag[B]=false;
..
..
.. Le premier thread peut s'écrire comme suit. Il comprend une boucle ``while`` qui teste le drapeau ``flag[B]`` du second thread. Avant d'entrer en section critique, il met son drapeau ``flag[A]`` à ``true`` et le remet à ``false`` dès qu'il en est sorti.
..
.. .. code-block:: c
..
..    // Thread A
..    while (flag[B]==true)
..    { /* loop */ }
..    flag[A]=true;
..    section_critique();
..    flag[A]=false;
..    //...
..
.. Le second thread est organisé d'une façon similaire.
..
.. .. code-block:: c
..
..    // Thread B
..    while (flag[A]==true)
..    { /* loop */ }
..    flag[B]=true;
..    section_critique();
..    flag[B]=false;
..    // ...
..
.. Analysons le fonctionnement de cette solution et vérifions si elle permet d'éviter toute violation de section critique. Pour qu'une violation de section critique se produise, il faudrait que les deux threads exécutent simultanément leur section critique. La boucle ``while`` qui précède dans chaque thread l'entrée en section critique parait éviter les problèmes puisque si le thread ``A`` est dans sa section critique, il a mis ``flag[A]`` à la valeur ``true`` et donc le thread ``B`` exécutera en permanence sa boucle ``while``. Malheureusement, la situation suivante est possible. Supposons que ``flag[A]`` et ``flag[B]`` ont la valeur ``false`` et que les deux threads souhaitent entrer dans leur section critique en même temps. Chaque thread va pouvoir traverser sa boucle ``while`` sans attente puis seulement mettre son drapeau à ``true``. A cet instant il est trop tard et une violation de section critique se produira. Cette violation a été illustrée sur une machine multiprocesseur qui exécute deux threads simultanément. Elle est possible également sur une machine monoprocesseur. Dans ce cas, il suffit d'imaginer que le thread ``A`` passe sa boucle ``while`` et est interrompu par le scheduler avant d'exécuter ``flag[A]=true;``. Le scheduler réalise un changement de contexte et permet au thread ``B`` de s'exécuter. Il peut passer sa boucle ``while`` puis entre en section critique alors que le thread ``A`` est également prêt à y entrer.
..
.. Une alternative pour éviter le problème de violation de l'exclusion mutuelle pourrait être d'inverser la boucle ``while`` et l'assignation du drapeau. Pour le thread ``A``, cela donnerait le code ci-dessous :
..
..
.. .. code-block:: c
..
..    // Thread A
..    flag[A]=true;
..    while (flag[B]==true)
..    { /* loop */ }
..    section_critique();
..    flag[A]=false;
..    //...
..
.. Le thread ``B`` peut s'implémenter de façon similaire. Analysons le fonctionnement de cette solution sur un ordinateur monoprocesseur. Un scénario possible est le suivant. Le thread ``A`` exécute la ligne permettant d'assigner son drapeau, ``flag[A]=true;``. Après cette assignation, le scheduler interrompt ce thread et démarre le thread ``B``. Celui-ci exécute ``flag[B]=true;`` puis démarre sa boucle ``while``. Vu le contenu du drapeau ``flag[A]``, celle-ci va s'exécuter en permanence. Après quelque temps, le scheduler repasse la main au thread ``A`` qui va lui aussi entamer sa boucle ``while``. Comme ``flag[B]`` a été mis à ``true`` par le thread ``B``, le thread ``A`` entame également sa boucle ``while``. A partir de cet instant, les deux threads vont exécuter leur boucle ``while`` qui protège l'accès à la section critique. Malheureusement, comme chaque thread exécute sa boucle ``while`` aucun des threads ne va modifier son drapeau de façon à permettre à l'autre thread de sortir de sa boucle. Cette situation perdurera indéfiniment. Dans la littérature, cette situation est baptisée un :term:`livelock`. Un :term:`livelock` est une situation dans laquelle plusieurs threads exécutent une séquence d'instructions (dans ce cas les instructions relatives aux boucles ``while``) sans qu'aucun thread ne puisse réaliser de progrès. Un :term:`livelock` est un problème extrêmement gênant puisque lorsqu'il survient les threads concernés continuent à utiliser le processeur mais n'exécutent aucune instruction utile. Il peut être très difficile à diagnostiquer et il est important de réfléchir à la structure du programme et aux techniques de coordination entre les threads qui sont utilisées afin de garantir qu'aucun :term:`livelock` ne pourra se produire.
..
.. L'algorithme de Peterson [Peterson1981]_ combine les deux idées présentées plus tôt. Il utilise une variable ``turn`` qui est testée et modifiée par les deux threads comme dans la première solution et un tableau ``flag[]`` comme la seconde. Les drapeaux du tableau sont initialisés à ``false`` et la variable ``turn`` peut prendre la valeur ``A`` ou ``B``.
..
.. .. code-block:: c
..
..    #define A 0
..    #define B 1
..    int flag[];
..    flag[A]=false;
..    flag[B]=false;
..
.. Le thread ``A`` peut s'écrire comme suit.
..
.. .. code-block:: c
..
..    // thread A
..    flag[A]=true;
..    turn=B;
..    while((flag[B]==true)&&(turn==B))
..    { /* loop */ }
..    section_critique();
..    flag[A]=false;
..    // ...
..
.. Le thread ``B`` s'implémente de façon similaire.
..
.. .. code-block:: c
..
..    // Thread B
..    flag[B]=true;
..    turn=A;
..    while((flag[A]==true)&&(turn==A))
..    { /* loop */ }
..    section_critique();
..    flag[B]=false;
..    // ...
..
.. Pour vérifier si cette solution répond bien au problème de l'exclusion mutuelle, il nous faut d'abord vérifier qu'il ne peut y avoir de violation de la section critique. Pour qu'une violation de section critique soit possible, il faudrait que les deux threads soient sortis de leur boucle ``while``. Examinons le cas où le thread ``B`` se trouve en section critique. Dans ce cas, ``flag[B]`` a la valeur ``true``. Si le thread ``A`` veut entrer en section critique, il va d'abord devoir exécuter ``flag[A]=true;`` et ensuite ``turn=B;``. Comme le thread ``B`` ne modifie ni ``flag[A]`` ni ``turn`` dans sa section critique, thread ``A`` va devoir exécuter sa boucle ``while`` jusqu'à ce que le thread ``B`` sorte de sa section critique et exécute ``flag[B]=false;``. Il ne peut donc pas y avoir de violation de la section critique.
..
.. Il nous faut également montrer que l'algorithme de Peterson ne peut pas causer de :term:`livelock`. Pour qu'un tel :term:`livelock` soit possible, il faudrait que les boucles ``while((flag[A]==true)&&(turn==A)) {};``  et ``while((flag[B]==true)&&(turn==B)) {};`` puissent s'exécuter en permanence en même temps. Comme la variable ``turn`` ne peut prendre que la valeur ``A`` ou la valeur ``B``, il est impossible que les deux conditions de boucle soient simultanément vraies.
..
.. Enfin, considérons l'impact de l'arrêt d'un des deux threads. Si thread ``A`` s'arrête hors de sa section critique, ``flag[A]`` a la valeur ``false`` et le thread ``B`` pourra toujours accéder à sa section critique.
..
..
.. Utilisation d'instruction atomique
.. ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
..
.. Sur les ordinateurs actuels, il devient difficile d'utiliser l'algorithme de Peterson tel qu'il a été décrit et ce pour deux raisons. Tout d'abord, les compilateurs C sont capables d'optimiser le code qu'ils génèrent. Pour cela, ils analysent le programme à compiler et peuvent supprimer des instructions qui leur semblent être inutiles. Dans le cas de l'algorithme de Peterson, le compilateur pourrait très bien considérer que la boucle ``while`` est inutile puisque les variables ``turn`` et ``flag`` ont été initialisées juste avant d'entrer dans la boucle.
..
.. La deuxième raison est que sur un ordinateur multiprocesseur, chaque processeur peut réordonner les accès à la mémoire automatiquement afin d'en optimiser les performances [McKenney2005]_. Cela a comme conséquence que certaines lectures et écritures en mémoires peuvent se faire dans un autre ordre que celui indiqué dans le programme sur certaines architectures de processeurs. Si dans l'algorithme de Peterson le thread ``A`` lit la valeur de ``flag[B]`` alors que l'écriture en mémoire pour ``flag[A]`` n'a pas encore été effectuée, une violation de la section critique est possible. En effet, dans ce cas les deux threads peuvent tous les deux passer leur boucle ``while`` avant que la mise à jour de leur drapeau n'aie été faite effectivement en mémoire.
..
.. Pour résoudre ce problème, les architectes de microprocesseurs ont proposé l'utilisation d'opérations atomiques. Une :term:`opération atomique` est une opération qui lorsqu'elle est exécutée sur un processeur ne peut pas être interrompue par l'arrivée d'une interruption. Ces opérations permettent généralement de manipuler en même temps un registre et une adresse en mémoire. En plus de leur caractère ininterruptible, l'exécution de ces instructions atomiques par un ou plusieurs processeur implique une coordination des processeurs pour l'accès à la zone mémoire référencée dans l'instruction. Via un mécanisme qui sort du cadre de ces notes, tous les accès à la mémoire faits par ces instructions sont ordonnés par les processeurs de façon à ce qu'ils soient toujours réalisés séquentiellement.
..
.. Plusieurs types d'instructions atomiques sont supportés par différentes architectures de processeurs. A titre d'exemple, considérons l'instruction atomique ``xchg`` qui est supportée par les processeurs [IA32]_. Cette instruction permet d'échanger, de façon atomique, le contenu d'un registre avec une zone de la mémoire. Elle prend deux arguments, un registre et une adresse en mémoire. Ainsi, l'instruction ``xchgl %eax,(var)`` est équivalente aux trois instructions suivantes, en supposant le registre ``%ebx`` initialement vide. La première sauvegarde dans ``%ebx`` le contenu de la mémoire à l'adresse ``var``. La deuxième copie le contenu du registre ``%eax`` à cette adresse mémoire et la dernière transfère le contenu de ``%ebx`` dans ``%eax`` de façon à terminer l'échange de valeurs.
..
.. .. code-block:: nasm
..
..    movl (var), %ebx
..    movl %eax, (var)
..    movl %ebx, %eax
..
.. Avec cette instruction atomique, il est possible de résoudre le problème de l'exclusion mutuelle en utilisant une zone mémoire, baptisée ``lock`` dans l'exemple. Cette zone mémoire contiendra la valeur ``1`` ou ``0``. Cette zone mémoire est initialisée à ``0``. Lorsqu'un thread veut accéder à sa section critique, il exécute les instructions à partir de l'étiquette ``enter:``. Pour sortir de section critique, il suffit d'exécuter les instructions à partir de l'étiquette ``leave:``.
..
.. .. code-block:: nasm
..
..   lock:                    ; étiquette, variable
..     .long    0          ; initialisée à 0
..
..   enter:
..      movl    $1, %eax      ; %eax=1
..      xchgl   %eax, (lock)  ; instruction atomique, échange (lock) et %eax
..                            ; après exécution, %eax contient la donnée qui était
..                ; dans lock et lock la valeur 1
..      testl   %eax, %eax    ; met le flag ZF à vrai si %eax contient 0
..      jnz     enter         ; retour à enter: si ZF n'est pas vrai
..      ret
..
..   leave:
..      mov     $0, %eax      ; %eax=0
..      xchgl   %eax, (lock)  ; instruction atomique
..      ret
..
.. Pour bien comprendre le fonctionnement de cette solution, il faut analyser les instructions qui composent chaque routine en assembleur. La routine ``leave`` est la plus simple. Elle place la valeur ``0`` à l'adresse ``lock``. Elle utilise une instruction atomique de façon à garantir que cet accès en mémoire se fait séquentiellement. Lorsque ``lock`` vaut ``0``, cela indique qu'aucun thread ne se trouve en section critique. Si ``lock`` contient la valeur ``1``, cela indique qu'un thread est actuellement dans sa section critique et qu'aucun autre thread ne peut y entrer. Pour entrer en section critique, un thread doit d'abord exécuter la routine ``enter``. Cette routine initialise d'abord le registre ``%eax`` à la valeur ``1``. Ensuite, l'instruction ``xchgl`` est utilisée pour échanger le contenu de ``%eax`` avec la zone mémoire ``lock``. Après l'exécution de cette instruction atomique, l'adresse ``lock`` contiendra nécessairement la valeur ``1``. Par contre, le registre ``%eax`` contiendra la valeur qui se trouvait à l'adresse ``lock`` avant l'exécution de ``xchgl``. C'est en testant cette valeur que le thread pourra déterminer si il peut entrer en section critique ou non. Deux cas sont possibles :
..
..  a. ``%eax==0`` après exécution de l'instruction ``xchgl  %eax, (lock)``. Dans ce cas, le thread peut accéder à sa section critique. En effet, cela indique qu'avant l'exécution de cette instruction l'adresse ``lock`` contenait la valeur ``0``. Cette valeur indique que la section critique était libre avant l'exécution de l'instruction ``xchgl  %eax, (lock)``. En outre, cette instruction a placé la valeur ``1`` à l'adresse ``lock``, ce qui indique qu'un thread exécute actuellement sa section critique. Si un autre thread exécute l'instruction ``xchgl  %eax, (lock)`` à cet instant, il récupèrera la valeur ``1`` dans ``%eax`` et ne pourra donc pas entre en section critique. Si deux threads exécutent simultanément et sur des processeurs différents l'instruction ``xchgl  %eax, (lock)``, la coordination des accès mémoires entre les processeurs garantit que ces accès mémoires seront séquentiels. Le thread qui bénéficiera du premier accès à la mémoire sera celui qui récupèrera la valeur ``0`` dans ``%eax`` et pourra entrer dans sa section critique. Le ou les autres threads récupéreront la valeur ``1`` dans ``%eax`` et boucleront.
..  b. ``%eax==1`` après exécution de l'instruction ``xchgl %eax, (lock)``. Dans ce cas, le thread ne peut entrer en section critique et il entame une boucle active durant laquelle il va continuellement exécuter la boucle ``enter: movl ... jnz enter``.
..
..
.. .. todo:: inversion de priorité ?
..
.. En pratique, rares sont les programmes qui coordonnent leurs threads en utilisant des instructions atomiques ou l'algorithme de Peterson. Ces programmes profitent généralement des fonctions de coordination qui sont implémentées dans des librairies du système d'exploitation.
