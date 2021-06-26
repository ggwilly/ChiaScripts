param (
	 $body = $(throw "parametro requerido.")
	,$subject = $(throw "parametro requerido.")
	,$time
)

#-- Parametros SMPT -------------------------#
$from        = "sender@yourdomain.com"
$to          = "recipient1@domain.com", "recipient2@domain.com"
#$Cc         = "boss@domain.com"
#$Attachment = "C:\temp\attach.txt"
#$subject     = "CHIA resumen proceso - ejecutado: ${time}"
$SMTPServer  = "mail.yourdomain.com"
$SMTPPort    = "25"
$credential  = ([pscredential]::new($from,(ConvertTo-SecureString -String 'password' -AsPlainText -Force)))

#actualmente este metodo esta obsoleto, muestra un warning al terminar el proceso
#todo: reemplazar a futuro por otro
Send-MailMessage `
	-From $from `
	-to $to `
	-Subject $subject `
	-Body $body `
	-SmtpServer $SMTPServer `
	-port $SMTPPort `
	-Credential $credential
