.. -*- coding: utf-8 -*-
.. Copyright |copy| 2012, 2020 by `Olivier Bonaventure <http://perso.uclouvain.be/olivier.bonaventure>`_, Etienne Rivière, Christoph Paasch et Grégory Detal
.. Ce fichier est distribué sous une licence `creative commons <http://creativecommons.org/licenses/by-sa/3.0/>`_

.. _introduction:
   
Introduction
============

.. spelling::

   Von Neumann
   binary
   digit
   word
   virtualisation

Les systèmes informatiques sont partout dans notre quotidien : de notre téléphone portable à notre montre connectée, de notre ordinateur de bureau  aux très nombreux *serveurs* supportant les services internet que nous utilisons quotidiennement. De nombreux objets du quotidien sont eux-aussi des systèmes informatiques : on assiste ainsi à une explosion du nombre d'objets connectés (par exemple, des ampoules programmables ou des hauts-parleurs interactifs) et nombreux sont les objets qui intègrent désormais un ordinateur, comme les voitures ou les appareils électroménagers.

Malgré la diversité de leurs usages, tous ces appareils ont en commun des principes fondamentaux de fonctionnement et d'organisation. Un système informatique intègre toujours au moins un :term:`processeur` (:term:`CPU` en anglais), une mémoire, et un ou des dispositifs d'entrée/sortie lui permettant d'interagir avec son environnement.

Le :term:`CPU` est un circuit électronique réalisant très rapidement des opérations simples :

 - lire de l'information en mémoire;
 - écrire de l'information en mémoire;
 - effectuer des calculs.

Les opérations effectuées par le :term:`processeur` sont mises en œuvre directement de manière électronique. On parle d'*instructions*. Le jeu d'instruction d'un :term:`processeur` dépend de son modèle. Par exemple, les ordinateurs Apple et les PCs récents utilisent des processeurs Intel ou AMD permettant d'exécuter le jeu d'instruction ``x86_64``. Dans un futur proche, les ordinateurs Apple utiliseront un CPU mettant en œuvre le jeu d'instruction ``ARM A64``, le même que celui supporté par le processeur du nano-ordinateur RaspberryPI.

La très grande majorité des processeurs adoptent les principes de l'architecture dite de Von Neumann, du nom du pionnier de l'informatique Jon von Neumann qui l'a proposé. Suivant cette architecture, la mémoire principale est utilisée à la fois pour stocker les informations traitées et produites par le programme à exécuter, mais aussi les instructions composant ce programme.

Représentation de l'information
-------------------------------

Un processeur manipule l'information sous forme binaire. L'élément de base pour stocker et représenter de l'information dans un système informatique est donc le :term:`bit`. Un bit (`binary digit` en anglais) peut prendre deux valeurs qui par convention sont représentées par :

 - ``1``
 - ``0``

Physiquement, un bit est représenté sous la forme d'un signal électrique ou optique lorsqu'il est transmis et d'une charge électrique ou sous forme physique (par exemple, magnétique) lorsqu'il est stocké. Nous n'aborderons pas ces détails technologiques dans le cadre de ce cours. Ils font l'objet de nombreux cours d'électronique.

Le bit est l'unité de base de stockage et de transfert de l'information. En général, les systèmes informatiques ne traitent pas des bits individuellement, mais par blocs. On appelle un :term:`nibble` un bloc de 4 bits consécutifs et un  :term:`octet` (ou :term:`byte` en anglais) un bloc de 8 bits consécutifs. On parle de mots (`word` en anglais) pour des groupes comprenant généralement 32 bits et de long mot pour des groupes de 64 bits.

Suivant l'architecture de Von Neumann, les données tout comme les instructions à exécuter par le processeur sont stockées sous forme binaire dans la mémoire. Le processeur va donc lire la prochaine instruction à exécuter sous forme d'un groupe de bits, la déchiffrer, et appliquer l'effet prévu pour l'instruction correspondante, avant de recommencer. L'identité de l'instruction à exécuter est déterminée en décodant les premiers bits de l'instruction; le reste contient ses arguments ou *opérandes*. 

