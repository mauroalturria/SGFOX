**** desbloquea alta pacientes sap para facturar
lparameters xmnroadm,lbloq
*Do sp_busco_estados With 7, " and tipo = 46 ", "mwkAdmonline"
if vartype(mespec)#"C"
	mespec = ''
endif
if vartype(lbloq)#"N"
	lbloq = 0
endif
miresp ="AUN NO ESTA EN LINEA"
*If mwkAdmonline.estado =1 Or mwkusuario.codigovax = 54035
mnroadm = xmnroadm
private mresultado, merror,cprov(25)
dimension cprov(25)
m1 = alltrim(mnroadm )
m2 = IIF(lbloq=0,"X",'')

mccampos = ''
for I = 1 to 2
	mccampos = mccampos +evaluate("m" + alltrim(transform(I)))+iif(I<2,",","")
next

mresultado = 0
merror = 0
mcopt = ''
musuario = mwkusuario.idusuario
*If !Used("mwkservprueba")
do sp_busco_estados with 7, " and tipo = 45 ", "mwkservprueba"
*Endif
go top in mwkservprueba
mstringcon = alltrim(mwkservprueba.descrip)
if mwkservprueba.estado = 1
	miconex = sqlstringconnect("Driver={InterSystems ODBC};PORT=1972;SERVER="+mstringcon )
else
	miconex = mcon1
endif
mRet = SQLExec(miconex ,"CALL WS.AProcesarSP_GrabaAProcesar('SI_PO_0018_bloqueo_facturacion',4,?mccampos,?musuario,?@mresultado, ?@merror","C1")
if 	miconex # mcon1
	SQLDisconnect(miconex)
endif
miresp = "Resultado : " + transform(mresultado)+"Error : " + transform(merror)
*Endif
mfechap = sp_busco_fecha_serv("DT")
mcoderr = mresultado*mret
midusua = mwkusuario.idusuario
mhabcama = mccampos 
mret = SQLExec(mcon1, "insert into TabVerC (codadmision,control,fecha,prg, usuario, habcama) values "+;
	" ( ?mnroadm ,0,?mfechap,?mcoderr , ?midusua, ?mhabcama )	")

return miresp
