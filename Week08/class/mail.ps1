#Storyline: Send an email.

# Body of the email
$msg = "Hello there."

#echoing to the screen
write-host -BackgroundColor Red -ForegroundColor white $msg

# Email From Address
$email = "meckhardt14@yahoo.com"

# To address
$toEmail = "deployer@csi-web"

#Sending the email
Send-MailMessage -From $email -to $toEmail -Subject "A Greeting" -body $msg -SmtpServer 192.168.6.71