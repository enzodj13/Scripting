Script de Promotion Active Directory
Description

Ce script PowerShell automatise :

    L'installation du rôle Active Directory Domain Services (AD DS),

    La création d'un nouveau domaine (vazy.corp),

    La configuration du contrôleur de domaine et du serveur DNS.

Prérequis

    Exécuter le script en tant qu'administrateur.

    Le serveur doit disposer d'une IP statique.

    Le serveur ne doit pas être déjà joint à un domaine.

    Un redémarrage est automatique à la fin du processus.

Étapes du script

    Vérifie si le script est exécuté en tant qu'administrateur.

    Déclare les variables de domaine et mot de passe de mode DSRM.

    Installe le rôle Active Directory Domain Services avec les outils de gestion.

    Crée une nouvelle forêt Active Directory (vazy.corp).

    Configure le DNS intégré.

    Redémarre le serveur pour terminer l'installation.

Remarques

    Le mot de passe DSRM est codé en clair pour simplifier l'exemple (P@ssw0rd!) : modifiez-le avant utilisation en production.

    Le script force la promotion sans demander d'intervention utilisateur (-Force).

Exemple de lancement

.\ActiveDirectorycreation.ps1

Script de création d'UO, d'utilisateurs et de groupes Active Directory
Description

Ce script PowerShell permet d’automatiser :

    La création de 3 Unités d'Organisation (UO) : AIX, MARSEILLE, TOULON.

    La création de 3 utilisateurs (user.aix, user.marseille, user.toulon) dans leurs UO respectives.

    La création de 3 groupes de sécurité associés.

    L'ajout automatique de chaque utilisateur dans son groupe correspondant.

Prérequis

    Le module PowerShell ActiveDirectory doit être installé.

    Le script doit être exécuté sur un serveur ou poste membre du domaine vazy.corp avec des droits d'administration Active Directory.

Étapes du script

    Déclaration des variables :

        Domaine cible (vazy.corp),

        Liste des UO (AIX, MARSEILLE, TOULON),

        Mot de passe utilisateur par défaut.

    Création des Unités d'Organisation (UO) sous DC=vazy,DC=corp.

    Création des utilisateurs dans leurs UO respectives.

    Création des groupes de sécurité associés aux utilisateurs.

    Ajout des utilisateurs dans leurs groupes respectifs.

Exemple de lancement

.\Create-OU-Users-Groups.ps1

Remarques

    Le mot de passe des comptes est défini en clair (P@ssw0rd!) dans ce script. À modifier impérativement avant utilisation en production.

    Les objets sont créés sans protection contre la suppression accidentelle (-ProtectedFromAccidentalDeletion $false).


