# Easy to generate scripts https://winstall.app/

winget install --id=7zip.7zip -e
winget install --id=Adobe.Acrobat.Reader.64-bit -e
winget install --id=Microsoft.Office -e
winget install --id=VideoLAN.VLC -e
winget install --id=Microsoft.Teams -e
winget install --id=Zoom.Zoom -e

#TeamViewer QS
Invoke-WebRequest -URI https://download.teamviewer.com/QS -OutFile C:\Users\Public\Desktop\TeamViewer_QS.exe

#Lenovo specific
winget install --id=Lenovo.SystemUpdate  -e
