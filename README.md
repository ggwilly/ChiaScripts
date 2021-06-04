# ChiaScripts

Chia Scripts es un conjunto de scripts desarrollados en PowerShell para facilitar la creación de plots de la Chia blockchain.

## Que ventajas ofrecen los scripts

* Se automatiza el proceso de ploteado directamente con dos scripts (addPlots.ps1 y addPlotsParallel.ps1)
* Todos los procesos en paralelo se ejecuta en 1 sola ventana haciendo mas sencillo el seguimiento.
* No requiere modificar el script cuando una nueva version de chia salga a futuro.
* Envia un email una vez finalizado el proceso a una casilla de correo que configuremos (sendEmail.ps1).
* Guarda un log de ejecución del proceso completo, si se requiere.
* Guarda un log de resumen de ejecución, si se requiere.


## Instalación

  Solamente descargar los scripts a una carpeta son 3 en total
  + addplots.ps1
  + addplotsParallel.ps1
  + sendEmail.ps1

## Requisitos
  
1. Windows 10
2. PowerShell Core 7.x que lo puedes descargade de [Microsoft](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7.1)
3. Chia para windows 1.1.x Chia Network(https://github.com/Chia-Network/chia-blockchain/wiki/INSTALL)
4. 


## Uso

```python
import foobar

foobar.pluralize('word') # returns 'words'
foobar.pluralize('goose') # returns 'geese'
foobar.singularize('phenomena') # returns 'phenomenon'
```

## Contribuciones
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## Licencia
[GNU General Public License v3.0](https://choosealicense.com/licenses/gpl-3.0/)
