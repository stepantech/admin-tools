# Define the input parameter for the CSV file path
param (
    [Parameter(Mandatory=$true)]
    [string]$CsvFilePath
)

# Import the CSV file data
$CsvData = Import-Csv -Path $CsvFilePath -Delimiter ";" -Encoding UTF8

# Loop through each row in the CSV data and create a new Active Directory user for each row
foreach ($Row in $CsvData) {
    # Extract the necessary data from the current row
    $param = @{
    Name = $Row.displayName
    DisplayName = $Row.displayName
    AccountPassword = (ConvertTo-SecureString $Row.Password -AsPlainText -Force)
    GivenName = $Row.givenName
    Surname = $Row.surname
    Path = "OU=Users,OU=$($Row.usageLocation),OU=IOPARTNERS,DC=iopartners,DC=com"
    UserPrincipalName = $Row.userPrincipalName
    City = $Row.City
    Enabled = $true
    }

    if($Row.mail) {
        $param.Add("EmailAddress", $Row.mail)
    }

    if($Row.jobTitle) {
        $param.Add("title", $Row.jobTitle)
    }

    if($Row.mobilePhone) {
        $param.Add("MobilePhone", $Row.mobilePhone)
    }
    # Create a new Active Directory user with the extracted data
    Write-Host "Creating user ... $($Row.userPrincipalName):" -NoNewline 
    $NewUser = New-ADUser @param

    Write-Host "   done" -ForegroundColor Green
}