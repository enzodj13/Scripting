Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.DirectoryServices.AccountManagement

# Fenêtre principale
$form = New-Object System.Windows.Forms.Form
$form.Text = "Création d'utilisateur AD"
$form.Size = New-Object System.Drawing.Size(400,400)
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
$ouLabel.Text = "OU (ex: OU=AIX,DC=vazy,DC=corp) :"
$ouLabel.Location = New-Object System.Drawing.Point(10,100)
$form.Controls.Add($ouLabel)

$ouBox = New-Object System.Windows.Forms.TextBox
$ouBox.Location = New-Object System.Drawing.Point(10,120)
$ouBox.Width = 340
$form.Controls.Add($ouBox)

# Champ : Groupes (séparés par des virgules)
$groupLabel = New-Object System.Windows.Forms.Label
$groupLabel.Text = "Groupes (séparés par des virgules) :"
$groupLabel.Location = New-Object System.Drawing.Point(10,160)
$form.Controls.Add($groupLabel)

$groupBox = New-Object System.Windows.Forms.TextBox
$groupBox.Location = New-Object System.Drawing.Point(10,180)
$groupBox.Width = 340
$form.Controls.Add($groupBox)

# Bouton : Créer
$createButton = New-Object System.Windows.Forms.Button
$createButton.Text = "Créer l'utilisateur"
$createButton.Location = New-Object System.Drawing.Point(10,230)
$form.Controls.Add($createButton)

# Message de retour
$msgLabel = New-Object System.Windows.Forms.Label
$msgLabel.Location = New-Object System.Drawing.Point(10,270)
$msgLabel.Size = New-Object System.Drawing.Size(350,80)
$form.Controls.Add($msgLabel)

# Action bouton
$createButton.Add_Click({
    $username = $userBox.Text
    $password = $pwdBox.Text
    $ouPath = $ouBox.Text
    $groups = $groupBox.Text.Split(",") | ForEach-Object { $_.Trim() }

    Try {
        $securePwd = ConvertTo-SecureString $password -AsPlainText -Force
        New-ADUser -Name $username `
                   -SamAccountName $username `
                   -AccountPassword $securePwd `
                   -Enabled $true `
                   -Path $ouPath `
                   -ChangePasswordAtLogon $false

        foreach ($group in $groups) {
            Add-ADGroupMember -Identity $group -Members $username
        }

        $msgLabel.Text = "✅ Utilisateur $username créé et ajouté aux groupes."
    }
    Catch {
        $msgLabel.Text = "❌ Erreur : $($_.Exception.Message)"
    }
})

# Affiche le formulaire
[void]$form.ShowDialog()
