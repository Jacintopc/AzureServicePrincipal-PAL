# Prerequisites:  Install jq from https://jqlang.org/
# jq is like sed for JSON data - you can use it to slice and filter and map and transform structured data with the same ease that sed, awk, grep and friends let you play with text.

$ts   = Get-Date -Format "yyyyMMdd_HHmmss"
$out  = "informe_$ts.md"

az role assignment list --all `
| jq '[.[] | select((.roleDefinitionName == "Owner" or .roleDefinitionName == "Contributor") and (.scope | contains("/resourceGroups/") | not)) | {Principal: .principalName, Tipo: .principalType, Rol: .roleDefinitionName, Scope: .scope}]' `
| ConvertFrom-Json `
| Format-Table -AutoSize -GroupBy Principal `
| Out-String `
| Set-Content -Path $out -Encoding UTF8

Write-Host "Informe generado: $out"
