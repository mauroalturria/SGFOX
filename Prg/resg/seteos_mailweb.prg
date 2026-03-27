**********************************************************************
* Program....: MAIN.PRG
* Version....:
* Author.....: Eduardo E. Tkachuk
* Date.......: 01 July 2020, 09:46:25
* Notice.....: Copyright © 2020, Silver Cross America Inc. S.A.
*              All Rights Reserved.
* Compiler...: Visual FoxPro 09.00.0000.5815 for Windows
* Changes....: mpistiner, Created 01 July 2020 / 13:46:25
* Purpose....:
**********************************************************************
**  Seteos del sistema - Correo Electronico desde web a registracion

*!*	Lparameters miparam

*!*	If Empty(miparam)
*!*	   Messagebox("ACCESO NO AUTORIZADO",16,"Control de ingreso")
*!*	   Cancel
*!*	Endif

*-- Limpieza del el Entono de Datos
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
   block_ent,mxambito,archini(1)

*Try
mxambito = 1
lcdirectorioEXE = Fullpath(Curdir())
Set Default To &lcdirectorioEXE
Set Path To Scx, Lib, Mnu, Prg, Exe, Bmp, Rep

block_ent = ''

Do seteos_ip
myip = IPAddress()

cfondo = Iif(_Screen.Width<=800,"\qepd1a1\solo_marca.jpg","\qepd1a1\solo_marca2.jpg")
Modify Windows Screen Fill File &cfondo

*////////////////////////////////////////////////////////////////////////////////////////////////////////////
*         Configuramos la Pantalla para Identificar la Aplicacion
*////////////////////////////////////////////////////////////////////////////////////////////////////////////
With _Screen
   .WindowState = 0                                             &&  (0)Normal  (1)Minimizado  (2)Maximizado
   .BackColor = 14342874                                        && Rgb(95,95,95)
   .Caption 	= '.:: Actualización de Email registrados vía Web a tabla Registración del SG ::.'    && titulo de la Ventana
   .Icon = 'class.ico'
   .Visible = .T.
   *-- Agregado para Identificar el sistema
   .AddObject ( "Title1", "Title" )
   .Title1.Caption = 'Proceso de Email registrados vía Web a SG '
   .AddObject ( "Title2", "Title" )
   .Title2.Caption = 'Proceso de Email registrados vía Web a SG '
   .Title2.Top  = _Screen.Title2.Top  - 4
   .Title2.Left = _Screen.Title2.Left - 4
   .Title2.ForeColor = Rgb ( 255, 0, 0 )
Endwith

Wait Window At 20,20 Nowait "Procesando Datos..." Timeout 30

Do sp_conexion
Do sp_busco_server_namespaces
ldFecha = sp_busco_fecha_serv("DD")
On Error = Aerr(eros)

*///////////////////////////////////////////////////////////////////////////////////////
*-- Guardo el Inicio de la atividad al ejecutar
Strtofile( Replicate('/',100) +Chr(13)+Chr(10),"EMAILREGISTRA.LOG",1)
Strtofile( Dtoc( ldFecha )+" "+Time()+" - Inicio Reloj " + Chr(13) + Chr(10),"EMAILREGISTRA.LOG",1)

*--Instancio la clase para procesar los mails de web
oActualizaViaWeb = Newobject("ActualizaViaWeb","...\sp_actualiza_email_registra.prg")
oActualizaViaWeb.ArmoSetdatos()

Wait Window At 20,20 Nowait "Proceso Terminado..." Timeout 30
Strtofile( Dtoc( ldFecha )+ " " + Time() + ' -  Fin Reloj - Proceso Actualiza Correo  ' + Chr(13)+Chr(10),"EMAILREGISTRA.LOG",1 )

If ( Version(2) = 2 )
   Do sp_desconexion
Else
   *--
   On Shutdown
   Quit
Endif


*////////////////////////////////////////////////////////////////////////////////////////////////
********************************************************
Define Class Title As Label
   FontName = [Times New Roman]
   FontSize = 25
   Visible  = .T.
   Width    = 600
   Height   = 125
   Top      = _Screen.Height - 800			&&150
   Left     = 25
   Caption  = ''
   ForeColor = Rgb ( 192,192,192 )
   BackStyle = 0    && Transparent
Enddefine


