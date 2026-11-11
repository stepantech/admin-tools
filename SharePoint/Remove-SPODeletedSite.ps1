<#
.SYNOPSIS
    Permanently removes a SharePoint Online site from the deleted sites list.

.DESCRIPTION
    Connects to the SharePoint Online admin center and permanently removes
    either one specified site or all sites in the deleted sites list. This
    action is irreversible. Requires the SharePoint Online Management Shell
    module and an account with sufficient SharePoint administrator rights.

.PARAMETER AdminUrl
    URL of the SharePoint Online admin center, for example
    https://contoso-admin.sharepoint.com.

.PARAMETER SiteUrl
    Exact URL of the deleted site to permanently remove.

.PARAMETER All
    Permanently removes every site in the deleted sites list. Use -WhatIf
    first to review the targets.

.EXAMPLE
    PS> .\Remove-SPODeletedSite.ps1 -AdminUrl 'https://contoso-admin.sharepoint.com' -SiteUrl 'https://contoso.sharepoint.com/sites/oldsite'
    Connects to the admin center and prompts before permanently removing the site.

.EXAMPLE
    PS> .\Remove-SPODeletedSite.ps1 -AdminUrl 'https://contoso-admin.sharepoint.com' -SiteUrl 'https://contoso.sharepoint.com/sites/oldsite' -WhatIf
    Shows what would be removed without making changes.

.EXAMPLE
    PS> .\Remove-SPODeletedSite.ps1 -AdminUrl 'https://contoso-admin.sharepoint.com' -All -WhatIf
    Shows all sites in the deleted sites list that would be permanently removed.

.NOTES
    Author:   Petr Štěpán
    Created:  2026-11-11
    Version:  1.1.0
    Encoding: UTF-8 with BOM (required for the author name).
    Changelog:
        1.1.0 - Add support for removing all deleted sites
        1.0.0 - Initial version
#>

#Requires -Version 5.1
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High', DefaultParameterSetName = 'Single')]
param(
    [Parameter(Mandatory = $true, HelpMessage = 'SharePoint Online admin center URL.')]
    [ValidateNotNullOrEmpty()]
    [uri]
    $AdminUrl,

    [Parameter(Mandatory = $true, ParameterSetName = 'Single', HelpMessage = 'Exact URL of the deleted site to remove.')]
    [ValidateNotNullOrEmpty()]
    [uri]
    $SiteUrl,

    [Parameter(Mandatory = $true, ParameterSetName = 'All', HelpMessage = 'Permanently remove every site in the deleted sites list.')]
    [switch]
    $All
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

try {
    if (-not (Get-Module -ListAvailable -Name Microsoft.Online.SharePoint.PowerShell)) {
        throw "Required module Microsoft.Online.SharePoint.PowerShell is not installed. Install it with: Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Scope CurrentUser"
    }

    Import-Module -Name Microsoft.Online.SharePoint.PowerShell -ErrorAction Stop

    if ($AdminUrl.Scheme -ne 'https') {
        throw 'AdminUrl must use HTTPS.'
    }

    if ($PSCmdlet.ParameterSetName -eq 'Single' -and $SiteUrl.Scheme -ne 'https') {
        throw 'SiteUrl must use HTTPS.'
    }

    Connect-SPOService -Url $AdminUrl.AbsoluteUri -ErrorAction Stop

    if ($PSCmdlet.ParameterSetName -eq 'All') {
        $deletedSites = @(Get-SPODeletedSite -Limit All -ErrorAction Stop)
        if ($deletedSites.Count -eq 0) {
            Write-Warning 'No sites were found in the deleted sites list.'
        }
    }
    else {
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
    }

    foreach ($deletedSite in $deletedSites) {
        if ($PSCmdlet.ShouldProcess($deletedSite.Url, 'Permanently remove deleted SharePoint site')) {
            Remove-SPODeletedSite -Identity $deletedSite.Url -Confirm:$false -ErrorAction Stop
            Write-Verbose "Permanently removed '$($deletedSite.Url)' from the deleted sites list."
        }
    }
}
catch {
    Write-Error -Message "Script failed: $_" -ErrorAction Continue
    exit 1
}

exit 0