*
* Pasaje de Archivos a un campo General en Tablas CACHE
*
Public mcon1

mcon1 = SQLCONNECT("conec02") && String de Coneccion a DESARROLLO 

If !directory("C:\temp\videos")
	Mkdir "C:\temp\videos"
Endif
Dimension vdat[7]
vdat[1] = 2008
vdat[2] = 'GUARDIA TUTORIALES'
*
* Hay que habilitar las opciones que corresponden previo a correr el SP
*

*!*	vdat[3] = '1'                   && Tema = Item de Menu
*!*	rutavideo = 'c:\tmp\hcea1.avi'
*!* vdat[7] =1						&& Subnivel = partes en las que se % un video Ej. 1,2,3,etc.

*!*	vdat[3] = '1'                   && Tema = Item de Menu
*!*	rutavideo = 'c:\tmp\hcea2.avi'
*!*	vdat[7] =2						&& Subnivel = partes en las que se % un video Ej. 1,2,3,etc.

*!*	vdat[3] = '2'                   && Tema = Item de Menu
*!*	rutavideo = 'c:\tmp\hceb1.avi'
*!* vdat[7] =1						&& Subnivel = partes en las que se % un video Ej. 1,2,3,etc.

*!*	 vdat[3] = '2'					&& Tema = Item de Menu
*!*	 rutavideo = 'c:\tmp\hceb2.avi'
*!*	 vdat[7] = 2					&& Subnivel = partes en las que se % un video Ej. 1,2,3,etc.

*!*	 vdat[3] = '2'					&& Tema = Item de Menu
*!*	 rutavideo = 'c:\tmp\hceb3.wmv'
*!*	 vdat[7] = 3

vdat[4] = 'AVI'				        && Tipo de Archivo, Ej.: WMV, etc.
vdat[5] = 38                        && Propietario = EXE ( ID de TabExe )
vdat[6] = 'frmtutoriales01'			&& Formulario

*!*    anio   ,descripcion  ,  propietario  ,  formulario ,  tema    ,  subnivel  ,   tipo    ,    documento
*!*   vdat[1] ,  ?vdat[2]   ,    ?vdat[5]   ,   ?vdat6]   , ?vdat[3] ,   ?vdat[7] ,  ?vdat[4] ,  ?__DATA.video

If used ('videos')
	Use in VIDEOS
Endif
If used ('__DATA')
	Use in __DATA
Endif
If file("C:\temp\videos\videos.dbf")
	Erase ("C:\temp\videos\videos.dbf")
Endif
If file("C:\temp\videos\videos.fpt")
	Erase ("C:\temp\videos\videos.fpt")
Endif
Select 0
Create table "C:\temp\videos\videos.dbf" free (video M)
*!* Toma el dato binario del archivo introducido en el memo
Select VIDEOS
Append blank
miVideo = ''
Do prg_LoadBin with rutavideo,miVideo
mpaso = .f.
If !empty(miVideo)
	Replace video with miVideo
	Use
*!* Cambia el campo memo a un tipo general para introducir a sql server
	LL = fopen("C:\temp\videos\videos.dbf",12)
	Fseek(LL,43)
	Fwrite(LL,'G')
	Fclose(LL)
*!* Escribe el dato en sql server
	Use C:\temp\VIDEOS\VIDEOS.dbf alias __DATA
	mpaso = .t.
Else
	Create cursor __DATA (video M)
Endif
If mpaso
	mret = sqlexec(mcon1, "insert into TabDocGral (anio,descripcion,propietario,formulario,tema,subnivel,tipo,documento) "+;
		"values (?vdat[1],?vdat[2],?vdat[5],?vdat[6],?vdat[3],?vdat[7],?vdat[4],?__DATA.video)")
	If mret < 0
		Messagebox("EN INCORPORACION DE ARCHIVO AVI "+CHR(10)+"AL MAESTRO DE DOCUMENTOS GENERALES",16,"ERROR")
	Else
		Messagebox("INCORPORACION DE ARCHIVO AVI "+CHR(10)+"REALIZADA !!",48,"Validación")
	Endif
Endif
Release vdat
If used ('videos')
	Use in VIDEOS
Endif
If used ('__DATA')
	Use in __DATA
Endif
= SQLDisconnect(mcon1)
Return




