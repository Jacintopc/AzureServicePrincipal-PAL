# Requisitos (si no están instalados)

# Install-Module -Name Az -AllowClobber -Scope CurrentUser
# Install-Module -Name Az.ManagementPartner

# The main variables for this PS are TenantID and Service Principal name

$tenantId = "<tu-tenant-id>"
$appId    = "<client-id-del-service-principal-SWONE>"
$secret   = "<client-secret-del-service-principal-SWONE>"

# $MPNId = 4509925 # Crayon MPN ID
$MPNId = 3124318 # SoftwareONE MPN ID

# Convertir el secreto en SecureString
$secureSecret = ConvertTo-SecureString $secret -AsPlainText -Force

# Crear el objeto de credenciales
$credentials = New-Object System.Management.Automation.PSCredential($appId, $secureSecret)

Connect-AzAccount -ServicePrincipal -Credential $credentials -Tenant $tenantId

# Link to the SWONE Partner ID. The partner ID is the Microsoft Partner Network (MPN) ID for SWONE.

$pal = Get-AzManagementPartner
if ($pal) {
    Remove-AzManagementPartner -PartnerId $pal.PartnerId -PassThru -Confirm:$false
}
Remove-AzManagementPartner -PartnerId $(Get-AzManagementPartner).PartnerId -PassThru -Confirm:$false
new-AzManagementPartner -PartnerId $MPNId

# Get-AzManagementPartner: obtiene el MPN Id y demás información del Management Partner asociado al usuario o entidad de servicio autenticada en ese momento.
Get-AzManagementPartner

# Logout of the current account
Disconnect-AzAccount
