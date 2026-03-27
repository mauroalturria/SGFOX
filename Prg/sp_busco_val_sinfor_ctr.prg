*!*	-------------------------------------------------------
*!*	Parametros
*!*	-------------------------------------------------------
Lparameters mOpcion, mfecdes, mfechas, mwhere, mtipo

*--------------------------
&& obtengo fecha inicial
Do sp_busco_prestacion With " and PRE_AgendaTurnos = 'S' "

If mtipo = 1 &&Opción de Rx del Día tildada (son las que se marcaron que van con informes)
	mfechaini=mfecdes
	mret = SQLExec(mcon1, "SELECT tpprotocolo, tpregistrac FROM Tabprotocolo"+;
		" Where tpestado in (1, 2,3, 4, 5, 7) and tpfecharetiro >= ?mfechaini  "+;
		" group by tpprotocolo" ,"mwkanulados")
Else
	Select Max(PRE_retiroestudios) As demora ;
		from mwkprestac ;
		into Cursor mwkdemo
	mfechaini = prg_calcula_diahabil(mfecdes-1,mwkdemo.demora*(-1),"1,7")
	mret = SQLExec(mcon1, "SELECT tpprotocolo, tpregistrac FROM Tabprotocolo"+;
		" Where tpestado in ( 2,4, 5, 7) and tpfecharetiro >= ?mfechaini  "+;
		" group by tpprotocolo" ,"mwkanulados")
Endif

*--------------------------
If mret <=0
	Messagebox("ERROR DE LECTURA, REINTENTE", 48, "VALIDACION")
*=Aerror(eros)
*Messagebox(eros(3))
	Return .F.
Endif

Do Case
Case mOpcion = 1  && Guardia
	mcwhere = " and Val_TipoPaciente = 'GUA' "
Case mOpcion = 2  && Ambulatorio
	mcwhere = " and Val_TipoPaciente = 'AMB' "
Case mOpcion = 3  && Internación
	mcwhere = " and Val_TipoPaciente = 'INT' "
Endcase

mret = SQLExec(mcon1, "SELECT valesasist.VAL_NroProtocolo FROM TabValObs, valesasist "+;
	" Where TabValObs.TVO_CodPun = valesasist. Val_CodPun and " + ;
	" TVO_SubEstado in (23,82,98) and " + ;
	" TVO_fechaestudio >= ?mfechaini " ,"mwkanula2")

If mret <=0
	Messagebox("ERROR DE LECTURA, REINTENTE", 48, "VALIDACION")
*=Aerror(eros)
*Messagebox(eros(3))
	Return .F.
Endif

If mtipo=2
	mret = SQLExec(mcon1, "select " + ;
		"valesasist.VAL_codadmision, valesasist.VAL_codservvale, " + ;
		"valesasist.VAL_NroProtocolo, Val_CodPun, VAL_fechasolicitud, " + ;
		"Val_codValeAsist, informes.Id, Val_TipoPaciente, " + ;
		"informes.FechaRecepcion, Prestacions.PRE_retiroestudios " + ;
		"from valesasist " + ;
		"Left Join informes on Informes.CodPun = valesasist.VAL_CodPun " + ;
		"left join presinsuvas on valesasist.valesasist = presinsuvas.pia_valesasist " + ;
		"left join Prestacions on Pre_CodPrest = presinsuvas.pia_codprest "+;
		"where VAL_fechasolicitud >= ?mfechaini and " + ;
		"VAL_fechasolicitud <= ?mfechas and " + ;
		"Pre_CodPrest not in (84020100, 84020101, 18010403, 34100402) " + ;
		mwhere + mcwhere  , "cInformes")
Else
	mret = SQLExec(mcon1, "select " + ;
		"valesasist.VAL_codadmision, valesasist.VAL_codservvale, " + ;
		"valesasist.VAL_NroProtocolo, Val_CodPun, VAL_fechasolicitud, " + ;
		"Val_codValeAsist, informes.Id, Val_TipoPaciente, " + ;
		"informes.FechaRecepcion, Prestacions.PRE_retiroestudios " + ;
		"from valesasist " + ;
		"Left Join informes on Informes.CodPun = valesasist.VAL_CodPun " + ;
		"left join presinsuvas on valesasist.valesasist = presinsuvas.pia_valesasist " + ;
		"left join Prestacions on Pre_CodPrest = presinsuvas.pia_codprest "+;
		"where VAL_fechasolicitud >= ?mfechaini and " + ;
		"VAL_fechasolicitud <= ?mfechas and " + ;
		"Pre_CodPrest not in (84020100, 84020101, 18010403, 34100402, 34060100, 34060101, 34060200"+;
		"84060100,84060101) " + ;
		mwhere + mcwhere  , "cInformes")
Endif

If mret <=0
	Messagebox("ERROR DE LECTURA, REINTENTE", 48, "VALIDACION")
*!*		=Aerror(eros)
*!*		Messagebox(eros(3))
	Return .F.
Endif

Select prg_calcula_diahabil(VAL_fechasolicitud ,PRE_retiroestudios,"1,7") As fechaentrega, ;
	cinformes.* ;
	from cinformes ;
	where VAL_NroProtocolo Not In (Select tpprotocolo From mwkanulados) And ;
	VAL_NroProtocolo Not In (Select VAL_NroProtocolo From mwkanula2) ;
	into Cursor mwkinfopre

Use In mwkanula2

If mtipo>1
	Select a.*, "VERIFICAR  " As VER ;
		from mwkinfopre a, mwkinfopre b ;
		where a.val_codadmision = b.val_codadmision And ;
		a.val_codservvale = b.val_codservvale And ;
		a.Id = 0 And b.Id > 0 ;
		union ;
		select a.*, "SIN INFORME" As VER ;
		from mwkinfopre a  ;
		where a.Id = 0 ;
		into Cursor mwkValsInf1
Else
	Select a.*, "VERIFICAR  " As VER ;
		from mwkinfopre a, mwkinfopre b ;
		where a.val_codadmision = b.val_codadmision And ;
		a.val_codservvale = b.val_codservvale And ;
		a.Id = 0 Or b.Id > 0 ;
		union ;
		select a.*, "SIN INFORME" As VER ;
		from mwkinfopre a  ;
		where a.Id = 0 ;
		into Cursor mwkValsInf1

Endif
*!*		If Not mtipo && control
*!*			Select * From mwkValsInf1 Where fechaentrega <= mfecdes Into Cursor mwkValsInf
*!*		Else
*!*			Select * From mwkValsInf1 Where fechaentrega = mfecdes Into Cursor mwkValsInf
*!*		Endif

If mtipo=2
	Select * From mwkValsInf1 Where fechaentrega = mfecdes ;
		Into Cursor mwkValsInf
Else
	Select * From mwkValsInf1;
		GROUP By VAL_NroProtocolo;
		Into Cursor mwkValsInf
Endif

If Used('mwkinfopre')
	Use In mwkinfopre
Endif

If Used('cInformes')
	Use In cinformes
Endif
If Used("mwkdemo")
	Use In mwkdemo
Endif
