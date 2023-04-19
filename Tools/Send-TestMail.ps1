## Build the message parameters
$mailParams = @{
    SmtpServer                 = '127.0.0.1'
    Port                       = 25
    UseSSL                     = $false   
    From                       = 'from@email.cz'
    To                         = 'to@email.cz'
    Subject                    = ('ON-PREM SMTP Relay - ' + (Get-Date -Format g))
    Body                       = 'This is a test email using ON-PREM SMTP Relay'
    #Credential                 = (Get-Credential)
    #DeliveryNotificationOption = 'OnFailure', 'OnSuccess'
}
<# Send the message #>
Send-MailMessage @mailParams