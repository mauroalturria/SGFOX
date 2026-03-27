**sp para grabar datos en la tabla TABConfigura
PARAMETERS nCentro,cConcepto,cTipo,cValor,cImagen,cDescrip,nTipo,nAccion

** Pasamos la validacion, ahora grabamos los datos.

jj = int(len(alltrim(cValor))/250)
for i = 0 to jj
	clin = "linea" + padl(i,3,"0")
	public &clin 
next
mvalor = prg_concat(alltrim(cValor))

If nTipo == 2 .And. !Empty(cImagen)  &&Convertimos imagen para guardar.

	Select 0
	Create Table "C:\temp\imagenes\imagen.dbf" Free (foto M)

*  Toma el dato binario del archivo introducido en el memo
	Select IMAGEN
	Append Blank

	miimagen = ''
	Do prg_LoadBin With cImagen,miimagen
	If !Empty(miimagen )
		Replace foto With miimagen
		Use

*  Cambia el campo memo a un tipo general para introducir a sql server
		LL = Fopen("C:\temp\imagenes\imagen.dbf",12)
		Fseek(LL,43)
		Fwrite(LL,'G')
		Fclose(LL)

		Use C:\temp\imagenes\IMAGEN.Dbf Alias __DATA

	Endif

Endif

*  Escribe el dato en sql server

If .pAccion == 1   &&insert

	If .optTipo.Value == 2

		If !Empty(cImagen)  &&con imagen
			cSql = "insert into tabconfigura (tbc_centro,tbc_concepto,tbc_tipo,tbc_descripcion,tbc_foto,tbc_valor) "
			cSql = cSql + "values(?nCentro,?cConcepto,?cTipo,?cDescrip,?__DATA.foto,"+mvalor+")"
		Else
			cSql = "insert into tabconfigura (tbc_centro,tbc_concepto,tbc_tipo,tbc_descripcion) "
			cSql = cSql + "values(?nCentro,?cConcepto,?cTipo,?cDescrip)"
		Endif

	Else

		cSql = "insert into tabconfigura (tbc_centro,tbc_concepto,tbc_tipo,tbc_valor,tbc_descripcion) "
		cSql = cSql + "values(?nCentro,?cConcepto,?cTipo,"+mvalor+",?cDescrip)"

	Endif

Else   &&update

	cSql = "update tabconfigura set "
	cSql = cSql + "tbc_centro = ?nCentro,"
	cSql = cSql + "tbc_concepto = ?cConcepto,"
	cSql = cSql + "tbc_tipo = ?cTipo,"
	cSql = cSql + "tbc_valor = "+mvalor+","
	cSql = cSql + "TBC_descripcion = ?cDescrip"
	If nTipo == 2 .And. !Empty(cImagen)
		cSql = cSql + ",tbc_foto = ?__DATA.foto"
	Endif
	cSql = cSql + " where id = ?mwkconfigura.id"

Endif

mRet = SQLExec(mcon1,cSql)
for i = 0 to jj
	clin = "linea" + padl(i,3,"0")
	release &clin 
next

If mRet<=0
	Messagebox("ERROR AL INTENTAR GRABAR DATOS.",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Return .T.
    