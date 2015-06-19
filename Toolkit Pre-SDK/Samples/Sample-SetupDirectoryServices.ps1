#
# Requires Pure Storage PowerShell Toolkit v2.8.0.430
#

# Import PowerShell Modules
Import-Module PureStoragePowerShell

# Set FlashArray variable.
$FlashArray = "?"

# Set Directory Object parameters.
$DirectoryObj = @{
    LdapUri = ldap://X.X.X.X
    BaseDN = "DC=?,DC=?,DC=?"
    GroupBase = "OU=?"
    ArrayAdminGroup = "Pure_Storage_Admins"
    StorageAdminGroup = "Pure_Storage_Readers"
    ReadOnlyGroup = "Pure_Storage_Users"
    BindUser = "?"
    BindPassword = "?"
}

# Connect to the Pure Storage FlashArray.
$FA = Get-PfaApiToken -FlashArray $FlashArray -Credential (Get-Credential) | Connect-PfaController -HttpTimeOut 10000

# Update the FlashArray Directory Services.
Update-PfaDirectoryService `
    -LdapUri $DirectoryObj.LdapUri `
    -BaseDN $DirectoryObj.BaseDN `
    -GroupBase $DirectoryObj.GroupBase `
    -ArrayAdminGroup $DirectoryObj.ArrayAdminGroup `
    -StorageAdminGroup $DirectoryObj.StorageAdminGroup `
    -ReadOnlyGroup $DirectoryObj.ReadOnlyGroup `
    -BindUser $DirectoryObj.BindUser `
    -BindPassword $DirectoryObj.BindPassword `
    -Session $FA

# Query the updated Directory Service information.
Get-PfaDirectoryService -Session $FA

# Test that the Directory Service settings work.
Test-PfaDirectoryService -Session $FA
