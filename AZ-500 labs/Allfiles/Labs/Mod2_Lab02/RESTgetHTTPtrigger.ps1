# Replace this with yours ;)
$functionappname = ""
$functionname = "HttpTriggerPowerShell1"
$functionkey = ""

$YourURI = "https://$functionappname.azurewebsites.net/api/$functionname`?code=$functionkey"

# Try a normal GET

Write-host " This is result of  a normal GET operation calling your HTTP trigger" -ForegroundColor Yellow

Invoke-RestMethod -Method Get -Uri $YourURI

Write-host " This is result of  a normal GET operation calling your HTTP trigger with an extra parameter passed to the trigger" -ForegroundColor Yellow
# GET using the "name" query parameter
Invoke-RestMethod -Method Get -Uri "$($YourURI)&name=World!"


Write-host " This is result of a normal PUT operation calling your HTTP trigger that feeds a hash table converted to JSON to the HTTP triggger" -ForegroundColor Yellow

# Use the POST method provided
$Body = @{name = 'Max Power'} | ConvertTo-Json
Invoke-RestMethod -Method Post -Body $Body -Uri $YourURI