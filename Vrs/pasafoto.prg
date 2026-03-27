
public mConO, mCon1
&& Prueba
mCond = sqlstringconnect("Driver={InterSystems ODBC};PORT=1972;SERVER=172.16.5.60;DATABASE=CATALOGO;Uid=_system;Pwd=sys")
&& ??? Real
mCon1 = sqlstringconnect("Driver={InterSystems ODBC};PORT=1972;SERVER=172.16.1.4;DATABASE=CATALOGO;Uid=_system;Pwd=sys")
set step on
select guardia
scan
	mnroreg = nroregistrac

	do sp_busco_datos_registracio with mnroreg
	rutaimagen = "C:\temp\imagenes\"+alltrim(str(mnroreg,9,0))+".jpg"
	mret = sqlexec(mconD, "select id from TabRegFoto where TRF_Registracio = ?mnroreg ","mwkregfctr")
	if used ('imagen')
		use in IMAGEN
	endif
	if used ('__DATA')
		use in __DATA
	endif
	if file("C:\temp\imagenes\imagen.dbf")
		erase ("C:\temp\imagenes\imagen.dbf")
	endif
	if file("C:\temp\imagenes\imagen.fpt")
		erase ("C:\temp\imagenes\imagen.fpt")
	endif
	select 0
	create table "C:\temp\imagenes\imagen.dbf" free (foto M)
* toma el dato binario del archivo introducido en el memo
	select IMAGEN
	append blank

	miimagen = ''
	do prg_LoadBin with rutaimagen,miimagen
	if !empty(miimagen )
		replace foto with miimagen
		use
* cambia el campo memo a un tipo general para introducir a sql server
		LL = fopen("C:\temp\imagenes\imagen.dbf",12)
		fseek(LL,43)
		fwrite(LL,'G')
		fclose(LL)
* escribe el dato en sql server
		use C:\temp\imagenes\IMAGEN.dbf alias __DATA
	else
		create cursor __DATA (foto M)
	endif
	if reccount('mwkregfctr')>0
		mid = mwkregfctr.id
		mret = sqlexec(mconD, "update TabRegFoto set TRF_Foto = ?__DATA.foto "+;
			" where TRF_Registracio = ?mnroreg ")
	else
		mret = sqlexec(mconD, "insert into TabRegFoto( TRF_Foto,TRF_Registracio) " + ;
			"values( ?__DATA.foto, ?mnroreg )")
	endif
	if file(rutaimagen)
		erase (rutaimagen)
	endif


	if mRet <= 0
		? "Error Id " + str(mdni )
		set step on
	endif

endscan
Sqldisconnect(mCon1)
Sqldisconnect(mConD)


return
*----------------------------------------------------------------------

