# Edit these Variables for your own Use Case
$PASSWORD_FOR_USERS = "Password1"
$USER_FIRST_LAST_LIST = Get-Content .\names.txt

# Convert the password to a secure string
$password = ConvertTo-SecureString $PASSWORD_FOR_USERS -AsPlainText -Force

# Create the organizational unit if it doesn't exist
New-ADOrganizationalUnit -Name "_USERS" -ProtectedFromAccidentalDeletion $false -ErrorAction SilentlyContinue

# Loop through each name in the list
foreach ($name in $USER_FIRST_LAST_LIST) {
    # Extract first and last name
    $first, $last = $name.Split(" ")

    # Construct the username
    $username = "$($first.Substring(0,1))$($last)".ToLower()

    # Display message for user creation
    Write-Host "Creating user: $username" -BackgroundColor Black -ForegroundColor Cyan

    # Create the new user account
    New-AdUser -AccountPassword $password `
               -GivenName $first `
               -Surname $last `
               -DisplayName $username `
               -Name $username `
               -EmployeeID $username `
               -PasswordNeverExpires $true `
               -Path "ou=_USERS,$(([ADSI]'').distinguishedName)" `
               -Enabled $true
}