Un jeu d'instruction peut contenir des centaines d'instructions différentes. Certaines instructions ont pour objectif de déterminer la prochaine instruction à lire depuis la mémoire, décoder et exécuter. Ces instructions de contrôle de flux permettent de mettre en œuvre les structures de contrôle : conditionnelles et boucles. D'autres instructions effectuent des calculs, ou permettent de lire ou d'écrire des donnés depuis et vers la mémoire.

Interaction avec le monde extérieur
-----------------------------------

Le processeur et la mémoire ne sont pas les deux seuls composants d'un système informatique. Celui-ci doit également pouvoir interagir avec le monde extérieur, ne fut-ce que pour pouvoir charger le programme à exécuter et les données à analyser. Cette interaction se réalise grâce à un grand nombre de dispositifs d'entrées/sorties et de stockage. Parmi ceux-ci, on peut citer :

 - le clavier qui permet à l'utilisateur d'entrer des caractères;
 - l'écran qui permet à l'utilisateur de visualiser le fonctionnement des programmes et les résultats qu'ils produisent;
 - l'imprimante qui permet à l'ordinateur d'écrire sur papier les résultats de l'exécution de programmes;
 - le disque-dur, les clés USB, les CDs et DVDs qui permettent de stocker les données sous la forme de fichiers et de répertoires;
 - la souris ou la tablette graphique qui permettent à l'utilisateur de fournir à l'ordinateur des indications de positionnement;
 - le scanner qui permet à l'ordinateur de transformer un document en une image numérique;
 - le haut-parleur avec lequel l'ordinateur peut diffuser différentes sortes de son;
 - le microphone et la caméra qui permettent à l'ordinateur de capturer des informations sonores et visuelles pour les stocker ou les traiter.

Les dispositifs d'entrée/sortie et de stockage sont gérés par des contrôleurs de périphériques spécifiques. Par exemple, un contrôleur de périphérique pour le clavier peut être un micro-contrôleur qui interagit avec le dispositif matériel et détecte la frappe de touches. Ce contrôleur de périphérique dispose d'une mémoire propre, qui contient l'identifiant de la touche qui vient d'être frappée.

Il est nécessaire, lorsque l'utilisateur fait une saisie au clavier, que le système puisse récupérer l'information de la mémoire du contrôleur afin de la traiter. Les entrées/sorties se déroulent de manière concurrente (en même temps) que l'exécution par le processeur des instructions du programme principal. Il est donc nécessaire de signaler au processeur qu'un évènement externe est survenu. Ceci est possible grâce au mécanisme d':term:`interruption`.

Une :term:`interruption` est un signal extérieur au processeur qui force celui-ci à arrêter l'exécution du programme en cours, et à passer le contrôle du processeur à une routine de traitement qui va pouvoir la prendre en compte. Cette routine va tout d'abord déterminer la cause de l'interruption, soit en interrogeant un à un les contrôleurs de périphériques soit en utilisant un vecteur d'interruptions qui indique directement le contrôleur à la source de l'interruption. Un code de traitement spécifique est ensuite appelé qui peut, dans notre exemple, récupérer l'information de la mémoire interne du contrôleur du clavier pour la placer en mémoire principale.

Outre les contrôleurs de périphériques externes comme le clavier, la souris ou une manette de jeu, il existe de nombreuses sources d':term:`interruption` possibles : une horloge générant une interruption de manière périodique (par exemple, toutes les 10 millisecondes), un dispositif de stockage annonçant la complétion d'une opération d'écriture ou de lecture, ou encore un périphérique réseau annonçant la réception de données.

