$resourceGroup = "XXX"
$frontDoorName = "YYY"
$endpointHost = "frontdoor-XXX-YYY-1"

# Get the front door object
Get-AzFrontDoorCdnProfile  -ResourceGroupName $resourceGroup -Name $frontDoorName

# Get the endpoint object
$endpoint = Get-AzFrontDoorCdnEndpoint -ProfileName $frontDoorName -ResourceGroupName $resourceGroup -EndpointName $endpointHost

# Get the routes in endpoint
$route = Get-AzFrontDoorCdnRoute -ProfileName $frontDoorName  -ResourceGroupName $resourceGroup -EndpointName $endpointHost

# Get the custom domains associated with the endpoint
$customDomains= Get-AzFrontDoorCdnCustomDomain -ProfileName $frontDoorName  -ResourceGroupName $resourceGroup | Where-Object {$_.ProvisioningState  -eq "Succeeded" -and $_.Id -in $route.CustomDomain.id}

# List the custom domains
$customDomains.HostName
