#--------------------------------------------#
# © 2021    | github.com/ggwilly |  GPL v3.0 #
#-- Parametros CHIA -------------------------#
$plotType            = 32                    # Parametro -k es el tamaño del plot que se va a crear. Default = 32
$memoryMiB           = 10000                 # Parametro -b es la cantidad de RAM en MiB que usara el proceso individual de ploteo. Default = 3389
$threads             = 8                     # Parametro -r es el numero de hilos que usara el proceso de ploteo. Default = 2
$bucketSize          = 128                   # Parametro -u es el tamaño del bucket. Default = 128
$temporaryDir        = "D:\Temp.Chia"        # Parametro -d es la ubicacion de la carpeta temporal. No es necesario que este creada
$destinationDir      = "D:\"                 # Parametro -t es el carpeta final donde se copiara finalmene el plot. No es necesario que este creada
$logDir              = "D:\Logs"             # Carpeta donde quedaran los logs del proceso. No es necesario que este creada
$plots         		 = 1                     # Indica cuantos plots secuenciales son ejecutadas. Default = 1
#-- Parametros adicionales ------------------#
$saveLogSummary      = "Y"                   # Indica si el log de resumen del proceso se guardara en la carpeta de log. Default "N"
$sendEmail           = "N"                   # Indica si se enviará un correo electronico con el resumen de proceso al terminar. Para modificar los parametros de envio de correo modificar en el archivo "sendEmail.ps1". Default "N"
#--------------------------------------------#

#Cambiamos a la carpeta de chia
$chiaDir = (Get-Item "$env:LOCALAPPDATA\chia-blockchain\app*\resources\app.asar.unpacked\daemon").fullname
Push-Location $chiaDir

#version de Chia
$version = .\chia.exe version

#creamos todas las carpetas en caso de que no existan para evitar problemas
New-Item -ItemType Directory -Force -Path $temporaryDir | Out-Null
New-Item -ItemType Directory -Force -Path $destinationDir | Out-Null
New-Item -ItemType Directory -Force -Path $logDir | Out-Null

$startTime = Get-Date -Format "dd/MM/yyyy HH:mm:ss"

#Mostramos los parametros del ploteo en el titulo de la ventana de PS
$host.ui.RawUI.WindowTitle = " [Secuencial] >> Bucket ${BucketSize} | Memoria MiB ${memoryMiB} | Plots ${plots} | Threads ${threads} | Iniciado ${startTime}"

@"
==============================================
Parametros de inicio | Chia version ${version}
----------------------------------------------
Hora inicio          | $startTime
----------------------------------------------
Computadora          | $env:computername
Desde > Hasta        | $temporaryDir > $destinationDir 
Plots                | $plots
Memoria MiB          | $memoryMiB
Threads              | $threads
BucketSize           | $bucketSize
----------------------------------------------
Enviar Email         | $sendEmail
==============================================

"@

$executionTime = Measure-Command {
	1..$plots | ForEach-Object { 
		#Date and Time for log
		$date = get-date -format "yyyyMMdd_HH.mm"
		#Creacion del Plot
		.\chia.exe plots create `
			-k $plotType `
			-b $memoryMiB `
			-r $threads `
			-u $bucketSize `
			-n 1 `
			-t $temporaryDir `
			-d $destinationDir `
		| tee "${logDir}\Chia_plot_${date}_secuencial(${_}).log"
	}
| Out-Default}
$endTime = Get-Date -Format "dd/MM/yyyy HH:mm:ss"

#Calculo del tiempo promedio de 1 plot
$averageTime = [TimeSpan]::FromMilliseconds($executionTime.TotalMilliseconds) / $plots

$template = @"
=====================================
Resumen ejecucion proceso secuencial
=====================================
Computadora     | $env:computername
Desde > Hasta   | $temporaryDir > $destinationDir 
Plots           | $plots
Memoria MiB     | $memoryMiB
Threads         | $threads
BucketSize      | $bucketSize
=====================================
Hora Inicio     | $startTime
Hora Fin        | $endTime
=====================================
Tiempo total proceso
=====================================
Dias            | $($executionTime.Days)
Horas           | $($executionTime.Hours)
Minutos         | $($executionTime.Minutes)
Segundos        | $($executionTime.Seconds)
=====================================
Tiempo promedio 1 plot
=====================================
Dias            | $($averageTime.Days)
Horas           | $($averageTime.Hours)
Minutos         | $($averageTime.Minutes)
Segundos        | $($averageTime.Seconds)
-------------------------------------
"@
""
$template
""

#Restauramos la ubicacion del path original
Pop-Location

#Guarda el log de resumen
if ($saveLogSummary -eq "Y") {
	$date = Get-Date -format "yyyyMMdd_HH.mm"
	$template | Set-Content "${logDir}\Chia_resumen_${date}_secuencial.log"
}

#Envia el correo
if ($sendEmail -eq "Y") {
	.\sendEmail.ps1 -body $template -time $startTime
}

#Notificar fin del proceso con varios beeps, finalmente espera salida con ENTER
[console]::beep(800,500); start-sleep 5; 
[console]::beep(800,500); [console]::beep(800,500); start-sleep 5; 
[console]::beep(800,500); [console]::beep(800,500); [console]::beep(800,500); start-sleep 5; 
[console]::beep(800,500); [console]::beep(800,500); [console]::beep(800,500); [console]::beep(800,500); 
Read-Host -Prompt "presione <ENTER> para SALIR"