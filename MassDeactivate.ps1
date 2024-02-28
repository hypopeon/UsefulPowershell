Import-Module AzureAD --usewindowspowershell

$emailAddresses = @(
    "email1@tst.com", "email2@tst.com"
)

foreach ($email in $emailAddresses) {
    # Get the user by user principal name (UPN) which is usually the same as the email address
    $user = Get-AzureADUser -Filter "UserPrincipalName eq '$email'"

    if ($user) {
        # Disable the user account
        Set-AzureADUser -ObjectId $user.ObjectId -AccountEnabled $false

        # Output confirmation
        Write-Host "User $($user.UserPrincipalName) has been deactivated."
    } else {
        Write-Host "User with email address $email not found."
    }
}