.. topic:: L'accès direct à la mémoire ou DMA
  
  Nous avons vu qu'une interruption peut permettre le transfert par le processeur d'une information (la touche pressée) entre la mémoire du contrôleur et la mémoire principale. Cette méthode est adéquate pour les périphériques comme le clavier ou un manette de jeux qui génèrent un nombre très limité d'information par seconde. Elle n'est toutefois pas viable pour les périphériques générant ou recevant de grandes quantités de données.
  
  Si chaque réception d'une donnée (par exemple, un mot de 32 bits) génère une interruption, l'écriture de données sur un périphérique de stockage, ou la réception d'une informations sur le réseau, va simplement saturer le processeur d'interruptions et empêcher l'exécution du programme principal. Le système est alors inutilisable pour autre chose que le traitement de l'entrée/sortie.
  
  Les systèmes informatiques modernes supportent le principe de :term:`DMA` pour Direct Memory Access ou accès direct à la mémoire. Avec DMA, un contrôleur de périphérique est autorisé à accéder directement à la mémoire principale pour y lire et écrire des données. Il n'est alors plus nécessaire de générer une interruption pour chaque mot lu ou écrit, mais seulement lorsqu'une qu'un bloc (ensemble) de données est disponible ou a été consommé. Cela permet au processeur de continuer d'exécuter le programme principal en *parallèle* de l'opération d'entrée/sortie.

Rôle(s) du système d'exploitation
---------------------------------

L'utilisation *directe* d'un système informatique par un programme unique est en théorie possible : c'est d'ailleurs ainsi que les premiers ordinateurs des années 50 étaient utilisés.
Le programme devait alors prévoir les instructions spécifiques pour utiliser les ressources matérielles de l'ordinateur cible, et prendre en compte ses caractéristiques matérielles.
Très rapidement (dès la fin des années 50), la nécessité d'un logiciel intermédiaire simplifiant et systématisant l'utilisation du matériel, comme par exemple la gestion des interruptions et des entrées/sorties que nous venons de décrire, s'est imposé.
Tout système informatique comprend ainsi depuis un *système d'exploitation*.

Un système d'exploitation remplit trois rôles principaux :

 - Le premier rôle du système d'exploitation est de rendre l'exécution et l'utilisation de programmes "utiles" pour l'utilisateur plus aisée et systématique, en simplifiant l'utilisation de ressources matérielles de nature pourtant hétérogènes.
 - Son deuxième rôle est de rentre l'utilisation de ces ressources plus efficace, en permettant par exemple le recouvrement entre les opérations d'entrée/sortie et l'exécution des programmes, ou l'utilisation du système par plusieurs programmes et/ou plusieurs utilisateurs *à la fois*. 
 - Son troisième rôle, enfin, est d'assurer la sécurité et l'intégrité du système informatique lui même et des données qui lui sont confiées. Par exemple, un programme qui rencontre une erreur (e.g., qui essaie d'exécuter une instruction qui n'existe pas) ne doit pas remettre en cause ou stopper l'exécution des autres programmes, et les données d'un utilisateur doivent être protégé de l'accès par d'autres utilisateurs du même système.

Le système d'exploitation remplit ces trois rôles grâce à la **virtualisation** des ressources matérielles. À partir de ressources matérielles de natures variées, le système d'exploitation construit des représentations virtuelles. Ces représentations sont plus faciles à utiliser pour les programmeurs d'applications, et disponibles au travers d'interfaces programmatiques (`Application Programming Interfaces` en anglais - :term:`API`). Par ailleurs, ces représentations sont généralement à visée universelle, c'est à dire qu'elles ne diffèrent pas (ou très peu) d'un système d'exploitation à l'autre, même lorsque les systèmes informatiques et le matériel les composant diffère fortement.

Exemples de virtualisations 
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Nous illustrons ci-dessous le principe de virtualisation avec trois exemples. Bien entendu, l'objectif dans cette introduction n'est pas de comprendre *en détail* les mécanismes et algorithmes permettant leur mise en œuvre, que nous couvrirons dans les chapitres dédiés de ce cours, mais d'illustrer le principe général.

On peut tout d'abord illustrer le principe de virtualisation avec l'utilisation des dispositifs de stockage. Il existe de nombreux dispositifs de stockage (disque dur, clé USB, CD, DVD, mémoire flash, ...). Chacun de ces dispositifs a des caractéristiques électriques et mécaniques propres. Ils permettent en général la lecture et/ou l'écriture de blocs de données de quelques centaines d'octets. Nous reviendrons sur leur fonctionnement ultérieurement. Peu d'applications sont capables de piloter directement de tels dispositifs pour y lire ou y écrire des blocs de données directement, et même si c'était le cas la prise en compte de tous les types de dispositifs disponibles sur le marché serait impossible. Par contre, la majorité des applications sont capables d'utiliser ces systèmes de stockage par l'intermédiaire du *système de fichiers*, un des composants d'un système d'exploitation. La représentation virtualisé qu'est le système de fichiers (arborescence des fichiers, de répertoires, etc.) et l'API associée (`open(2)`_, `close(2)`_, `read(2)`_, `write(2)`_) sont un exemple des services fournis par le système d'exploitation aux applications.

