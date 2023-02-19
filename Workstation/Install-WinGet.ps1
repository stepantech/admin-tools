# get latest download url
$URL = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
$URL = (Invoke-WebRequest -Uri $URL).Content | ConvertFrom-Json |
        Select-Object -ExpandProperty "assets" |
        Where-Object "browser_download_url" -Match '.msixbundle' |
        Select-Object -ExpandProperty "browser_download_url"

# download
Invoke-WebRequest -Uri $URL -OutFile "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -UseBasicParsing

# install
Add-AppxPackage -Path "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"

# delete file
Remove-Item "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
