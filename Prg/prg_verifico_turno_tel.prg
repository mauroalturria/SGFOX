Parameters tipo,fecha,registra

*** PRINCIPAL (prg_verifico_turno_tel)


lcArchivo = "DBRT"+Strtran(Dtoc(fecha),"/","_")

Do Case
Case tipo = 1
	larchivo = Cargaconfig(lcArchivo)
	If !larchivo
		= Creaconfig(lcArchivo)
		= Cargaconfig(lcArchivo)
	Endif
Case tipo = 2
	=Guardaconfig(lcArchivo,fecha,registra)
Case tipo = 3
	lcarchborro = lcArchivo + ".dbf"
	=Borroarchivo(lcarchborro)
Endcase

*** FIN PRINCIPAL


*** FUNCIONES ***
Function Creaconfig(lcArchivo)
lcpath = 'c:\tempdoc\'
If !Directory(lcpath)
	Md ('c:\tempdoc\')
Endif
Create Cursor verificotel  (fecha d, registra i)
dato1 =  Ctod("01/01/2100")
dato2 =  0
Select verificotel
Insert Into verificotel  (fecha,registra) Values (dato1,dato2)
lcfile = lcpath + lcArchivo + ".dbf"
Copy To (lcfile)
Use In Select('verificotel ')
Endfunc


Function Cargaconfig(lcArchivo)
logdb = 'c:\tempdoc\'+lcArchivo+'.dbf'
If File(logdb)
	lcCursor = lcArchivo
	Use (logdb) In 0 Again
	If !Used(lcCursor)
		Return .F.
	Endif
	lcRun = "Select * From " + lcArchivo + " Into Cursor verificotel Readwrite"
	&lcRun
	Use In Select(lcCursor)
	Return .T.
Else
	Return .F.
Endif
Endfunc

Function Guardaconfig(lcArchivo,ldato1,ldato2)
lcpath = 'c:\tempdoc\'
Select verificotel
Insert Into verificotel  (fecha,registra) Values (ldato1,ldato2)
lcfile = lcpath + lcArchivo + ".dbf"
If File(lcfile)
	Select verificotel
	Copy To (lcfile)
Endif
Endfunc

Function Borroarchivo(Archivoborro)
If File(Archivoborro)
	Delete File (Archivoborro)
Endif
Endfunc
