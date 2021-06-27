# Detecta la caida de un nodo y envia un email informando #
$headers = @{
	"Cache-Control"="no-cache"
}

# User & Pass del portal de CorePool (https://core-pool.com/)
$body = @{
	username = 'username'
	password = 'password'
}

$urlLogin = "https://core-pool.com/login"
$urlDashboard = "https://core-pool.com/dashboard"
$countOffline = 30
$time = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
$patternSearch = '<td class="farmer_token"'
$patternOnline = ">Online<"
$patternOffline = ">Offline<"

try
{
	$loginResponse = Invoke-WebRequest $urlLogin -SessionVariable webSession -Headers $headers -Body $body -Method 'POST'
}
catch {}


while ($true) #un largo largo tiempo
{
	$content = Invoke-RestMethod $urlDashboard -WebSession $webSession 
	
	$farmers = ([regex]::Matches($content, $patternSearch)).count
	
	if (([regex]::Matches($content, $patternOnline)).count -eq $farmers)
	{
		$countOffline = 30
		$time = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
		$host.ui.RawUI.WindowTitle = " [CorePool Validator] | Online :)"
		Write-Host "CorePool Online  |  ${time}"
	}
	elseif (([regex]::Matches($content, $patternOffline)).count -gt 0)
	{
		$host.ui.RawUI.WindowTitle = " [CorePool Validator] | Offline :("
		Write-Host "CorePool Offline |  Email Notification In: ${countOffline}"
		$countOffline--
	}
	else
	{
		$host.ui.RawUI.WindowTitle = " [CorePool Validator] | Unknow :|"
		Write-Host "Unknow"
	}

	#Si el estado es Offline durante 100 segundos notifico
	if ($countOffline -eq 0)
	{
		Write-Host "Enviando Email..."
		break
	}
	Start-Sleep 10
}
Start-Sleep 10

$template = @"
Se ha detenido la aplicacion de Core Pool en uno de los nodos fecha/hora: ${time}
"@
$subject = "NOTIFICACION DE CORE POOL: se detuvo el farmeo en uno de los nodos"
.\sendEmail.ps1 -body $template -subject $subject

""
#Notificar fin del proceso con varios beeps, finalmente espera salida con ENTER
[console]::beep(800,500); start-sleep 5; 
[console]::beep(800,500); [console]::beep(800,500); start-sleep 5; 
[console]::beep(800,500); [console]::beep(800,500); [console]::beep(800,500); start-sleep 5; 
[console]::beep(800,500); [console]::beep(800,500); [console]::beep(800,500); [console]::beep(800,500); 
Read-Host -Prompt "presione <ENTER> para SALIR"
