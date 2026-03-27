*** busqueda de prestaciones no convenidas

Lparameters  xmcodprest, xmcodentag ,xsector,xnsoloSAP
If Vartype(xnsoloSAP )<>"N"
	xnsoloSAP = 0
Endif
lcimporteCobertura = ''
lcimportePaciente =''
lcpracticaSinCargo = ''
lcpracticaConvenida = ''
mret = SQLExec(mcon1,"SELECT PRE_codservicio,PRA_codprestasocia FROM Prestacions "+;
	"  left join Prestasocia on Prestasocia.PRA_PRESTACIONS = Prestacions.PRE_codprest " +;
	" WHERE  PRE_codprest = "+Transform(xmcodprest)	,"mwkservpres")
mresp = ''
If !Used("mwkservpres")
	Select * From mwkusuario Where .F. Into Cursor mwkservpres
	Select * From mwkusuario Where .F. Into Cursor mwkprestNC
	Return
Endif
If mwkservpres.PRE_codservicio = 3260
	Select * From mwkusuario Where .F. Into Cursor mwkprestNC
	Use In Select("mwkservpres")
	Return
Endif

Do sp_busco_estados With 57,' and tipo = 23 ','mwkhabeleg'&&

Do sp_busco_estados With 57,' and tipo = 11 ','mwkhabpreciosap'&&
lerror = .F.
If mwkhabpreciosap.estado = 1
	Select * From mwkusuario Where .T. Into Cursor mwkprestNC
	mresp = prg_preciosap(xmcodentag ,xmcodprest,@lcimporteCobertura,@lcimportePaciente ,@lcpracticaSinCargo ,@lcpracticaConvenida )
	If Empty(mresp ) Or At("mensaje",mresp)>0 Or Empty(lcpracticaConvenida) Or Val(lcimporteCobertura) =0
		If Empty(mresp ) Or At("mensaje",mresp)>0
			lerror = .T.
		Endif
*!*			If mwkservpres.PRE_codservicio = 6300 &&& solo consulto para resonancia las asociadas
*!*				Select  mwkservpres
*!*				Scan
*!*					If Nvl(mwkservpres.PRA_codprestasocia,0)>0
*!*						mresp = prg_preciosap(xmcodentag ,mwkservpres.PRA_codprestasocia ,@lcimporteCobertura,@lcimportePaciente ,@lcpracticaSinCargo ,@lcpracticaConvenida )
*!*						If lcpracticaConvenida='X'
*!*							Select * From mwkusuario Where .F. Into Cursor mwkprestNC
*!*							Exit
*!*						Endif
*!*					Endif
*!*				Endscan
*!*			endif
	Endif
	If lcpracticaConvenida='X'
		Select * From mwkusuario Where .F. Into Cursor mwkprestNC
		Return
	Else
		If xnsoloSAP = 1 And  Val(lcimporteCobertura) =0
			Select * From mwkusuario  Into Cursor mwkprestNC
			Return
		Endif
	Endif
Endif
If mwkhabpreciosap.subestado = 1 Or mwkhabpreciosap.estado = 0 Or lerror &&& puede controla por nuestros datos
	If Empty(mresp ) Or At("mensaje",mresp)>0
		mret = SQLExec(mcon1, "select PC_FechaVigDesde, PC_FechaVigHasta, PC_codent, PC_codprest, PC_incluidaAMB,"+;
			" PC_incluidaGUA, PC_incluidaINT from Zabprestconvenio " + ;
			" where PC_codent= ?xmcodentag  and PC_codprest = ?xmcodprest  and " + ;
			" PC_FechaVigHasta>= {fn curdate()} and PC_FechaVigDesde<= {fn curdate()}  ", "mwkprestconv")
		If mret < 0
			Messagebox("ERROR EN LA LECTURA DE INCIDENTES DE SEGURIDAD",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif
		mcampo = "PC_incluida"+Alltrim(xsector)

		Select * From mwkprestconv Where &mcampo =2  Into Cursor mwkprestNC
	Else

		If Empty(lcpracticaConvenida) Or Val(lcimporteCobertura) =0
			mret = SQLExec(mcon1, "select PC_FechaVigDesde, PC_FechaVigHasta, PC_codent, PC_codprest, PC_incluidaAMB,"+;
				" PC_incluidaGUA, PC_incluidaINT from Zabprestconvenio " + ;
				" where PC_codent= ?xmcodentag  and PC_codprest = ?xmcodprest  and " + ;
				" PC_FechaVigHasta>= {fn curdate()} and PC_FechaVigDesde<= {fn curdate()}  ", "mwkprestconv")
			If mret < 0
				Messagebox("ERROR EN LA LECTURA DE INCIDENTES DE SEGURIDAD",26,"ERROR")
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Return .F.
			Endif
			mcampo = "PC_incluida"+Alltrim(xsector)

			Select * From mwkprestconv Where &mcampo =2  Into Cursor mwkprestNC
			If Reccount('mwkprestNC')=0 &&&&parece convenida
				Select * From mwkprestconv Where &mcampo =1 Into Cursor mwkprestc
				If Reccount('mwkprestC')=0 &&&agrego control
					mret = SQLExec(mcon1, "insert into Zabprestconvenio ( PC_FechaVigDesde, PC_FechaVigHasta, PC_codent,"+;
						" PC_codprest, PC_incluidaAMB, PC_incluidaGUA, PC_incluidaINT)"+;
						" values ('1900-01-01','2100-01-01',?xmcodentag,?xmcodprest,1,1,1) ")
				Endif
			Endif
		Else
			Select * From mwkusuario Where .F. Into Cursor mwkprestNC
		Endif
	Endif
Endif
Use In Select("mwkservpres")
If !Used("mwkprestNC")

	Select * From mwkusuario Where .F. Into Cursor mwkprestNC

Endif
