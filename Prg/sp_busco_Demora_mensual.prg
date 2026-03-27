*!*	-------------------------------------------------------
*!*	Parametros
*!*	-------------------------------------------------------
Lparameters mOpcion, mfecdes, mwhere, mtipo, mfhasta

*!* On error
*!*	mOpcion = 2
*!*	mfecdes = ctod("15/11/2011")
*!*	mwhere  = " " && And Val_codservvale in (7100,770)"
*!*	mtipo   = .F.
*!*	mfhasta = ctod("15/11/2011")

mfnull = Ctod("01/01/1900")
If Vartype(mfhasta) <> "D"
	mfhasta = mfecdes
Endif
*Set Step On 
Do sp_busco_prestacion With " and PRE_AgendaTurnos = 'S' ", 1

Select Max(PRE_retiroestudios) As demora From mwkprestac Into Cursor mwkdemo

mfechaini = prg_calcula_diahabil( mfecdes - 1, mwkdemo.demora*(-1), "1,7")


Do sp_medicos

&& Obtengo los protocolos
&& Modifico tpestado > 2 a tpestado in ( 1, 2, 4, 5, 7) && 100701

mret = SQLExec(mcon1, "SELECT tpprotocolo, tpregistrac FROM Tabprotocolo"+;
	" Where tpestado in (1, 2, 3,4, 5, 7) and tpfecharetiro >= ?mfechaini"+;
	" group by tpprotocolo " ,"mwkanulados")

* and tpfecharetiro < ?mfechafin


If mret < 0
	Messagebox("ERROR DE LECTURA, REINTENTE", 48, "VALIDACION")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

mcwhere = ''

mjoin   = " Join coberturas On cob_pacientes = valesasist.VAL_codadmision " + ;
	" 		Left join entidades On entidades.ent_codent = coberturas.cob_codentidad "

Do Case

Case mOpcion = 1  && Guardia
	mcwhere = " and Val_TipoPaciente = 'GUA' "

Case mOpcion = 2  && Ambulatorio
	mcwhere = " and Val_TipoPaciente = 'AMB' "

Case mOpcion = 3  && Internación
	mcwhere = " and Val_TipoPaciente = 'INT' "
	mjoin   = " join histambgua on histambgua.his_codadmision = valesasist.VAL_codadmision "  +;
		" Left join entidades on entidades.ent_codent   = histambgua.his_codentidad "

Endcase

&& vales e informes entre las 2 fechas
* lnCantDias = mfecdes - mfechaini

lnCantDias = mfhasta - mfechaini
ldFecha    = mfechaini

If Used("mwkInfo")
	Use In mwkinfo
Endif

mret = SQLExec(mcon1, "select " + ;
	"Informes.CodMedFirma," + ;
	"informes.Id, nvl(Estadoinforme,0) as Estadoinforme, Informes.CodPun," +;
	"informes.fechainforme, informes.fechaaprobacion, informes.fecharecepcion,informes.nrovale " +;
	" from informes " +;
	" where FechaInforme >= ?mfechaini"+;
	" and informes.TipoArch not in " + prg_ext_sonido(2) + "", "mwkinfoAUX")

* and FechaInforme < ?mfechafin

If mret < 0
	Messagebox("ERROR DE LECTURA, REINTENTE", 48, "VALIDACION")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif


*!*	----------AGREGADO 17/07/2013

*!*	Select CodMedFirma From mwkinfoAUX;
*!* Group By Informes.CodPun;
*!*	order By fechainforme Desc;
*!* Into Cursor mwkinfoAUX

*!*	*!* ---CONTINUA CODIGO ORIGINAL------------


