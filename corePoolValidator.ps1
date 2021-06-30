#--------------------------------------------#
# © 2021    | github.com/ggwilly |  GPL v3.0 #
# Detecta la caida de un nodo y envia un     #
# email informando                           #
#--------------------------------------------#

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
$countOffline = 60
$time = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
$patternSearch = '<td class="farmer_token"'
$patternOnline = ">Online<"
$patternOffline = ">Offline<"
$disconected = $null
$disconectedPre = $false
$unknown = $false
$disconectedCicle = 0
$notify = ""

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
		$countOffline = 60
		$disconected = $false
		$time = Get-Date -Format "dd/MM/yyyy HH:mm:ss"
		$host.ui.RawUI.WindowTitle = " [CorePool Validator] | Online :)"
		Write-Host "CorePool Online  |  ${time}"
	}
	elseif (([regex]::Matches($content, $patternOffline)).count -gt 0)
	{
		$disconected = $true
		$host.ui.RawUI.WindowTitle = " [CorePool Validator] | Offline :("
		Write-Host "CorePool Offline |  Email Notification In: ${countOffline}"
		$countOffline--
	}
	else
	{
		$unknown = $true
		$host.ui.RawUI.WindowTitle = " [CorePool Validator] | Unknow :|"
		Write-Host "Unknow"
	}
	
	#logica para detectar los ciclos de desconexion
	if ($disconected -eq $false -And $disconectedPre -eq $true)
	{
		$disconectedCicle++
	}
	$disconectedPre = $disconected

	#Si el estado es Offline durante 5 minutos, notifico
	if ($countOffline -lt 0)
	{
		Write-Host "Enviando Email..."
		$notify = "Se detuvo el farmeo en uno de los nodos"
		break
	}
	if ($disconectedCicle -ge 5) #Si se conecta y reconecta 5 veces
	{
		Write-Host "Enviando Email..."
		$notify = "Hubo conexiones y reconexiones seguidas, revisar si los forks de las ALTCOINS estan sincronizando bien"
		break
	}
	if ($unknown -eq $true) #Si hubo un error desconocido
	{
		Write-Host "Enviando Email..."
		$notify = "Hubo un error desconocido"
		break
	}
	
	Start-Sleep 5
}
Start-Sleep 10

$template = @"
${notify} fecha/hora: ${time}
"@
$subject = "NOTIFICACION DE CORE POOL: ${notify}"
.\sendEmail.ps1 -body $template -subject $subject

""
#Notificar fin del proceso con varios beeps, finalmente espera salida con ENTER
[console]::beep(800,500); start-sleep 5; 
[console]::beep(800,500); [console]::beep(800,500); start-sleep 5; 
[console]::beep(800,500); [console]::beep(800,500); [console]::beep(800,500); start-sleep 5; 
[console]::beep(800,500); [console]::beep(800,500); [console]::beep(800,500); [console]::beep(800,500); 
Read-Host -Prompt "presione <ENTER> para SALIR"
