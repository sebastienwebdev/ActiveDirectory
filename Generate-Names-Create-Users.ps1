# Edit these Variables for your own Use Case
$PASSWORD_FOR_USERS = "Password1"
$NUMBER_OF_ACCOUNTS_TO_CREATE = 10000

# Function to generate a random name
Function Generate-RandomName {
    $consonants = @('b','c','d','f','g','h','j','k','l','m','n','p','q','r','s','t','v','w','x','z')
    $vowels = @('a','e','i','o','u','y')
    $nameLength = Get-Random -Minimum 3 -Maximum 7
    $name = ""

    for ($i = 0; $i -lt $nameLength; $i++) {
        $index = Get-Random -Minimum 0 -Maximum ($consonants.Count + $vowels.Count - 1)
        if ($index -lt $consonants.Count) {
            $name += $consonants[$index]
        } else {
            $name += $vowels[$index - $consonants.Count]
        }
    }

    return $name
}

# Main loop to create user accounts
for ($count = 1; $count -lt $NUMBER_OF_ACCOUNTS_TO_CREATE; $count++) {
    $firstName = Generate-RandomName
    $lastName = Generate-RandomName
    $username = "$firstName.$lastName"
    $password = ConvertTo-SecureString $PASSWORD_FOR_USERS -AsPlainText -Force

    Write-Host "Creating user: $username" -BackgroundColor Black -ForegroundColor Cyan

    # Create new user account
    New-AdUser -AccountPassword $password `
               -GivenName $firstName `
               -Surname $lastName `
               -DisplayName $username `
               -Name $username `
               -EmployeeID $username `
               -PasswordNeverExpires $true `
               -Path "ou=_EMPLOYEES,$(([ADSI]'').distinguishedName)" `
               -Enabled $true
}
