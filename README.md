# ChiaScripts

Chia Scripts es un conjunto de scripts desarrollados en PowerShell para facilitar la creación de plots para Chia blockchain.
   Para obtener información sobre el proyecto Chia, visitar (https://www.chia.net/)

## Que ventajas ofrecen estos scripts
* Se automatiza el proceso de ploteado directamente con dos scripts (**addPlots.ps1** y **addPlotsParallel.ps1**)
* Todos los procesos en paralelo se ejecutan en 1 sola ventana haciendo mas sencillo el seguimiento.
* No requiere modificar el script cuando salga una nueva versión de chia a futuro.
* Envia un email una vez finalizado el proceso a una casilla de correo que configuremos (**sendEmail.ps1**).
* Guarda un log de ejecución del proceso completo, si se requiere.
* Guarda un log de resumen de ejecución, si se requiere.
* El resumen de ejecución calcula el tiempo total del proceso y el tiempo promedio de un plot, esta información es sumamente útil para hacer comparaciones del rendimiento de nuestro hardware con los distintos parámetros que especifiquemos.

## Requisitos
1. Windows 10
2. PowerShell Core 7.x que lo puedes descargade de Microsoft (https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7.1)
3. Chia para Windows 1.1.x que lo puedes descargar de Chia Network (https://github.com/Chia-Network/chia-blockchain/wiki/INSTALL)

## Instalación
  Solamente descargar los scripts a una carpeta son 3 en total
  1. addplots.ps1
  2. addplotsParallel.ps1
  3. sendEmail.ps1

## Uso
La configuracion es sencilla, solo es cuestión de editar la cabecera de los 3 scripts y configurarlos como veremos a continuación.
Fue pensado para un usuario que no conoce sobre comandos de PowerShell y que quiere automatizar en forma rapida la creación de plots.

## **addPlots.ps1**
   
   Para ejecutar 1 o N plots juntos en forma secuencial.
   Modificamos la cabecera donde vamos a encontrar comentados todos los parametros que se pueden modificar del script, como se muestra en la siguiente imagen:
   
   ![imagen](https://user-images.githubusercontent.com/23438179/120731702-8472a880-c4ba-11eb-9a2e-b852a476a7ba.png)

   Como puede verse cada parametro se encuentra explicado con su comentario correspondiente.
   Luego modificamos los parametros necesarios, guardamos el archivo y finalmente lo ejecutamos con 2 botón del mouse sobre el archivo, **"Ejecutar con PowerShell 7"**
   
   
## **addPlotsParallel.ps1**
   
   Para ejecutar 1 o N plots en paralelo.
   Modificamos la cabecera donde vamos a encontrar comentados todos los parametros que se pueden modificar del script, como se muestra en la siguiente imagen:
   
   ![imagen](https://user-images.githubusercontent.com/23438179/120732710-21821100-c4bc-11eb-87a7-57d26b8b3177.png)


   Como puede verse cada parametro se encuentra explicado con su comentario correspondiente.
   Luego modificamos los parametros necesarios, guardamos el archivo y ejecutamos con 2 botón del mouse sobre el archivo, **"Ejecutar con PowerShell 7"**

## **sendEmail.ps1**
   
   Este archivo no se ejecuta, solo se debe modificar su cabecera para poner los paramatros de nuestros servidor de correo
      
   ![imagen](https://user-images.githubusercontent.com/23438179/120734113-b6860980-c4be-11eb-9c92-4a560cdfdb0f.png)

   En caso de no tener idea como configurar estos parametros, para evitar un error al momento de la ejecución del script, usar el parámetro **$sendEmail = "N"** en **addPlots.ps1** y **addPlotsParallel.ps1**

## Contribuciones
Cualquier sugerencia para mejorar el código será bienvenida.

## Licencia
[GNU General Public License v3.0](https://choosealicense.com/licenses/gpl-3.0/)
