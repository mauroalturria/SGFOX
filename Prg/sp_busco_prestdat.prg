*
* Busqueda de datos Prestadores
*
Parameters mcodigovax,mtipousu

If Vartype(mtipousu)#"N"
	mtipousu = 1
Endif


If Used("mwkpredat")
	Use In mwkpredat
Endif
Do Case
	Case mtipousu = 1
		mbusco = " tabusuario.codigovax = ?mcodigovax "
	Case mtipousu = 3
		mbusco = " prestadores.id = ?mcodigovax "
	Otherwise
		mbusco = " tabusuario.id = ?mcodigovax "
Endcase

mret = SQLExec(mcon1,"select prestadores.nombre,prestadores.matriculas,prestadores.id as codigomed,tabusuario.id as idusumed "+;
	" from prestadores"+;
	" left outer join tabusuario"+;
	" on prestadores.id = tabusuario.idcodmed  where "+mbusco ,"mwkpredat")


If mret < 0
	=Aerror(merror)
	Messagebox("EN CONSULTA DE PRESTADORES"+Chr(13)+;
		alltrim(merror(3)),16,"ERROR")
Endif
If Reccount("mwkpredat")= 0
mbusco = STRTRAN(mbusco ,'prestadores','Tabmedexterno')
	mret = SQLExec(mcon1,"select Tabmedexterno.nombre,Tabmedexterno.matricula ,Tabmedexterno.id as codigomed,tabusuario.id as idusumed "+;
		" from Tabmedexterno"+;
		" left outer join tabusuario"+;
		" on Tabmedexterno.id = tabusuario.idcodmed  where "+mbusco ,"mwkpredatpre")
	Select nombre,Transform(Int(matricula)) As matriculas , codigomed,idusumed  From mwkpredatpre Into Cursor mwkpredat
Endif
If mret < 0
	=Aerror(merror)
	Messagebox("EN CONSULTA DE PRESTADORES"+Chr(13)+;
		alltrim(merror(3)),16,"ERROR")
Endif