Un deuxième exemple de virtualisation est la notion de :term:`processus` mise en œuvre par tous les systèmes d'exploitation modernes. Celle-ci est une représentation virtuelle de la notion de programme principal s'exécutant sur le processeur, comme nous l'avons décrit précédemment. Elle permet le partage d'un processeur unique entre plusieurs programmes appartenant à un ou plusieurs utilisateurs. Un processus est l'exécution d'une suite d'instructions contenue dans un fichier programme. Le système d'exploitation donne l'illusion à chaque processus qu'il s'exécute de façon totalement isolée sur un processeur qui lui est dédiée, mais en réalité plusieurs processus alternent leur exécution sur un (ou quelques) processeur(s) partagé(s). Le système d'exploitation met en œuvre la notion de processus en alternant rapidement l'exécution de ces processus sur le ou les processeur(s). Ce principe permet de répondre au deuxième rôle du système d'exploitation, celui de l'efficacité. Lorsqu'un processus doit, par exemple, attendre la complétion d'une entrée/sortie (par exemple, si celui-ci attend qu'une touche du clavier soit pressée, que l'interruption correspondante arrive, qu'elle soit traitée, avant de pouvoir reprendre son exécution), le processeur peut être utilisé par un autre processus.

Un troisième et dernier exemple est la notion de *mémoire virtuelle*. Elle répond à deux problématiques :

 - La mémoire physique est une ressource limitée, dont le volume varie selon les systèmes. Un partage *explicite* de la mémoire physique entre processus est complexe à mettre en œuvre : dans les systèmes d'exploitation plus anciens ayant fait ce choix, chaque processus devait prendre en compte, pour accéder à ses instructions et à ses données, les limites de l'espace en mémoire physique qui lui était alloué dynamiquement lors de son initialisation. Ceci nécessitait de décaler par rapport à une adresse de base, toutes les adresses "relatives" utilisées dans le programme. L'espace mémoire disponible pour chaque processus était fixé une fois pour toute lors de cette initialisation, même si seulement une partie était utilisée en réalité. 
 - Un deuxième problème est celui de l'isolation entre processus. Idéalement, les données utilisées par un processus ne doivent pas être accessibles par les autres processus s'exécutant sur le système.

La mémoire virtuelle répond élégamment à ces deux problématiques en offrant à chaque processus une vision virtuelle d'un espace mémoire de taille fixe (très grande), dédié, dans lesquelles les adresses déterminées lors de la compilation du programme sont directement valides. Un programme est libre d'allouer et d'utiliser une quantité arbitraire de mémoire (dans les limites de quotas fixée par le système d'exploitation, mais pas nécessairement dans les limites de la mémoire physique disponible), et les données stockées en mémoire physique pour un processus :math:`P_A` ne sont pas accessibles *via* la mémoire virtuelle d'un processus :math:`P_B`, sauf si celui-ci l'a explicitement demandé. La mémoire virtuelle participe ainsi des trois rôles du système d'exploitation.

Nous verrons en détails dans ce cours comment tirer parti de ces abstractions. Nous allons maintenant aborder de façon introductive la question de leur mise en œuvre au sein d'un système d'exploitation moderne.

Mise en œuvre du système d'exploitation
---------------------------------------

