Connect-MgGraph

$emailAddresses = @(
    "email1@test.com", "email2@test.com"
)

$lusers = @()

foreach ($email in $emailAddresses) {
    # Check if $email is not empty
    if ($email -ne $null) {
        try {
            # Use Get-MgUser with the -Filter parameter to retrieve users by email address
            $users = Get-MgUser -Filter "mail eq '$email'" -Select UserPrincipalName,DisplayName,AssignedLicenses
            if ($users) {
                # Add the retrieved user objects to the collection
                $lusers += $users
            }
        } catch {
            Write-Host "Error occurred while fetching user with email ${email}: $_"
        }
    }
}

foreach ($user in $lusers) {
    Write-Verbose "Processing licenses for user $($user.UserPrincipalName)"
    try { $user = Get-MgUser -UserId $user.UserPrincipalName -ErrorAction Stop }
    catch { Write-Verbose "User $($user.UserPrincipalName) not found, skipping..." ; continue }
 
    $SKUs = @(Get-MgUserLicenseDetail -UserId $user.id)
    if (!$SKUs) { Write-Verbose "No Licenses found for user $($user.UserPrincipalName), skipping..." ; continue }
 

    foreach ($SKU in $SKUs) {
        Write-Verbose "Removing license $($SKU.SkuPartNumber) from user $($user.UserPrincipalName)"
        try {
            Set-MgUserLicense -UserId $user.id -AddLicenses @() -RemoveLicenses $Sku.SkuId -ErrorAction Stop #-WhatIf
        }
        catch {
            if ($_.Exception.Message -eq "User license is inherited from a group membership and it cannot be removed directly from the user.") {
                Write-Verbose "License $($SKU.SkuPartNumber) is assigned via the group-based licensing feature, either remove the user from the group or unassign the group license, as needed."
                continue
            }
            else {$_ | fl * -Force; continue} #catch-all for any unhandled errors
    }}
}