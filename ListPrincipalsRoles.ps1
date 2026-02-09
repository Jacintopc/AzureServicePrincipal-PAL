# Update to ListPrincipalsRoles.ps1

# This script retrieves Azure service principals and their roles and now has CSV export functionality while keeping the screen output.

# Function to export to CSV
function Export-ServicePrincipalsToCSV {
    param(
        [string]$outputPath
    )

    $data = Get-ServicePrincipalsRoles | Select-Object -Property DisplayName, AppId, Roles
    $data | Export-Csv -Path $outputPath -NoTypeInformation
    Write-Host "Data exported to CSV at $outputPath"
}

# Main Function
function Get-ServicePrincipalsRoles {
    # Logic to retrieve service principals and roles
    # This is a placeholder for the actual implementation
}

# Existing code to display output on screen
Get-ServicePrincipalsRoles | Format-Table -AutoSize

# Call the CSV export function
Export-ServicePrincipalsToCSV -outputPath 'ServicePrincipalsRoles.csv'