La mise en œuvre d'un système d'exploitation est une tâche complexe, qui doit prendre en compte plusieurs facteurs possiblement contradictoire :

 1. la nécessité de fournir des abstractions et virtualisations des ressources le plus haut niveau et les plus simples possibles à utiliser pour les programmeurs ;
 2. l'universalité des fonctionnalités, permettant de supporter des applications et usages variés avec un même système d'exploitation (ou, au contraire, à supporter le plus efficacement possible un type spécifique d'applications) ;
 3. la performance et le surcoût de ces couches d'abstraction et de virtualisation ;
 4. leur complexité de mise en œuvre, et ce faisant, la complexité de leur mise en œuvre *correcte* (sans bug).

La conception d'un système d'exploitation est donc souvent une affaire de compromis entre ces différents aspects. 
Les coûts de mise en œuvre d'une abstraction dépendent par ailleurs fortement des capacités du matériel utilisé.
Nous avons vu plus haut l'exemple de la DMA, permettant le transfert de données massives entre un contrôleur de périphérique et la mémoire.
Sans le support matériel de la DMA, un système d'exploitation ne peut pas mettre en œuvre efficacement le recouvrement entre les phases d'entrée/sortie d'un processus et les phases de traitement d'un autre processus.
Les fonctionnalités des processeurs ont évolué, en réalité, conjointement à celle des systèmes d'exploitation, afin de permettre la mise en œuvre d'abstraction et de virtualisation plus poussées à un coût raisonnable.

Nous verrons plusieurs exemples de support matériel à la virtualisation des ressources et aux fonctions des systèmes d'exploitation dans ce cours. À titre d'illustration, nous allons utiliser le cas de la mémoire virtuelle dans cette introduction.

.. topic:: Le compromis entre abstraction et performance: exemple de la mémoire virtuelle

  Comme expliqué plus haut, la mémoire virtuelle a de grands avantages : elle offre à chaque processus l'illusion d'un espace mémoire de grande taille, dont la structure est connue à l'avance (par exemple, la première instruction à exécuter est toujours au même emplacement, la :term:`pile` commence toujours au même endroit, etc.).
  Le principe de mémoire virtuelle est connu depuis la fin des années 1950, et a été mis en œuvre dans des super-ordinateurs dès les années 1960.
  On peut donc s'interroger : pourquoi des systèmes d'exploitation pour PC jusqu'aux années 1990 (comme MS DOS), et des systèmes d'exploitations actuels pour systèmes embarqués (comme `uCLinux <https://en.wikipedia.org/wiki/%CE%9CClinux>`_) ne supportent-ils pas le concept de mémoire virtuelle, et gèrent le partage de la mémoire physique de façon explicite, en indiquant aux processus la plage d'adresses *physiques* qu'ils sont en droit d'utiliser ?
  
  Pour comprendre cela, décrivons de façon simplifiée le fonctionnement de la mémoire virtuelle.
  Nous le reverrons en détail lors du cours dédié.
  Un processus :math:`P_A` est composé d'instructions utilisant des adresses en mémoire virtuelle. 
  Le processeur manipule des adresses virtuelles.
  Une adresse virtuelle correspond a une adresse en mémoire physique, qui est déterminée lors de l'exécution du programme.
  Il est donc nécessaire de faire la traduction dynamique entre des adresses virtuelles et des adresses physiques, lors de chaque instruction accédant à la mémoire en lecture ou écriture.
  Par exemple, l'adresse virtuelle ``0x0000FF00`` pour le processus :math:`P_A` peut correspondre en réalité à l'adresse ``0x5FD6FF00`` en mémoire physique.
  Cette traduction est effectuée en consultant une structure de donnée stockée elle aussi en mémoire, appelée la :term:`table des pages`.
  Sans support matériel spécifique, il est nécessaire de transformer toute lecture ou écriture dans la mémoire en deux opérations :
  
   1. Lire la page des tables du processus en cours pour déterminer la correspondance entre adresse virtuelle et adresse physique ;
   2. Traduire l'adresse et effectuer l'opération de lecture ou écriture.
  
  L'opération (1) demande systématiquement un accès mémoire supplémentaire pour lire la page des tables.
  Chaque accès mémoire dans le programme original est ainsi transformé en deux accès mémoire.
  La mémoire étant typiquement un facteur limitant la performance d'exécution des processus, le temps d'exécution peut être simplement doublé ! 
  Le compromis entre utilité et coût n'est alors clairement pas favorable à la mise en œuvre de la mémoire virtuelle.
  
  Pour cette raison, quasiment tous les processeurs modernes intègrent un circuit dédié à la gestion de la virtualisation de la mémoire, appelé la :term:`MMU` (Memory Management Unit).
  La MMU conserve dans une mémoire très rapide des informations sur les associations entre adresses virtuelles et adresses physiques les plus récemment utilisées, et peut assurer la traduction *en ligne* des adresses. 
  Cela permet, dans la grande majorité des cas, que l'accès mémoire soit aussi rapide qu'un accès direct.
  Lorsque l'information n'est pas disponible, par contre, le coût est important : le système d'exploitation doit reprendre la main pour fournir l'information nécessaire à la MMU, ce qui peut prendre un temps équivalent à des centaines voire des milliers d'opérations en mémoire.
  Le support physique de la MMU permet de fournir l'abstraction de mémoire virtuelle de haut niveau à un coût qui est considéré acceptable pour la plus-value qu'elle apporte.

Mécanisme vs. politique
^^^^^^^^^^^^^^^^^^^^^^^

Un aspect important de la mise en œuvre des systèmes d'exploitation, et dont nous discuterons régulièrement dans ce cours, est la séparation entre les mécanismes permettant d'abstraire une ressource matérielle, et les politiques arbitrant le partage de cette ressource (entre les différent programmes, les différents utilisateurs, etc.).

Illustrons ce principe avec l'abstraction de la ressource processeur *via* la notion de processus.
Comme nous l'avons expliqué précédemment, chaque processus a l'illusion de s'exécuter sur un processeur unique, mais en réalité le système d'exploitation partage le temps de chaque processeur entre l'ensemble des processus disponibles.
Bien entendu, un seul processus peut s'exécuter sur un processeur à un moment donné.
Régulièrement, le système d'exploitation va donc alterner les processus s'exécutant sur chaque processeur, afin que chaque processus ait régulièrement l'occasion d'exécuter des instructions.
L'abstraction processus nécessite donc :

 1. Un **mécanisme** permettant d'alterner un processus pour un autre sur un processeur. Ce mécanisme est appelé le :term:`changement de contexte`. Il consiste en deux phases : (1) la sauvegarde de l'état complet du processeur (valeurs des registres, prochaine instruction à exécuter, etc.) dans la mémoire et (2) la restauration de l'état tel que sauvegardé en mémoire pour l'autre processus, afin de remettre le processeur dans l'état exact où celui-ci se trouvait lors de sa précédente interruption.
 2. Une **politique** qui décide lesquels des processus disponibles pour l'exécution doivent se voir allouer un processeur ou quand un processus en cours d'exécution doit être interrompu. On appelle cette politique une :term:`politique d'ordonnancement` (scheduling en anglais).

Le mécanisme de :term:`changement de contexte` doit avoir un coût le plus faible possible, car son utilisation est un pur surcoût pour le système.
La définition de la politique adéquate, en revanche, est plus subtile car elle dépend des objectifs du système informatique considéré.
Par exemple, on peut vouloir un partage équitable du temps processeur entre les différents utilisateurs, ou au contraire privilégier des tâches par rapport à d'autres.
Pour certaines tâches, comme des simulations de modèles mathématiques, on cherchera à maximiser le *débit applicatif*, c'est à dire le nombre d'instructions utiles effectuées par seconde : on préfèrera alors le moins de changements de contexte possible.
Pour d'autres processus dits interactifs on cherchera à minimiser le temps d'attente entre la disponibilité du processus pour être exécuté et la mise à disposition d'un processeur : ici, au contraire, on voudra alterner les processus rapidement pour minimiser le temps d'attente.
Ce dernier cas est par exemple celui d'un jeu vidéo.
Sur la base de notre exemple de l'entrée/sortie clavier au début de cette introduction, on peut souhaiter minimiser le temps entre la réception de l'interruption depuis le contrôleur de périphérique clavier et le temps auquel le processus jeu peut prendre en compte la commande.

Au sein d'un même système, on peut avoir plusieurs politiques différentes fondées sur l'utilisation d'un mécanisme unique.

TODO étoffer le dernier point

Interaction entre les applications et le système d'exploitation
---------------------------------------------------------------

TODO comment l'os fournit ses services

TODO notion basique de user et kernel mode (pourquoi est-ce nécessaire) -- encart sur MS-DOS

TODO principe de trap et appel système sans les détails

.. spelling::

   API
   l'API
   Bell
   Laboratories
   AT&T
   Berkeley
   Labs
   Amsterdam
   d'Amsterdam
   raspberry
   pi
   nano

   
Unix
----

Unix est aujourd'hui un nom générique [#funix]_ correspondant à une famille de systèmes d'exploitation. La première version de Unix a été développée pour faciliter le traitement de documents sur mini-ordinateur.

.. topic:: Quelques variantes de Unix

 De nombreuses variantes de Unix ont été produites durant les quarante dernières années. Il est impossible de les décrire toutes, mais en voici quelques unes.

   - :term:`Unix`. Initialement développé aux AT&T Bell Laboratories, Unix a été ensuite développé par d'autres entreprises. C'est aujourd'hui une marque déposée par ``The Open group``, voir http://www.unix.org/
   - :term:`BSD Unix`. Les premières versions de Unix étaient librement distribuées par Bell Labs. Avec le temps, des variantes de Unix sont apparues. La variante développée par l'université de Berkeley en Californie a été historiquement importante car c'est dans cette variante que de nombreuses innovations ont été introduites dont notamment les piles de protocoles TCP/IP utilisés sur Internet. Aujourd'hui, :term:`FreeBSD` et :term:`OpenBSD` sont deux descendants de :term:`BSD Unix`. Ils sont largement utilisés dans de nombreux serveurs et systèmes embarqués. :term:`MacOS`, développé par Apple, s'appuie fortement sur un noyau et des utilitaires provenant de :term:`FreeBSD`.
   - :term:`Minix` est un système d'exploitation développé initialement par :term:`Andrew Tanenbaum` à l'université d'Amsterdam. :term:`Minix` est fréquemment utilisé pour l'apprentissage du fonctionnement des systèmes d'exploitation.
   - :term:`Linux` est un noyau de système d'exploitation largement inspiré de :term:`Unix` et `Minix`. Développé par :term:`Linus Torvalds` durant ses études d'informatique, il est devenu la variante de Unix la plus utilisée à travers le monde. Il est maintenant développé par des centaines de développeurs qui collaborent via Internet.
   - :term:`Solaris` est le nom commercial de la variante Unix de Oracle.

 Dans le cadre de ce cours, nous nous focaliserons sur le système :term:`GNU/Linux`, c'est-à-dire un système qui intègre le noyau :term:`Linux` et les librairies et utilitaires développés par le projet :term:`GNU` de la :term:`FSF`.

Un système Unix est composé de trois grands types de logiciels :

 - Le noyau du système d'exploitation qui est chargé automatiquement au démarrage de la machine et qui prend en charge toutes les interactions entre les logiciels et le matériel.
 - De nombreuses librairies qui facilitent l'écriture et le développement d'applications
 - De nombreux programmes utilitaires simples qui permettent de résoudre un grand nombre de problèmes courants. Certains de ces utilitaires sont chargés automatiquement lors du démarrage de la machine. La plupart sont exécutés uniquement à la demande des utilisateurs.
 
TODO mentionner que l'on verra la structure d'un OS dans le chapitre associé.

.. spelling::

   API
   programmatiques
   Application
   Programming
   Interface

Le rôle principal du noyau du système d'exploitation est de gérer les ressources matérielles (processeur, mémoire, dispositifs d'entrées/sorties et de stockage) de façon à ce qu'elles soient accessibles à toutes les applications qui s'exécutent sur le système. Gérer les ressources matérielles nécessite d'inclure dans le systèmes d'exploitation des interfaces programmatiques (`Application Programming Interfaces` en anglais - :term:`API`) qui facilitent leur utilisation par les applications. Les dispositifs de stockage sont une belle illustration de ce principe. Il existe de nombreux dispositifs de stockage (disque dur, clé USB, CD, DVD, mémoire flash, ...). Chacun de ces dispositifs a des caractéristiques électriques et mécaniques propres. Ils permettent en général la lecture et/ou l'écriture de blocs de données de quelques centaines d'octets. Nous reviendrons sur leur fonctionnement ultérieurement. Peu d'applications sont capables de piloter directement de tels dispositifs pour y lire ou y écrire de tels blocs de données. Par contre, la majorité des applications sont capables de les utiliser par l'intermédiaire du système de fichiers. Le système de fichiers (arborescence des fichiers) et l'API associée (`open(2)`_, `close(2)`_, `read(2)`_ `write(2)`_ ) sont un exemple des services fournis par le système d'exploitation aux applications. Le système de fichiers regroupe l'ensemble des fichiers qui sont accessibles depuis un système sous une arborescence unique, quel que soit le nombre de dispositifs de stockage utilisé. La racine de cette arborescence est le répertoire ``/`` par convention. Ce répertoire contient généralement une dizaine de sous répertoires dont les noms varient d'une variante de Unix à l'autre. Généralement, on retrouve dans la racine les sous-répertoires suivants :

 - ``/usr`` : sous-répertoire contenant la plupart des utilitaires et librairies installées sur le système
 - ``/bin`` et ``/sbin`` : sous-répertoire contenant quelques utilitaires de base nécessaires à l'administrateur du système
 - ``/tmp`` : sous-répertoire contenant des fichiers temporaires. Son contenu est généralement effacé au redémarrage du système.
 - ``/etc`` : sous-répertoire contenant les fichiers de configuration du système
 - ``/home`` : sous-répertoire contenant les répertoires personnels des utilisateurs du système
 - ``/dev`` : sous-répertoire contenant des fichiers spéciaux
 - ``/root``: sous-répertoire contenant des fichiers propres à l'administrateur système. Dans certains variantes de Unix, ces fichiers sont stockés dans le répertoire racine.

