# [CmdletBinding()]
# param (
#     [Parameter()]
#     [string]
#     $ProjectName
# )

$currentPath = Split-Path -Parent $MyInvocation.MyCommand.Definition 

$folders = @(".docker", ".infrastructure", ".k8s", ".scripts", ".tools",".services")
Write-Host "Creating directories.."
foreach ($folder in $folders) {
    # Write-Host "Creating directories at [$folder]..."
    mkdir "$currentPath\$folder"
    New-Item "$currentPath\$folder\.gitkeep"
    # Write-Host  "[$folder] was created successfully"
}
Write-Host  "Project was created successfully"

Write-Host "Start hacking to launch 🚀"