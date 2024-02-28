Import-Module MSOnline -UseWindowsPowershell
Connect-MsolService
Get-MsolAccountSku
	
Get-MsolUser | Where-Object {($_.licenses).AccountSkuId}