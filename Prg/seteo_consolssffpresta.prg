**********************************************************************
* Program....: SETEO_CONSOLSSFFPRESTA.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 04 September 2020, 10:04:33
* Notice.....: Copyright © 2020, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: etkachuk, Created 04 September 2020 / 10:04:33
* Purpose....:   Consolida Consulta Success Factor y Prestadores
**********************************************************************
*
Lparameters miparam
If Empty(miparam)
   Messagebox("ACCESO NO AUTORIZADO",16,"Control de ingreso")
   Cancel
Endif

*-- Limpieza del Entono de Datos
Close Table All
Close Databases All
Clear Macro All
*
*-- Seteo de inicio - Despues se completa el seteo
Set Talk Off
Set Near Off
Set Deleted On
Set Echo Off
Set Safety Off
Set Exclusive Off
Set Date To British
* Set Path To

Public mcon1, midusu, mpassw, mcodvax, msql_reg, mcon1, mresplog, mtfhoy, myip, miform, ;
   block_ent,mxambito,archini(1),mxcentromedico
mxcentromedico =1

mxambito = 1
lcdirectorioEXE = Fullpath(Curdir())
Set Default To &lcdirectorioEXE
Set Path To Scx, Lib, Mnu, Prg, Exe, Bmp, Rep

block_ent = ''

Do seteos_ip
myip = IPAddress()

cfondo = Iif(_Screen.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
Modify Windows Screen Fill File &cfondo

With _Screen
   *//////////////////
   .WindowState = 2 					&& Maximizamos la pantalla de la aplicación
   .Caption 	= 'Actualización de Email registrados vía Web a tabla Registración del SG'    && titulo de la Ventana
   .BackColor = Rgb(58,73,205)
   .Icon = 'class.ico'

Endwith

Wait Window At 20,20 Nowait "Procesando Datos..." Timeout 30

Do sp_conexion
Do sp_busco_server_namespaces
On Error =Aerr(eros)

*--Instancio la clase para procesar los datos de Success Factory Prestadores
oConsolidadoSFpresta = Newobject("ConsolidadoSFPresta","...\sp_genero_consolssffpresta.prg"  )
oConsolidadoSFpresta.ArmoSetDatos()

Wait Window At 20,20 Nowait "Proceso Terminado..." Timeout 30

If ( Version(2) = 2 )
   Do sp_desconexion
Else
   *--
   On Shutdown
   Quit
Endif

