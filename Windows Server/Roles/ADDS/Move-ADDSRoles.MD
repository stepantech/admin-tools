# Přesun FSMO rolí z jednoho DC na druhé

## Výpis držitele domain rolí
```powershell
Get-ADDomain | select InfrastructureMaster, PDCEmulator, RIDMaster
```

## Výpis držitele forest rolí
```powershell
Get-ADForest | select DomainNamingMaster, SchemaMaster
```

## Transfer FSMO rolí na nové DC

```powershell
$newDCname = "<název nového DC>"

#Transfer PDCEmulator
Move-ADDirectoryServerOperationMasterRole -Identity $newDCname PDCEmulator -Confirm:$false

#Transfer RIDMaster
Move-ADDirectoryServerOperationMasterRole -Identity $newDCname RIDMaster -Confirm:$false

#Transfer InfrastrctureMaster
Move-ADDirectoryServerOperationMasterRole -Identity $newDCname Infrastructuremaster -Confirm:$false

#Transfer DomainNamingMaster
Move-ADDirectoryServerOperationMasterRole -Identity $newDCname DomainNamingmaster -Confirm:$false

#Transfer SchemaMaster
Move-ADDirectoryServerOperationMasterRole -Identity $newDCname SchemaMaster -Confirm:$false

```