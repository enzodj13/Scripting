#Crée 3 UO : AIX, MARSEILLE, TOULON
#Crée 3 utilisateurs : user.aix, user.marseille, user.toulon dans leurs UO respectives
#Crée 3 groupes de sécurité : user.aix, user.marseille, user.toulon
#Ajoute chaque utilisateur dans son groupe correspondant

# Variables
$domain = "vazy.corp"
$ouList = @("AIX", "MARSEILLE", "TOULON")
$defaultPassword = ConvertTo-SecureString "P@ssw0rd!" -AsPlainText -Force  # à changer si besoin

# Crée les UO
foreach ($ouName in $ouList) {
    $ouPath = "OU=$ouName,DC=vazy,DC=corp"
    Write-Host "Création de l'OU $ouName..." -ForegroundColor Cyan
    New-ADOrganizationalUnit -Name $ouName -Path "DC=vazy,DC=corp" -ProtectedFromAccidentalDeletion $false
}

# Crée les utilisateurs et les groupes
foreach ($ouName in $ouList) {
    $username = "user." + $ouName.ToLower()
    $ouPath = "OU=$ouName,DC=vazy,DC=corp"

    # Créer l'utilisateur
    Write-Host "Création de l'utilisateur $username dans l'OU $ouName..." -ForegroundColor Cyan
    New-ADUser -Name $username `
               -SamAccountName $username `
               -AccountPassword $defaultPassword `
               -Enabled $true `
               -Path $ouPath `
               -ChangePasswordAtLogon $false

    # Créer le groupe
    Write-Host "Création du groupe de sécurité $username..." -ForegroundColor Cyan
    New-ADGroup -Name $username `
                -SamAccountName $username `
                -GroupScope Global `
                -GroupCategory Security `
                -Path $ouPath

    # Ajouter l'utilisateur au groupe
    Write-Host "Ajout de $username au groupe $username..." -ForegroundColor Cyan
    Add-ADGroupMember -Identity $username -Members $username
}