mret = SQLExec(mcon1, "select " + ;
	" valesasist.VAL_codadmision, valesasist.VAL_codservvale, " + ;
	" valesasist.VAL_NroProtocolo, Val_CodPun, VAL_fechasolicitud, Pia_CodPrest, " + ;
	" Val_codValeAsist, Val_TipoPaciente, " + ;
	" Prestacions.PRE_descriprest,ENT_descrient, VAL_CodPun  "+;
	" from valesasist " + ;
	mjoin +;
	" left join presinsuvas on valesasist.valesasist = presinsuvas.pia_valesasist " + ;
	" left join Prestacions on Pre_CodPrest = presinsuvas.pia_codprest "+;
	" where VAL_fechasolicitud = ?ldFecha and"+ ;
	" Pre_CodPrest not in ( 84020100, 84020101, 18010403, 34100402) " + ;
	mwhere + mcwhere  , "mwkInfo")


If mret <= 0
	Messagebox("ERROR DE LECTURA, REINTENTE", 48, "VALIDACION")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif



ldFecha = ldFecha + 1

For I = 1 To lnCantDias
	mret = SQLExec(mcon1, "select " + ;
		" valesasist.VAL_codadmision, valesasist.VAL_codservvale, " + ;
		" valesasist.VAL_NroProtocolo, Val_CodPun, VAL_fechasolicitud, Pia_CodPrest, " + ;
		" Val_codValeAsist, Val_TipoPaciente, " + ;
		" Prestacions.PRE_descriprest,ENT_descrient, VAL_CodPun  "+;
		" from valesasist " + ;
		mjoin +;
		" left join presinsuvas on valesasist.valesasist = presinsuvas.pia_valesasist " + ;
		" left join Prestacions on Pre_CodPrest = presinsuvas.pia_codprest "+;
		" where VAL_fechasolicitud = ?ldFecha and " + ;
		" Pre_CodPrest not in ( 84020100, 84020101, 18010403, 34100402) " + ;
		mwhere + mcwhere  , "mwkValAux")

	If mret <= 0
		Messagebox("ERROR DE LECTURA, REINTENTE", 48, "VALIDACION")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	Select mwkinfo
	Append From Dbf("mwkValAux")
	Use In mwkValAux
	ldFecha = ldFecha + 1
Next



Set Step On 


If (Reccount('mwkinfo')>0)
	Select mwkinfo.*,Iif(Isnull(mwkInfoAUX.Id),Val_CodPun,mwkInfoAUX.Id) As idinfo, PRE_retiroestudios, ;
		Pre_CodPrest,Space(10) As Demorado,mwkMedicosall1.nombre ;
		,prg_calcula_diahabil(VAL_fechasolicitud ,PRE_retiroestudios,"1,7") As fechaentrega, mwkInfoAUX.* ;
		from mwkinfo ;
		join mwkprestac On Pre_CodPrest = Pia_CodPrest ;
		Left Join mwkInfoAUX On mwkinfo.Val_CodPun = mwkInfoAUX.CodPun ;
		left Join mwkMedicosall1 On mwkMedicosall1.Id = mwkInfoAUX.CodMedFirma ;
		where (!Inlist(Nvl(mwkInfoAUX.Estadoinforme,0),1,2,5) Or Nvl(mwkInfoAUX.Id,0)=0) ;
		and VAL_NroProtocolo Not In (Select tpprotocolo From mwkanulados)  ;
		and VAL_NroProtocolo>0 And PRE_retiroestudios>0 And !Inlist(Pre_CodPrest,84020100,84020101,18010403,34100402);
		into Cursor mwkinfopre Readwrite
Endif
*  where nvl(mwkInfoAUX.Estadoinforme,0) <> 5 ;
*  or nvl(mwkInfoAUX.Id,0) = 0 )

Use In mwkInfoAUX




*!*	If Used('mwkinfopre')
*!*		If Reccount('mwkinfopre')>0
*!*			If !mtipo && control tipo = 2
*!*	*			Select * from mwkinfopre where fechaentrega = mfecdes into cursor mwkinfopre1

