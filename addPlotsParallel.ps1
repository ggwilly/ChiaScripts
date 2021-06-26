#--------------------------------------------#
# © 2021    | github.com/ggwilly |  GPL v3.0 #
#-- Parametros CHIA -------------------------#
$plotType            = 32                    # Parametro -k es el tamaño del plot que se va a crear. Default = 32
$memoryMiB           = 8192                  # Parametro -b es la cantidad de RAM en MiB que usara el proceso individual de ploteo. Default = 3389
$threads             = 6                     # Parametro -r es el numero de hilos que usara el proceso de ploteo. Default = 2
$bucketSize          = 128                   # Parametro -u es el tamaño del bucket. Default = 128
$temporaryDir        = "D:\Temp.Chia"        # Parametro -d es la ubicacion de la carpeta temporal. No es necesario que este creada
$destinationDir      = "D:\"                 # Parametro -t es el carpeta final donde se copiara finalmene el plot. No es necesario que este creada
$logDir              = "D:\Logs"             # Carpeta donde quedaran los logs del proceso. No es necesario que este creada
$parallelPlots       = 2                     # Indica cuantos plots en paralelo son ejecutados por el proceso. Default = 2
$queue               = 1                     # Por cada plot en paralelo especifica cuantos plots en cola se ejecutaran. Default = 1
$delayMinutes        = 30                    # Tiempo de espera en minutos entre procesos paralelos (0 = sin espera)
#-- Parametros adicionales ------------------#
$saveLogSummary      = "N"                   # Indica si el log de resumen del proceso se guardara en la carpeta de log. Default "N"
$sendEmail           = "Y"                   # Indica si se enviará un correo electronico con el resumen de proceso al terminar. Para modificar los parametros de envio de correo modificar en el archivo "sendEmail.ps1". Default "N"
#--------------------------------------------#

#Cambiamos a la carpeta de chia
$chiaDir = (Get-Item "$env:LOCALAPPDATA\chia-blockchain\app*\resources\app.asar.unpacked\daemon").fullname
Push-Location $chiaDir

#version de Chia
$version = .\chia.exe version

#Creamos todas las carpetas en caso de que no existan para evitar problemas
New-Item -ItemType Directory -Force -Path $temporaryDir | Out-Null
New-Item -ItemType Directory -Force -Path $destinationDir | Out-Null
New-Item -ItemType Directory -Force -Path $logDir | Out-Null

$startTime = Get-Date -Format "dd/MM/yyyy HH:mm:ss"

#Mostramos los parametros del ploteo en el titulo de la ventana de PS
$host.ui.RawUI.WindowTitle = " [Paralelo] >> Bucket ${BucketSize} | Memoria MiB ${memoryMiB} | Plots paralelo ${parallelPlots} | Cola ${queue} | Threads ${threads} | Minutos espera ${delayMinutes} | Iniciado ${startTime}"

@"
==============================================
Parametros de inicio | Chia version ${version}
----------------------------------------------
Hora inicio          | $startTime
----------------------------------------------
Computadora          | $env:computername
Desde > Hasta        | $temporaryDir > $destinationDir 
Plots Paralelo       | $parallelPlots
Cola                 | $queue
Memoria MiB          | $memoryMiB
Minutos Espera       | $delayMinutes
Threads              | $threads
BucketSize           | $bucketSize
----------------------------------------------
Enviar Email         | $sendEmail
==============================================

"@

$executionTime = Measure-Command {
	1..$parallelPlots | ForEach-Object -Parallel { 
		if ( $_ -gt 1 ) {
			$delay = $using:delayMinutes * 60 * ($_ - 1)
			Start-Sleep $delay
		}
		#Fecha y hora para el Log
		$date = get-date -format "yyyyMMdd_HH.mm"
		#Creacion del Plot
		.\chia.exe plots create `
			-k $using:plotType `
			-b $using:memoryMiB `
			-r $using:threads `
			-u $using:bucketSize `
			-n $using:queue `
			-t $using:temporaryDir `
			-d $using:destinationDir `
		| tee "${using:logDir}\Chia_plot_${date}_parallel(${_}).log"
	} -ThrottleLimit $parallelPlots
| Out-Default}
$endTime = Get-Date -Format "dd/MM/yyyy HH:mm:ss"

#Calculo del tiempo promedio de 1 plot
$averageTime = [TimeSpan]::FromMilliseconds($executionTime.TotalMilliseconds) / ($parallelPlots * $queue)

$summaryInfo = @"
=====================================
Resumen ejecucion proceso paralelo
=====================================
Computadora     | $env:computername
Desde > Hasta   | $temporaryDir > $destinationDir 
Plots Paralelo  | $parallelPlots
Cola            | $queue
Memoria MiB     | $memoryMiB
Minutos Espera  | $delayMinutes
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
$summaryInfo
""

#Restauramos la ubicacion del path original
Pop-Location

#Guarda el log de resumen
if ($saveLogSummary -eq "Y") {
	$date = Get-Date -format "yyyyMMdd_HH.mm"
	$summaryInfo | Set-Content "${logDir}\Chia_resumen_${date}_parallel.log"
}

#Envia el correo
if ($sendEmail -eq "Y") {
	$subject     = "CHIA resumen proceso - ejecutado: ${startTime}"
	.\sendEmail.ps1 -body $summaryInfo -subject $subject
}

#Notificar fin del proceso con varios beeps, finalmente espera salida con ENTER
[console]::beep(800,500); start-sleep 5; 
[console]::beep(800,500); [console]::beep(800,500); start-sleep 5; 
[console]::beep(800,500); [console]::beep(800,500); [console]::beep(800,500); start-sleep 5; 
[console]::beep(800,500); [console]::beep(800,500); [console]::beep(800,500); [console]::beep(800,500); 
Read-Host -Prompt "presione <ENTER> para SALIR"
