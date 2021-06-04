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
* El resumen de ejecución calcula el tiempo total del proceso y promedio de un plot, esta información es sumamente útil para hacer comparaciones del rendimiento de nuestro hardware con los distintos parámetros que especifiquemos.

## Requisitos
1. Windows 10
2. PowerShell Core 7.x que lo puedes descargade de Microsoft (https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7.1)
3. Chia para Windows 1.1.x que lo puedes descargar de Chia Network (https://github.com/Chia-Network/chia-blockchain/wiki/INSTALL)

## Instalación
  Solamente descargar los scripts a una carpeta son 3 en total
  + addplots.ps1
  + addplotsParallel.ps1
  + sendEmail.ps1

## Uso
Simplemente editar la cabecera de los 2 scripts y poner los parametros que sean necesarios.
Fue pensado para un usuario que no conoce sobre comandos de PowerShell.

**addplots**
   
   Para ejecutar 1 o N plots juntos en forma secuencial.
   Modificamos la cabecera del archivo como se muestra en la siguiente imagen
   






```python
import foobar

foobar.pluralize('word') # returns 'words'
foobar.pluralize('goose') # returns 'geese'
foobar.singularize('phenomena') # returns 'phenomenon'
```

## Contribuciones
Cualquier sugerencia para mejorar el código será bienvenida.

## Licencia
[GNU General Public License v3.0](https://choosealicense.com/licenses/gpl-3.0/)
