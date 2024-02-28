# Import the Active Directory module
Import-Module ActiveDirectory

# Define the OU's distinguished name where you want to perform the operations
$ouDistinguishedName = "<ou path>"

# Define an array of email addresses
$emailAddresses = @(
    "email1@test.com", "email2@test.com"
)

# Loop through each email address
foreach ($email in $emailAddresses) {
    # Get the user account based on email address within the specified OU
    $user = Get-ADUser -Filter {EmailAddress -eq $email} -SearchBase $ouDistinguishedName

    if ($user) {
        # Disable the user account
        Disable-ADAccount -Identity $user -Confirm:$false
        
        # Add a comment to the user account
        Set-ADUser -Identity $user -Description "Comment" -Verbose
    } else {
        Write-Host "User with email address $email not found in the specified OU."
    }
}