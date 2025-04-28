
#Prérequis
#Le script doit être exécuté en tant qu’administrateur.
#Le serveur doit avoir une adresse IP statique configurée.
#Le serveur ne doit pas déjà faire partie d’un domaine.
#Un redémarrage sera nécessaire à la fin du script.

# Vérifie si le script est lancé en admin
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "Ce script doit être exécuté en tant qu'administrateur."
    Exit
}

# Variables
$domainName = "vazy.corp"
$safeModePwd = ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force  # À modifier selon votre politique de mot de passe

# Installation du rôle AD DS
Write-Host "Installation du rôle AD DS..." -ForegroundColor Cyan
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Promotion du serveur en tant que DC avec un nouveau domaine
Write-Host "Configuration du contrôleur de domaine pour $domainName..." -ForegroundColor Cyan
Install-ADDSForest `
    -DomainName $domainName `
    -DomainNetbiosName "VAZY" `
    -SafeModeAdministratorPassword $safeModePwd `
    -InstallDNS `
    -Force

# Le serveur va redémarrer automatiquement à la fin de l'installation
