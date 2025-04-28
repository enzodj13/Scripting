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