Un autre service est le partage de la mémoire et du processus. La plupart des systèmes d'exploitation supportent l'exécution simultanée de plusieurs applications. Pour ce faire, le système d'exploitation partage la mémoire disponible entre les différentes applications en cours d'exécution. Il est également responsable du partage du temps d'exécution sur le ou les processeurs de façon à ce que toutes les applications en cours puissent s'exécuter.

Unix s'appuie sur la notion de processus. Une application est composée de un ou plusieurs processus. Un processus peut être défini comme un ensemble cohérent d'instructions qui utilisent une partie de la mémoire et sont exécutées sur un des processeurs du système. L'exécution d'un processus est initiée par le système d'exploitation (généralement suite à une requête faite par un autre processus). Un processus peut s'exécuter pendant une fraction de secondes, quelques secondes ou des journées entières. Pendant son exécution, le processus peut potentiellement accéder aux différentes ressources (processeurs, mémoire, dispositifs d'entrées/sorties et de stockage) du système. A la fin de son exécution, le processus se termine [#ftermine]_ et libère les ressources qui lui ont été allouées par le système d'exploitation. Sous Unix, tout processus retourne au processus qui l'avait initié le résultat de son exécution qui est résumée en un nombre entier. Cette valeur de retour est utilisée en général pour déterminer si l'exécution d'un processus s'est déroulée correctement (zéro comme valeur de retour) ou non (valeur de retour différente de zéro).

Dans le cadre de ce cours, nous aurons l'occasion de voir en détails de nombreuses librairies d'un système Unix et verrons le fonctionnement d'appels systèmes qui permettent aux logiciels d'interagir directement avec le noyau. Le système Unix étant majoritairement écrit en langage C, ce langage est le langage de choix pour de nombreuses applications. Nous le verrons donc en détails.

Pour vous permettre de mettre vos apprentissages en pratique, vous recevrez durant le quadrimestre un `raspberry pi <https://www.raspberrypi.org/>`_. Il est possible d'installer différents systèmes d'exploitation sur celui-ci. Nous utiliserons `raspbian <https://www.raspberrypi.org/downloads/raspbian/>`_  qui est lui aussi une variante de Unix.

.. spelling::

   raspbian

.. rubric:: Footnotes

.. [#fexecbit] Sous Unix et contrairement à d'autres systèmes d'exploitation, le suffixe d'un nom de fichier ne joue pas de rôle particulier pour indiquer si un fichier contient un programme exécutable ou non. Comme nous le verrons ultérieurement, le système de fichiers Unix contient des bits de permission qui indiquent notamment si un fichier est exécutable ou non.
