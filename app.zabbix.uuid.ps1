<#PSScriptInfo
.VERSION      0.1.0
.GUID         ec9c2e11-0038-4333-a214-5fb0e5e6ecf0
.AUTHOR       Kai Kimera
.AUTHOREMAIL  mail@kai.kim
.TAGS         zabbix template pwsh uuid
.LICENSEURI   https://choosealicense.com/licenses/mit/
.PROJECTURI   https://lib.onl
#>

<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE
.\app.zabbix.uuid.ps1

.LINK
https://lib.onl
#>

# -------------------------------------------------------------------------------------------------------------------- #
# -----------------------------------------------------< SCRIPT >----------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

function New-UUID {
  return [guid]::NewGuid().ToString('N')
}

function Set-UUID {
  $DataDir = "${PSScriptRoot}\_DATA"
  if (-not (Test-Path "${DataDir}")) { New-Item -ItemType 'Directory' -Path "${DataDir}" }

  Get-ChildItem "${PSScriptRoot}" -Filter "*.yaml" | ForEach-Object {
    $Content = (Get-Content "$($_.FullName)" -Raw)
    $Pattern = '(?<=uuid:\s)[0-9a-f]{32}'

    $NewContent = [regex]::Replace($Content, $Pattern, {Param($match) New-UUID})
    $NewContent | Set-Content "${DataDir}\$($_.Name)" -NoNewline

    Write-Host "UUIDs successfully replaced in file '$($_.Name)'!"
  }
}

function Start-Script() {
  Set-UUID
}; Start-Script