*!*				Select * ,fechainforme As finforme, ;
*!*					fechaaprobacion As faprobacion, ;
*!*					fecharecepcion As frecepcion ;
*!*					from mwkinfopre Where fechaentrega >= mfecdes And fechaentrega <= mfhasta;
*!*					into Cursor mwkinfopre1 Readwrite

*!*			Else
*!*	*			Select * from mwkinfopre where fechaentrega <= mfecdes into cursor mwkinfopre1

*!*				Select * , Nvl(fechainforme,mfnull) As finforme, ;
*!*					nvl(fechaaprobacion,mfnull) As faprobacion, ;
*!*					nvl(fecharecepcion,mfnull) As frecepcion ;
*!*					from mwkinfopre ;
*!*					Where fechaentrega <= mfhasta ;
*!*					Into Cursor mwkinfopre1 Readwrite

*!*			Endif
*!*		Endif
*!*	Endif


If Used('mwkinfopre')
	If Reccount('mwkinfopre')>0
		If !mtipo && control tipo = 2
*			Select * from mwkinfopre where fechaentrega = mfecdes into cursor mwkinfopre1

			Select * , Nvl(fechainforme,mfnull) As finforme, ;
				nvl(fechaaprobacion,mfnull) As faprobacion, ;
				nvl(fecharecepcion,mfnull) As frecepcion ;
				from mwkinfopre Where fechaentrega >= mfecdes And fechaentrega <= mfhasta;
				into Cursor mwkinfopre1 Readwrite

		Else
*			Select * from mwkinfopre where fechaentrega <= mfecdes into cursor mwkinfopre1

			Select * , Nvl(fechainforme,mfnull) As finforme, ;
				nvl(fechaaprobacion,mfnull) As faprobacion, ;
				nvl(fecharecepcion,mfnull) As frecepcion ;
				from mwkinfopre ;
				Where fechaentrega <= mfhasta ;
				Into Cursor mwkinfopre1 Readwrite

		Endif
	Endif
Endif


*mwkvalrelacion (fecAlta,fecPasiva,NrovaleOriginal,NroValeRelacionado,Usuario)

mret = SQLExec(mcon1,"select NrovaleOriginal,NroValeRelacionado"+;
	" from tabvalerelacion "+;
	" inner join informes on nrovale = NrovaleOriginal"+;
	" where fecPasiva = ?mfnull and informes.estadoinforme < 5","mwkvalrelacion")

If mret <= 0
	Messagebox("ERROR DE LECTURA, REINTENTE", 48, "VALIDACION")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

mret = SQLExec(mcon1,"select NrovaleOriginal,NroValeRelacionado"+;
	" from tabvalerelacion "+;
	" inner join informes on nrovale = NroValeRelacionado"+;
	" where  fecPasiva = ?mfnull and estadoinforme <5","mwkvalrelacion2")

If mret <= 0
	Messagebox("ERROR DE LECTURA, REINTENTE", 48, "VALIDACION")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

Select * From mwkvalrelacion2;
	union;
	select * From mwkvalrelacion;
	into Cursor mwkvalrelacion3

*Set Step On 
Select * From  mwkinfopre1 Where val_codvaleasist Not In(Select NroValeRelacionado From mwkvalrelacion3 );
	And   val_codvaleasist Not In(Select NrovaleOriginal From mwkvalrelacion3 ) ;
	Into Cursor  mwkinfopre1 Readwrite


Select mwkinfopre1
Scan All

	mcodpun      = mwkinfopre1.Val_CodPun
	mfechinfo    = mwkinfopre1.finforme
	mfechentrega = mwkinfopre1.fechaentrega
	If (mfechinfo > mfechentrega)
		Delete From mwkinfopre1 Where Val_CodPun = mcodpun
	Endif

	Select mwkinfopre1
Endscan



Use In mwkinfo
Use In mwkanulados
Use In mwkvalrelacion2
Use In mwkvalrelacion
Use In mwkvalrelacion3

If Used("mwkFeriados")
	Use In mwkFeriados
Endif
