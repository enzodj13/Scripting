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

Second script : Createuser.ps1

🎯 Objectif

Ce script permet de créer facilement un utilisateur Active Directory via une interface graphique (WinForms).
Il prend en charge automatiquement :

    La création de l’utilisateur

    La création de l’Unité d’Organisation (OU) si elle n'existe pas

    La création des groupes (de sécurité, globaux) si nécessaires

    L’ajout de l’utilisateur aux groupes spécifiés

🧰 Prérequis

    Être exécuté en tant qu'administrateur PowerShell

    Avoir les modules ActiveDirectory installés (RSAT-AD-PowerShell)

    Avoir une connexion au contrôleur de domaine

    Le domaine utilisé est vazy.corp (modifiable dans le script)

🖥️ Fonctionnement de l'interface

L’interface vous propose de saisir les informations suivantes :
    Champ	            Description
    Nom d'utilisateur	Identifiant de connexion (SamAccountName)
    Mot de passe	    Mot de passe de l’utilisateur
    OU	                Unité d'organisation (ex : AIX, MARSEILLE)
    Groupes	            Liste de groupes à associer (séparés par des virgules)

🔧 Comportement automatique

Lors de la validation :

    ✅ Vérifie que tous les champs sont remplis

    ✅ Crée l'OU si elle n'existe pas (OU=...,DC=vazy,DC=corp)

    ✅ Crée l’utilisateur dans l’OU spécifiée

    ✅ Crée chaque groupe s’il n’existe pas dans la même OU

    ✅ Ajoute l’utilisateur à chaque groupe

🧪 Exemple d’utilisation

    Champ	            Valeur saisie
    Nom d'utilisateur	user.aix
    Mot de passe	    P@ssw0rd123
    OU	                AIX
    Groupes	            grp.aix,grp.users

👉 Résultat :

    Crée l’OU AIX si elle n’existe pas

    Crée l’utilisateur user.aix dans cette OU

    Crée les groupes grp.aix et grp.users si nécessaires

    Ajoute user.aix dans ces groupes

🛠️ Personnalisation

Pour modifier le domaine :

# Ligne à adapter dans le script :
$ouPath = "OU=$ouName,DC=vazy,DC=corp"

Pour créer des groupes dans une OU différente de l’utilisateur, il faudra adapter la logique du script.


