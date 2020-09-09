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

Les systèmes informatiques sont partout dans notre quotidien : de notre téléphone portable à notre montre connectée, de notre ordinateur de bureau  aux très nombreux *serveurs* supportant les services internet que nous utilisons quotidiennement. De nombreux objets du quotidien sont eux-aussi des systèmes informatiques : on assiste ainsi à une explosion du nombre d'objets connectés (par exemple, des ampoules programmables ou des hauts-parleurs interactifs) et nombreux sont les objets qui intègrent désormais un ordinateur, comme les voitures ou les appareils électroménagers.

Malgré la diversité de leurs usages, tous ces appareils ont en commun des principes fondamentaux de fonctionnement de d'organisation. Un système informatique intègre toujours au moins un :term:`processeur` (:term:`CPU` en anglais), une mémoire, et un ou des dispositifs d'entrée/sortie lui permettant d'interagir avec son environnement.

Le :term:`CPU` est un circuit électronique réalisant très rapidement des opérations simples :

 - lire de l'information en mémoire;
 - écrire de l'information en mémoire;
 - effectuer des calculs.

Les opérations effectuées par le :term:`processeur` sont mises en œuvre directement de manière électronique. On parle d'*instructions*. Le jeu d'instruction d'un :term:`processeur` dépend de son modèle. Par exemple, les ordinateurs Apple et les PCs récents utilisent des processeurs Intel ou AMD permettant d'exécuter le jeu d'instruction ``x86_64``. Dans un futur proche, les ordinateurs Apple utiliseront un CPU mettant en œuvre le jeu d'instruction ``ARM A64``, le même que celui supporté par le processeur du nano-ordinateur RaspberryPI.

La très grande majorité des processeurs adoptent les principes de l'architecture dite de Von Neumann, du nom du pionnier de l'informatique Jon von Neumann qui l'a proposé. Suivant cette architecture, un ordinateur est composé d'un :term:`processeur` qui exécute un programme lu depuis la mémoire. Cette même mémoire est aussi utilisée pour lire les données d'entrée et stocker les résultats des calculs et opérations effectuées par le processeur.

Représentation de l'information
-------------------------------

Un processeur manipule l'information sous forme binaire. L'élément de base pour stocker et représenter de l'information dans un système informatique est donc le :term:`bit`. Un bit (`binary digit` en anglais) peut prendre deux valeurs qui par convention sont représentées par :

 - ``1``
 - ``0``

Physiquement, un bit est représenté sous la forme d'un signal électrique ou optique lorsqu'il est transmis et d'une charge électrique ou sous forme physique (par exemple, magnétique) lorsqu'il est stocké. Nous n'aborderons pas ces détails technologiques dans le cadre de ce cours. Ils font l'objet de nombreux cours d'électronique.

Le bit est l'unité de base de stockage et de transfert de l'information. En général, les systèmes informatiques ne traitent pas des bits individuellement, mais par blocs. On appelle un un :term:`nibble` est un bloc de 4 bits consécutifs tandis qu'un :term:`octet` (ou :term:`byte` en anglais) est un bloc de 8 bits consécutifs. On parlera de mots (`word` en anglais) pour des groupes comprenant généralement 32 bits et de long mot pour des groupes de 64 bits.

Suivant l'architecture de Von Neumann, les données tout comme les instructions à exécuter par le processeur sont stockées sous forme binaire dans la mémoire. Le processeur va donc lire la prochaine instruction à exécuter sous forme d'un groupe de bits, la déchiffrer, et appliquer l'effet prévu pour l'instruction correspondante, avant de recommencer. L'identité de l'instruction à exécuter est déterminée en décodant les premiers bits de l'instruction; le reste contenant les arguments de l'instruction.

Certaines instructions ont pour objectif de déterminer la prochaine instruction à lire, décoder et exécuter. Ces instructions de contrôle de flux permettent de mettre en œuvre les conditionnelles, boucles, etc.

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

TODO expliquer les device controller (in charge of a particular device, with their own buffer memory)

TODO expliquer que les I/O et l'exécution des instructions se font en parallèle; when data is available (e.g. keystroke) CPU needs to copy data to/from 

TODO expliquer le principe des interruptions + expliquer le principe des trap (?)

TODO mentionner le principe de DMA en donnant une ref wiki ?

Rôle du système d'exploitation
------------------------------

TODO expliquer qu'une utilisation directe (un seul programme, incluant les routines permettant de traiter les interruptions et les entrées/sorties) est très compliqué, donner un peu d'historique (premiers OS dès le milieu des années 60).

TODO 





 

Les systèmes informatiques peuvent prendre différentes formes, allant de minuscules systèmes embarqués à de gigantesques supercalculateurs.
Les :term:`raspberry pi` sont un exemple d'un système embarqué. Il s'agit de nano-ordinateurs, de la taille d'une carte de crédit.
Possédant les mêmes composants que décrits ci-dessus, ils fonctionnent de la même façon que des systèmes plus imposants comme les ordinateurs personnels que l'on utilise au quotidien, seulement avec moins de ressources.

TODO mentionner plus d'exemples de systèmes (systèmes embarqués, clouds, etc.)

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

Système d'exploitation
----------------------

TODO Expliquer le rôle en général d'un OS et les fonctions fondamentales (isolation, virtualisation/partage de ressources, sécurité) en suivant la terminologie du bouquin des Arpaci-Dusseau

TODO mentionner des exemples de systèmes génériques et spécialisés.
   
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
