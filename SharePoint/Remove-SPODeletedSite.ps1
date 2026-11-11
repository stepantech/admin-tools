<#
.SYNOPSIS
    Permanently removes a SharePoint Online site from the deleted sites list.

.DESCRIPTION
    Connects to the SharePoint Online admin center, verifies that the exact
    site URL is in the deleted sites list, and permanently removes it. This
    action is irreversible. Requires the SharePoint Online Management Shell
    module and an account with sufficient SharePoint administrator rights.

.PARAMETER AdminUrl
    URL of the SharePoint Online admin center, for example
    https://contoso-admin.sharepoint.com.

.PARAMETER SiteUrl
    Exact URL of the deleted site to permanently remove.

.EXAMPLE
    PS> .\Remove-SPODeletedSite.ps1 -AdminUrl 'https://contoso-admin.sharepoint.com' -SiteUrl 'https://contoso.sharepoint.com/sites/oldsite'
    Connects to the admin center and prompts before permanently removing the site.

.EXAMPLE
    PS> .\Remove-SPODeletedSite.ps1 -AdminUrl 'https://contoso-admin.sharepoint.com' -SiteUrl 'https://contoso.sharepoint.com/sites/oldsite' -WhatIf
    Shows what would be removed without making changes.

.NOTES
    Author:   Petr Štěpán
    Created:  2026-11-11
    Version:  1.0.0
    Encoding: UTF-8 with BOM (required for the author name).
    Changelog:
        1.0.0 - Initial version
#>

#Requires -Version 5.1
#Requires -Modules Microsoft.Online.SharePoint.PowerShell
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
param(
    [Parameter(Mandatory = $true, HelpMessage = 'SharePoint Online admin center URL.')]
    [ValidateNotNullOrEmpty()]
    [uri]
    $AdminUrl,

    [Parameter(Mandatory = $true, HelpMessage = 'Exact URL of the deleted site to remove.')]
    [ValidateNotNullOrEmpty()]
    [uri]
    $SiteUrl
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

try {
    if ($AdminUrl.Scheme -ne 'https' -or $SiteUrl.Scheme -ne 'https') {
        throw 'AdminUrl and SiteUrl must use HTTPS.'
    }

    Connect-SPOService -Url $AdminUrl.AbsoluteUri -ErrorAction Stop

    $deletedSites = @(Get-SPODeletedSite -Identity $SiteUrl.AbsoluteUri -ErrorAction Stop)
    if ($deletedSites.Count -ne 1) {
        throw "Expected one deleted site for '$SiteUrl', but found $($deletedSites.Count)."
    }

    $deletedSite = $deletedSites[0]
    $requestedUrl = $SiteUrl.AbsoluteUri.TrimEnd('/')
    $foundUrl = ([uri]$deletedSite.Url).AbsoluteUri.TrimEnd('/')
    if (-not [string]::Equals($requestedUrl, $foundUrl, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "The returned deleted site URL '$($deletedSite.Url)' does not match '$SiteUrl'."
    }

    if ($PSCmdlet.ShouldProcess($deletedSite.Url, 'Permanently remove deleted SharePoint site')) {
        Remove-SPODeletedSite -Identity $deletedSite.Url -Confirm:$false -ErrorAction Stop
        Write-Verbose "Permanently removed '$($deletedSite.Url)' from the deleted sites list."
    }
}
catch {
    Write-Error -Message "Script failed: $_" -ErrorAction Continue
    exit 1
}

exit 0