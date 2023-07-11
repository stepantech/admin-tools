# Configurace logování do Event logu

## Výpis aktuálního stavu
```
auditpol /get /subcategory:”Network Policy Server”
```

## Zapnutí logování úspěšných a neúspěšných požadavků
```
auditpol /set /subcategory:”Network Policy Server” /success:enable /failure:enable
```