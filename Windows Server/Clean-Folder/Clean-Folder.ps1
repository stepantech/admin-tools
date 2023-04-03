<#
.Synopsis
   Smaže soubory, které jsou starší než určitý počet dní
.DESCRIPTION
   Skript rekurzivně projde zadanou složku a odmaže soubory, které mají datum vytvoření starší než zadaný počet dní
.EXAMPLE
   Clean-Folder -Path C:\Temp -Days 30
.EXAMPLE
   Clean-Folder -Path C:\Temp -deleteEmptyFolders
#>

[CmdletBinding()]
[Alias()]
[OutputType([int])]
Param
(
    # Cesta ke složce, která se bude prohledávat
    [Parameter(Mandatory=$true,
                ValueFromPipelineByPropertyName=$true,
                Position=0)]
    $path,

    # Soubory starší než xy dní 
    [int]
    $days = 15,

    [switch]
    $deleteEmptyFolders = $false

)

$ErrorActionPreference = 'Stop' 

if(!(Test-Path $path)){
    Write-Error "Path doesn't exist"
}


$limit = (Get-Date).AddDays(-$days)


# Delete files older than the $limit.
Write-Host "Cleaning folder"
Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item

if($deleteEmptyFolders){
    # Delete any empty directories left behind after deleting the old files.
    Get-ChildItem -Path $path -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse
}
Write-Host "Finish"