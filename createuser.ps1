Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.DirectoryServices.AccountManagement

# Fenêtre principale
$form = New-Object System.Windows.Forms.Form
$form.Text = "Création d'utilisateur AD"
$form.Size = New-Object System.Drawing.Size(400,420)
$form.StartPosition = "CenterScreen"

# Champ : Nom d'utilisateur
$userLabel = New-Object System.Windows.Forms.Label
$userLabel.Text = "Nom d'utilisateur :"
$userLabel.Location = New-Object System.Drawing.Point(10,20)
$form.Controls.Add($userLabel)

$userBox = New-Object System.Windows.Forms.TextBox
$userBox.Location = New-Object System.Drawing.Point(150,20)
$userBox.Width = 200
$form.Controls.Add($userBox)

# Champ : Mot de passe
$pwdLabel = New-Object System.Windows.Forms.Label
$pwdLabel.Text = "Mot de passe :"
$pwdLabel.Location = New-Object System.Drawing.Point(10,60)
$form.Controls.Add($pwdLabel)

$pwdBox = New-Object System.Windows.Forms.TextBox
$pwdBox.Location = New-Object System.Drawing.Point(150,60)
$pwdBox.Width = 200
$pwdBox.UseSystemPasswordChar = $true
$form.Controls.Add($pwdBox)

# Champ : OU
$ouLabel = New-Object System.Windows.Forms.Label
$ouLabel.Text = "OU (ex: AIX) :"
$ouLabel.Location = New-Object System.Drawing.Point(10,100)
$form.Controls.Add($ouLabel)

$ouBox = New-Object System.Windows.Forms.TextBox
$ouBox.Location = New-Object System.Drawing.Point(150,100)
$ouBox.Width = 200
$form.Controls.Add($ouBox)

# Champ : Groupes
$groupLabel = New-Object System.Windows.Forms.Label
$groupLabel.Text = "Groupes (séparés par des virgules) :"
$groupLabel.Location = New-Object System.Drawing.Point(10,140)
$form.Controls.Add($groupLabel)

$groupBox = New-Object System.Windows.Forms.TextBox
$groupBox.Location = New-Object System.Drawing.Point(10,160)
$groupBox.Width = 340
$form.Controls.Add($groupBox)

# Bouton : Créer
$createButton = New-Object System.Windows.Forms.Button
$createButton.Text = "Créer l'utilisateur"
$createButton.Location = New-Object System.Drawing.Point(10,210)
$form.Controls.Add($createButton)

# Message de retour
$msgLabel = New-Object System.Windows.Forms.Label
$msgLabel.Location = New-Object System.Drawing.Point(10,260)
$msgLabel.Size = New-Object System.Drawing.Size(360,100)
$msgLabel.ForeColor = "Blue"
$form.Controls.Add($msgLabel)

# Action bouton
$createButton.Add_Click({
    $username = $userBox.Text.Trim()
    $password = $pwdBox.Text
    $ouName = $ouBox.Text.Trim()
    $groups = $groupBox.Text.Split(",") | ForEach-Object { $_.Trim() }

    Try {
        if (-not $username -or -not $password -or -not $ouName) {
            throw "Tous les champs obligatoires doivent être remplis."
        }

        $securePwd = ConvertTo-SecureString $password -AsPlainText -Force

        # Construction du chemin complet OU
        $ouPath = "OU=$ouName,DC=vazy,DC=corp"

        # Créer l'OU si elle n'existe pas
        if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$ouName'" -ErrorAction SilentlyContinue)) {
            New-ADOrganizationalUnit -Name $ouName -Path "DC=vazy,DC=corp" -ProtectedFromAccidentalDeletion $false
        }

        # Créer l'utilisateur
        New-ADUser -Name $username `
                   -SamAccountName $username `
                   -AccountPassword $securePwd `
                   -Enabled $true `
                   -Path $ouPath `
                   -ChangePasswordAtLogon $false

        # Créer et ajouter les groupes
        foreach ($group in $groups) {
            if (-not (Get-ADGroup -Filter "Name -eq '$group'" -ErrorAction SilentlyContinue)) {
                New-ADGroup -Name $group -SamAccountName $group -GroupScope Global -GroupCategory Security -Path $ouPath
            }

            Add-ADGroupMember -Identity $group -Members $username
        }

        $msgLabel.ForeColor = "Green"
        $msgLabel.Text = "✅ Utilisateur '$username' créé avec succès."
    }
    Catch {
        $msgLabel.ForeColor = "Red"
        $msgLabel.Text = "❌ Erreur : $($_.Exception.Message)"
    }
})

# Affiche le formulaire
[void]$form.ShowDialog()
