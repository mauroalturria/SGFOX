****
** Armo evolucion del paciente
****
Parameter idevol,xctipo,mevol,lorden,xncantreg,copciones,mtipousu

If Vartype(xctipo)#"C"
	xctipo = ""
ENDIF

If Vartype(mevol)#"C"
	mevol = ""
Endif
If Vartype(mtipousu)#"N"
	mtipousu = 0
Endif
cfecha = prg_dtoc(Dtot(sp_busco_fecha_serv("DD")-1))
If left(mevol,8) = LEFT(cfecha,8)   
	cfecha = mevol
Endif

IF myip='172.16.1.7'
*SET STEP ON 
endif
If Vartype(copciones)#"C"
	copciones = '' &&&"EISsVMCN"    N nutricion
Endif
If !Used('MwkLegajo')      &&&&&& matricula SF
	Do sp_busco_mllegajo
Endif
mret = 1
mevol  = ''
miorden = " "
If Vartype(lorden)="N"
	miorden = " desc "
Endif
mret = 0
If Vartype(xncantreg) = "N"
	xcantreg = " top "+Transform(xncantreg)+" "
Else
	xcantreg = ''
Endif
If !Used('mwkMedicointall')
	Do sp_busco_med_pisos &&  with sp_busco_fecha_serv("DD")
	Select  Id, nombre,codesp,matricula As matriculas  From mwkmedicoint Where 1=2 Into Cursor mwkMedicouno
	Use In Select("mwksinmed")
	Use Dbf('mwkMedicouno') In 0 Again Alias mwksinmed
	Select mwksinmed
	Insert Into mwksinmed (Id, nombre,codesp,matriculas  ) Values (1,"MEDICO INTERNACION","",0)
	Select  Id, nombre,codesp,matricula As matriculas  From mwkmedicoint Union All;
		select * From mwksinmed Into Cursor mwkMedicointall
	Use In Select("mwksinmed")
	Use In Select("mwkMedicouno")
Endif

Do Case
Case xctipo = "SM"
	copciones = Iif(Empty(copciones),"Ss",copciones)
	mtipousu = 1
	If Empty(xcantreg)

		mret = SQLExec(mcon1, "select EIS_fechaH ,EIS_idevol ,EIS_observacion , EIS_tiposcore ,EIS_usuario "+;
			",EIS_valor ,EIS_usuario->nomape,EIS_usuario->idcodmed as ucodmed,EIS_usuario->leg_id  from TabIntScorNur"+;
			" where EIS_idevol = ?midevol and EIS_fechaH>=?cfecha  order by EIS_tiposcore ,id "+miorden  , "mwkevolScore")

	Else
		mret = SQLExec(mcon1, "select EIS_fechaH ,EIS_idevol ,EIS_observacion , EIS_tiposcore ,EIS_usuario "+;
			",EIS_valor ,EIS_usuario->nomape,EIS_usuario->idcodmed as ucodmed,EIS_usuario->leg_id  from TabIntScorNur"+;
			" inner join TabintHCE on  tabintHCE.id = TabIntScorNur.EIS_idevol " + ;
			" where tabintHCE.IH_admision = ?idevol and EIS_tiposcore = ?xncantreg and EIS_fechaH>=?cfecha  "+;
			" group by TabIntScorNur.id order by TabIntScorNur.id "+	miorden , "mwkevolScore")
	Endif

Case xctipo = "ICK"
	mtipousu = 1
	If Empty(xcantreg)
		mret = SQLExec(mcon1, "select  TabIntevolIC.*,EIC_usuario->nomape,EIC_usuario->idcodmed as ucodmed "+;
			" FROM TabIntevolIC "+;
			" where TabIntevolIC.EIC_idevol = ?idevol group by TabIntevolIC.id order by TabIntevolIC.id "+	miorden  , "mwkhistIC")
		mret = SQLExec(mcon1, "SELECT  TabIntEvolKine.*,nomape ,idcodmed  as ucodmed,leg_id  "+;
			" FROM TabIntEvolKine"+;
			" inner join tabusuario on tabusuario.idcodmed = TabIntEvolKine. EIK_codmed " + ;
			" where TabIntEvolKine.EIK_idevol = ?idevol "+;
			"order by TabIntEvolKine.id "+	miorden, "mwkEvolAK")
	Else
		mret = SQLExec(mcon1, "select &xcantreg TabIntevolIC.*,EIC_usuario->nomape,EIC_usuario->idcodmed as ucodmed "+;
			" FROM TabIntevolIC "+;
			" inner join TabintHCE on  tabintHCE.id = TabIntevolIC.EIC_idevol " + ;
			" where tabintHCE.IH_admision = ?idevol group by TabIntevolIC.id order by TabIntevolIC.id "+	miorden , "mwkhistIC")

		mret = SQLExec(mcon1, "SELECT  &xcantreg * "+;
			" from ("+;
			" SELECT Distinct tabintevolkine.* , nomape , idcodmed as ucodmed,leg_id  "+;
			" FROM tabintevolkine "+;
			" inner join (select * from tabintHCE "+;
			"             where exists(select 1 from tabintHCE where tabintHCE.IH_admision = ?idevol ) and "+;
			"             tabintHCE.IH_admision = ?idevol ) a on a.id = tabintevolkine.EIK_idevol "+;
			" inner join tabusuario on tabusuario.idcodmed = tabintevolkine.EIK_codmed ) b "+;
			" Order by id "+	miorden, "mwkEvolAK")
	Endif

	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16,"Validacion")
		Messagebox(eros(3))
		Do sp_desconexion With "Err sp_busco_protocolo_historia"
		Cancel
	Endif
	Select mwkEvolAK.Id,"KINE" As EIC_codesp,0 As EIC_codpun;
		,EIK_evoluc  As EIC_evolIC,EIK_fechaHora  As EIC_fechaHora ,eik_idevol As EIC_idevol;
		,EIK_codmed As EIC_usuario,Padr(Left(Iif(eik_tipo = 1,"AKM->",'AKR->')  +Alltrim(nomape),30),30) As nomape ,EIK_codmed As ucodmed, matriculas ;
		from mwkEvolAK ;
		left Join mwkMedicointall On EIK_codmed = mwkMedicointall.Id ;
		into Cursor mwkEvolAKt

	mevol = Iif(Reccount("mwkEvolAKt")+Reccount("mwkhistIC")=0,"SIN INFORMACION","")
	Select mwkhistIC.* ,matriculas From mwkhistIC Left Join mwkMedicointall On ucodmed = mwkMedicointall.Id Into Cursor mwkhistICd
	Select * From mwkhistICd Union All Select * From mwkEvolAKt Into Cursor mwkhistICa
	Select * From mwkhistICa Order By EIC_fechaHora &miorden Into Cursor mwkhistIC
	Use In Select("mwkhistICd" )
	Use In Select("mwkhistICa" )
	Use In Select("mwkEvolAKt" )
	Use In Select("mwkEvolAK" )
	Select mwkhistIC
	Scan
		If !Empty(Alltrim(Nvl(EIC_evolIC ,'')))
			mevol = mevol +Space(100)+Ttoc(EIC_fechaHora ) +Chr(10)+ "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " +;
				chr(10) + Alltrim(nomape)+ Iif(Nvl(matriculas,0) <>0, " M.N.:"+Transform(matriculas),"")+ Chr(10) + Alltrim(EIC_evolIC )+Chr(10)
		Endif
	Endscan


Case xctipo = "IC"
	mtipousu = 1
	If Empty(xcantreg)
		mret = SQLExec(mcon1, "select  TabIntevolIC.*,EIC_usuario->nomape,EIC_usuario->idcodmed as ucodmed,EIC_usuario->leg_id  "+;
			" FROM TabIntevolIC "+;
			" where TabIntevolIC.EIC_idevol = ?idevol group by TabIntevolIC.id order by TabIntevolIC.id "+	miorden  , "mwkhistIC")
	Else
		mret = SQLExec(mcon1, "select &xcantreg TabIntevolIC.*,EIC_usuario->nomape,EIC_usuario->idcodmed as ucodmed,EIC_usuario->leg_id  "+;
			" FROM TabIntevolIC "+;
			" inner join TabintHCE on  tabintHCE.id = TabIntevolIC.EIC_idevol " + ;
			" where tabintHCE.IH_admision = ?idevol group by TabIntevolIC.id order by TabIntevolIC.id "+	miorden , "mwkhistIC")
	Endif
	mevol = Iif(Reccount("mwkhistIC")=0,"SIN INFORMACION","")
	Select mwkhistIC.* ,matriculas From mwkhistIC Left Join mwkMedicointall On ucodmed = mwkMedicointall.Id Into Cursor mwkhistICd
	Select * From mwkhistICd Into Cursor mwkhistIC
	Use In Select("mwkhistICd" )
	Select mwkhistIC
	Scan
		If !Empty(Alltrim(Nvl(EIC_evolIC ,'')))
			mevol = mevol +Space(100)+Ttoc(EIC_fechaHora ) +Chr(10)+ "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " +;
				chr(10) + Alltrim(nomape)+ Iif(Nvl(matriculas,0) <>0, " M.N.:"+Transform(matriculas),"")+ Chr(10) + Alltrim(EIC_evolIC )+Chr(10)
		Endif
	Endscan


Case xctipo = "NUT"  && interconsultas de nutricion
	mtipousu = 1
	If Empty(xcantreg)
		mret = SQLExec(mcon1, "select  TabIntevolIC.*,EIC_usuario->nomape,EIC_usuario->idcodmed as ucodmed,EIC_usuario->leg_id  "+;
			" FROM TabIntevolIC "+;
			" where TabIntevolIC.EIC_idevol = ?idevol and EIC_codesp = 'DIET' "+;
			" group by TabIntevolIC.id order by TabIntevolIC.id "+	miorden  , "mwkEvolNUT")
	Else
		mret = SQLExec(mcon1, "select &xcantreg TabIntevolIC.*,EIC_usuario->nomape,EIC_usuario->idcodmed as ucodmed,EIC_usuario->leg_id  "+;
			" FROM TabIntevolIC "+;
			" inner join TabintHCE on  tabintHCE.id = TabIntevolIC.EIC_idevol " + ;
			" where tabintHCE.IH_admision = ?idevol and EIC_codesp = 'DIET' "+;
			" group by TabIntevolIC.id order by TabIntevolIC.id "+	miorden , "mwkEvolNUT")
	Endif
	mevol = Iif(Reccount("mwkEvolNUT")=0,"SIN INFORMACION","")
	Select mwkEvolNUT.* ,matriculas From mwkEvolNUT Left Join mwkMedicointall On ucodmed = mwkMedicointall.Id Into Cursor mwkhistICd
	Select * From mwkhistICd Into Cursor mwkhistIC
	Use In Select("mwkhistICd" )
	Select mwkhistIC
	Scan
		If !Empty(Alltrim(Nvl(EIC_evolIC ,'')))
			mevol = mevol +Space(100)+Ttoc(EIC_fechaHora ) +Chr(10)+ "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " +;
				chr(10) + Alltrim(nomape)+ Iif(Nvl(matriculas,0) <>0, " M.N.:"+Transform(matriculas),"")+ Chr(10) + Alltrim(EIC_evolIC )+Chr(10)
		Endif
	Endscan

Case xctipo = "FONO"  && interconsultas de fono
	mtipousu = 1
	If Empty(xcantreg)
		mret = SQLExec(mcon1, "select  TabIntevolIC.*,EIC_usuario->nomape,EIC_usuario->idcodmed as ucodmed,EIC_usuario->leg_id  "+;
			" FROM TabIntevolIC "+;
			" where TabIntevolIC.EIC_idevol = ?idevol and EIC_codesp = 'FONO' "+;
			" group by TabIntevolIC.id order by TabIntevolIC.id "+	miorden  , "mwkEvolFONO")
	Else
		mret = SQLExec(mcon1, "select &xcantreg TabIntevolIC.*,EIC_usuario->nomape,EIC_usuario->idcodmed as ucodmed,EIC_usuario->leg_id  "+;
			" FROM TabIntevolIC "+;
			" inner join TabintHCE on  tabintHCE.id = TabIntevolIC.EIC_idevol " + ;
			" where tabintHCE.IH_admision = ?idevol and EIC_codesp = 'FONO' "+;
			" group by TabIntevolIC.id order by TabIntevolIC.id "+	miorden , "mwkEvolFONO")
	Endif
	mevol = Iif(Reccount("mwkEvolFONO")=0,"SIN INFORMACION","")
	Select mwkEvolFONO.* ,matriculas From mwkEvolFONO Left Join mwkMedicointall On ucodmed = mwkMedicointall.Id Into Cursor mwkhistICd
	Select * From mwkhistICd Into Cursor mwkhistIC
	Use In Select("mwkhistICd" )
	Select mwkhistIC
	Scan
		If !Empty(Alltrim(Nvl(EIC_evolIC ,'')))
			mevol = mevol +Space(100)+Ttoc(EIC_fechaHora ) +Chr(10)+ "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " +;
				chr(10) + Alltrim(nomape)+ Iif(Nvl(matriculas,0) <>0, " M.N.:"+Transform(matriculas),"")+ Chr(10) + Alltrim(EIC_evolIC )+Chr(10)
		Endif
	Endscan

Case xctipo = "EM"
	copciones = Iif(Empty(copciones),"S",copciones)
	mtipousu = 1
	If Empty(xcantreg)
		mret = SQLExec(mcon1, "SELECT tabintevolmed.*,nomape as nombre,idcodmed as ucodmed,leg_id   FROM tabintevolmed  "+;
			" inner join tabusuario on tabusuario.idcodmed = tabintevolmed.EIM_codmed " + ;
			" where EIM_idevol = ?idevol group by tabintevolmed.id order by tabintevolmed.id "+	miorden , "mwkEvolmed")

	Else
		mret = SQLExec(mcon1, "SELECT &xcantreg * "+;
			" from ("+;
			" SELECT Distinct tabintevolmed.* , nomape as nombre , idcodmed as ucodmed,leg_id  "+;
			" FROM tabintevolmed "+;
			" inner join (select * from tabintHCE "+;
			"             where exists (select 1 from tabintHCE where tabintHCE.IH_admision = ?idevol ) and "+;
			"             tabintHCE.IH_admision = ?idevol ) a on a.id = tabintevolmed.EIM_idevol "+;
			" inner join tabusuario on tabusuario.idcodmed = tabintevolmed.EIM_codmed ) b   "+;
			" Order by id " +miorden  , "mwkEvolmed")
	Endif

	mevol = Iif(Reccount("mwkEvolmed")=0,"SIN INFORMACION","")
	Select mwkEvolmed.* ,matriculas From mwkEvolmed Left Join mwkMedicointall On ucodmed = mwkMedicointall.Id Into Cursor mwkEvolmedd
	Select * From mwkEvolmedd Into Cursor mwkEvolmed
	Use In Select("mwkEvolmedd" )
	Select mwkEvolmed

	Scan
		If !Isnull(Nvl(EIM_evol,''))
			mevol = mevol + Space(100)+ Ttoc(EIM_fechah)+Chr(10)+ "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " +;
				chr(10) + Left(nombre,15)+ Iif(Nvl(matriculas,0)<>0, " M.N.:"+Transform(matriculas),"")+Chr(10) + Alltrim(EIM_evol)+ Chr(10)
		Endif
	Endscan

Case xctipo = "II"
	mtipousu = 1
	If Empty(xcantreg)

		mret = SQLExec(mcon1, "SELECT tabintevolmed.*,nomape as nombre,idcodmed as ucodmed,leg_id   FROM tabintevolmed  "+;
			" inner join tabusuario on tabusuario.idcodmed = tabintevolmed.EIM_codmed " + ;
			" where EIM_idevol = ?idevol group by tabintevolmed.id order by tabintevolmed.id "+	miorden , "mwkEvolmed")

	Else
		mret = SQLExec(mcon1, "SELECT &xcantreg * "+;
			" from ("+;
			" SELECT Distinct tabintevolmed.* , nomape as nombre , idcodmed as ucodmed,leg_id  "+;
			" FROM tabintevolmed "+;
			" inner join (select * from tabintHCE "+;
			"             where exists(select 1 from tabintHCE where tabintHCE.IH_admision = ?idevol ) and "+;
			"             tabintHCE.IH_admision = ?idevol ) a on a.id = tabintevolmed.EIM_idevol "+;
			" inner join tabusuario on tabusuario.idcodmed = tabintevolmed.EIM_codmed ) b "+;
			" Order by  id "+miorden , "mwkEvolmed")
	Endif

	If Empty(xcantreg)

		mret = SQLExec(mcon1, "SELECT Tabintobsenf.*,nomape as nombre,idcodmed as ucodmed,leg_id   FROM Tabintobsenf"+;
			" inner join tabusuario on tabusuario.idusuario  = Tabintobsenf.OBS_usuario " + ;
			" where OBS_sector= 4 and OBS_idevol = ?idevol group by Tabintobsenf.id " , "mwkobsii")

	Else
		mret = SQLExec(mcon1, " SELECT &xcantreg Tabintobsenf.* , nomape as nombre , idcodmed as ucodmed,leg_id  "+;
			" FROM Tabintobsenf "+;
			" inner join tabintHCE on tabintHCE.id = Tabintobsenf.OBS_idevol  "+;
			" inner join tabusuario on tabusuario.idusuario  = Tabintobsenf.OBS_usuario "+;
			" where tabintHCE.IH_admision = ?idevol "+;
			" and OBS_sector=4 ", "mwkobsii")
	Endif

	Select Id,OBS_fechor As EIM_fechah ,OBS_obser As EIM_indicacion,nombre ,ucodmed,leg_id From mwkobsii Into Cursor mwkobsindmed

	Select * From mwkobsindmed Union All ;
		SELECT Id,EIM_fechah ,EIM_indicacion, nombre ,ucodmed,leg_id From mwkEvolmed Into Cursor mwkobsenf

	mevol = Iif(Reccount("mwkobsenf")=0,"SIN INFORMACION","")
	Select mwkobsenf.* ,matriculas From mwkobsenf Left Join mwkMedicointall On ucodmed = mwkMedicointall.Id Order By mwkobsenf.Id &miorden Into Cursor mwkEvolmedd
	Select * From mwkEvolmedd Into Cursor mwkEvolmed
	Use In Select("mwkEvolmedd" )
	Select mwkEvolmed
	Scan
		If !Empty(Nvl(EIM_indicacion,'')) And EIM_fechah>=Ctod("01/09/2016")
			mevol = mevol + Space(100)+ Ttoc(EIM_fechah)+Chr(10)+ "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " +;
				chr(10) + Left(nombre,15)+ Iif(Nvl(matriculas,0)<>0, " M.N.:"+Transform(matriculas),"")+Chr(10) + Alltrim(EIM_indicacion)+ Chr(10)
		Endif
	Endscan

Case xctipo = "EN"
	copciones = Iif(Empty(copciones),"ECMVSs",copciones)
	mtipousu = 2

	If Empty(xcantreg)

		mret = SQLExec(mcon1, "select EIN_codCIENanda,EIN_evolNurse ,EIN_fechaH, EIN_parAdmF ,EIN_parAlerg "+;
			",EIN_parAlergQue ,EIN_parOtros ,EIN_idevol ,EIN_usuario->nomape,EIN_usuario->idcodmed as ucodmed,EIN_usuario->leg_id  from TabIntEvolNurse"+;
			" where EIN_idevol = ?idevol order by TabIntEvolNurse.id "+	miorden , "mwkevolNur")

	Else
		mret = SQLExec(mcon1, "select &xcantreg EIN_codCIENanda,EIN_evolNurse ,EIN_fechaH, EIN_parAdmF ,EIN_parAlerg "+;
			",EIN_parAlergQue ,EIN_parOtros ,EIN_idevol ,EIN_usuario->nomape, EIN_usuario->idcodmed as ucodmed,EIN_usuario->leg_id  from TabIntEvolNurse"+;
			" inner join TabintHCE on  tabintHCE.id = TabIntEvolNurse.EIN_idevol " + ;
			" where tabintHCE.IH_admision = ?idevol group by TabIntEvolNurse.id order by TabIntEvolNurse.id "+	miorden , "mwkevolNur")

	Endif

	mevol = Iif(Reccount("mwkevolNur")=0,"SIN INFORMACION","")
	Select mwkevolNur
	Scan
		If !Empty(Alltrim(Nvl(EIN_evolNurse,'')))

			mevol = mevol + Space(100)+ Ttoc(EIN_fechaH )+Chr(10)+ "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " +;
				chr(10) + Alltrim(nomape)+Chr(10) + Alltrim(EIN_evolNurse )+ Chr(10)

		Endif
	Endscan
Case xctipo = "ES"
	copciones = Iif(Empty(copciones),"s",copciones)
	mtipousu = 0
	If !Used('mwkescormed')
		Do sp_busco_estados With 25,' and tipo = 33 order by estado ','mwkescormed'
	Endif
	If Empty(xcantreg)
		mret = SQLExec(mcon1, "select  Tabintscornur.*,EIS_usuario->nomape,EIS_usuario->idcodmed as ucodmed,EIS_usuario->leg_id  "+;
			" FROM Tabintscornur"+;
			" where Tabintscornur.EIS_idevol = ?idevol group by Tabintscornur.id order by Tabintscornur.id "+	miorden  , "mwkhistSCR")
	Else
		mret = SQLExec(mcon1, "select &xcantreg Tabintscornur.*,EIS_usuario->nomape,EIS_usuario->idcodmed as ucodmed,EIS_usuario->leg_id  "+;
			" FROM Tabintscornur"+;
			" inner join TabintHCE on  tabintHCE.id = Tabintscornur.EIS_idevol " + ;
			" where tabintHCE.IH_admision = ?idevol group by Tabintscornur.id order by Tabintscornur.id "+	miorden , "mwkhistSCR")
	Endif
	mevol = Iif(Reccount("mwkhistSCR")=0,"SIN INFORMACION","")
	Select mwkhistSCR.*,mwkescormed.Descrip,matriculas  From mwkhistSCR,mwkescormed ;
		left Join mwkMedicointall On ucodmed = mwkMedicointall.Id ;
		left Join mwkMedicointall On ucodmed = mwkMedicointall.Id ;
		where mwkhistSCR.EIS_tiposcore=mwkescormed.estado ;
		order By Descrip , mwkhistSCR.Id Into Cursor mwkhistScore

	If Reccount('mwkhistScore')>0
		Go Top
		mitipo = EIS_tiposcore
		mevol = Descrip +Chr(10)
		mevol = mevol +"  Fecha - Hora         Valor      Profesional     "  +Chr(10)
		Do While !Eof()
			Do While !Eof() And mitipo = EIS_tiposcore
				If !Inlist(mitipo,9,10)
					mevol = mevol +Ttoc(EIS_fechaH)+ Transform( EIS_valor ,"99999") +;
						"  -  "+ Alltrim(nomape)+Iif(Nvl(matriculas,0)<>0, " M.N.:"+Transform(matriculas),"")+Iif(!Empty(EIS_observacion)," Observaciones:"+Alltrim(EIS_observacion ),'')+Chr(10)+;
						iif(mitipo#7,'',"             Riesgo:"  + ;
						iif(EIS_valor >16 ,"ALTO",Iif(EIS_valor<11 ,"BAJO","MODERADO") )+Chr(10))

				Endif
				Skip
			Enddo
			mitipo = EIS_tiposcore
			If !Eof()
				mevol = mevol +Chr(10)+Descrip +Chr(10)
				mevol = mevol +"  Fecha - Hora         Valor      Profesional     "  +Chr(10)
			Endif
		Enddo
	Endif


Case xctipo = "AKM"
	If Empty(xcantreg)

		mret = SQLExec(mcon1, "SELECT TabIntEvolKine.*,nomape as nombre,idcodmed as ucodmed,leg_id     FROM TabIntEvolKine"+;
			" inner join tabusuario on tabusuario.idcodmed = TabIntEvolKine. EIK_codmed " + ;
			" where EIK_tipo  = 1 and EIK_idevol = ?idevol group by TabIntEvolKine.id order by TabIntEvolKine.id "+	miorden  , "mwkEvolAKM")
	Else
		mret = SQLExec(mcon1, "SELECT &xcantreg TabIntEvolKine.*,nomape as nombre,idcodmed as ucodmed,leg_id     "+;
			" FROM TabIntEvolKine"+;
			" inner join tabusuario on tabusuario.idcodmed = TabIntEvolKine. EIK_codmed " + ;
			" inner join TabintHCE on  tabintHCE.id = TabIntEvolKine.EIK_idevol " + ;
			" where EIK_tipo  = 1 and tabintHCE.IH_admision = ?idevol group by TabIntEvolKine.id order by TabIntEvolKine.id "+	miorden, "mwkEvolAKM")

	Endif
	mevol = Iif(Reccount("mwkEvolAKM")=0,"SIN INFORMACION","")
	Select mwkEvolAKM.* ,matriculas From mwkEvolAKM Left Join mwkMedicointall On ucodmed = mwkMedicointall.Id Into Cursor mwkEvolAKMd
	Select * From mwkEvolAKMd Into Cursor mwkEvolAKM
	Use In Select("mwkEvolAKMd" )
	Select mwkEvolAKM
	Scan
		If !Isnull(Nvl(EIK_evoluc ,''))
			mevol = mevol + Space(100)+ Ttoc(EIK_fechaHora )+Chr(10)+ "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " +;
				chr(10) + Left(nombre,15)+Iif(Nvl(matriculas,0)<>0, " M.N.:"+Transform(matriculas),"")+Chr(10) + Alltrim(EIK_evoluc )+ Chr(10)
		Endif
	Endscan
Case xctipo = "AKR"
	If Empty(xcantreg)

		mret = SQLExec(mcon1, "SELECT TabIntEvolKine.*,nomape as nombre,idcodmed as ucodmed,leg_id     FROM TabIntEvolKine "+;
			" inner join tabusuario on tabusuario.idcodmed = TabIntEvolKine. EIK_codmed " + ;
			" where EIK_tipo  = 2 and EIK_idevol = ?idevol group by TabIntEvolKine.id order by TabIntEvolKine.id "+	miorden , "mwkEvolAKR")
	Else
		mret = SQLExec(mcon1, "SELECT &xcantreg TabIntEvolKine.*,nomape as nombre,idcodmed as ucodmed,leg_id     "+;
			" FROM TabIntEvolKine"+;
			" inner join tabusuario on tabusuario.idcodmed = TabIntEvolKine. EIK_codmed " + ;
			" inner join TabintHCE on  tabintHCE.id = TabIntEvolKine.EIK_idevol " + ;
			" where EIK_tipo  = 2 and tabintHCE.IH_admision = ?idevol group by TabIntEvolKine.id order by TabIntEvolKine.id "+	miorden, "mwkEvolAKR")

	Endif
	mevol = Iif(Reccount("mwkEvolAKR")=0,"SIN INFORMACION","")
	Select mwkEvolAKR.* ,matriculas From mwkEvolAKR Left Join mwkMedicointall On ucodmed = mwkMedicointall.Id Into Cursor mwkEvolAKRd
	Select * From mwkEvolAKRd Into Cursor mwkEvolAKR
	Use In Select("mwkEvolAKRd" )
	Select mwkEvolAKR
	Scan
		If !Isnull(Nvl(EIK_evoluc ,''))
			mevol = mevol + Space(100)+ Ttoc(EIK_fechaHora )+Chr(10)+ "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " +;
				chr(10) + Left(nombre,15)+Iif(Nvl(matriculas,0)<>0, " M.N.:"+Transform(matriculas),"")+Chr(10) + Alltrim(EIK_evoluc )+ Chr(10)
		Endif
	Endscan


Case xctipo = "RH"  && resumen de historia
	If Empty(xcantreg)
		mret = SQLExec(mcon1, "SELECT TabIntResumenHC.*,RH_usuario->nomape as nombre,RH_usuario->idcodmed as ucodmed,RH_usuario->leg_id  "+;
			"FROM TabIntResumenHC "+;
			" where RH_idevol = ?idevol group by TabIntResumenHC.id order by TabIntResumenHC.id "+	miorden , "mwkEvolmed")
	Else
		mret = SQLExec(mcon1, "SELECT &xcantreg TabIntResumenHC.*,RH_usuario->nomape as nombre,RH_usuario->idcodmed as ucodmed,RH_usuario->leg_id  "+;
			" FROM TabIntResumenHC "+;
			" inner join TabintHCE on  tabintHCE.id = TabIntResumenHC.RH_idevol" + ;
			" where tabintHCE.IH_admision = ?idevol group by TabIntResumenHC.id order by TabIntResumenHC.id "+	miorden , "mwkEvolmed")

	Endif

	mevol = Iif(Reccount("mwkEvolmed")=0,"SIN INFORMACION","")
	Select mwkEvolmed.* ,matriculas From mwkEvolmed Left Join mwkMedicointall On ucodmed = mwkMedicointall.Id Into Cursor mwkEvolmedd
	Select * From mwkEvolmedd Into Cursor mwkEvolmed
	Use In Select("mwkEvolmedd" )
	Select mwkEvolmed
	Scan
		If !Empty(Nvl(RH_resumen,'')) And RH_fechaHora>=Ctod("01/09/2016")
			mevol = mevol + Space(100)+ Ttoc(RH_fechaHora)+Chr(10)+ "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - " +;
				chr(10) + Left(nombre,15)+ Iif(Nvl(matriculas,0)<>0, " M.N.:"+Transform(matriculas),"")+Chr(10) + Alltrim(RH_resumen)+ Chr(10)
		Endif
	Endscan


Endcase
mevolr = ''
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
Else
	mbususu = ''
	If mtipousu<9
		mbususu = ' and  EIP_tipoUsuario  = ?mtipousu '
	Endif
	If Empty(xcantreg)

		mret = SQLExec(mcon1, "select TabIntEvolParcial.* ,EIP_usuario->nomape,EIP_usuario->idcodmed as ucodmed,EIP_usuario->leg_id      "+;
			" from TabIntEvolParcial "+;
			" where EIP_idevol =  ?idevol &mbususu  order by EIP_fechaH " + miorden + ',TabIntEvolParcial.id desc '  , "mwkevolparcial")

	Else
		mret = SQLExec(mcon1, "select &xcantreg TabIntEvolParcial.* ,EIP_usuario->nomape,EIP_usuario->idcodmed as ucodmed,EIP_usuario->leg_id     "+;
			" from TabIntEvolParcial "+;
			" inner join TabintHCE on EIP_idevol = TabintHCE.id "+;
			" where IH_admision = ?idevol  "+mbususu +;
			" group by TabIntEvolParcial.id order by EIP_fechaH " + miorden + ',TabIntEvolParcial.id desc '  , "mwkevolparcial")

	Endif
	If Used('mwkevolparcial')
		Select mwkevolparcial.* ,matriculas,SF_NroMatricula,Tipomat ;
			From mwkevolparcial ;
			Left Join mwkMedicointall On ucodmed = mwkMedicointall.Id ;
			Left Join MwkLegajo On MwkLegajo.LEG_ID = mwkevolparcial.LEG_ID ;
			Into Cursor mwkevolparciald
		Select * From mwkevolparciald Into Cursor mwkevolparcial
		Use In Select("mwkevolparciald" )
		Select mwkevolparcial
		If Reccount()>0
			Do While !Eof()
				miusu = EIP_usuario
				midia = EIP_fechaH
				lcabe = .T.
				Do While midia = EIP_fechaH  And miusu = EIP_usuario And !Eof()
					Do Case
					Case EIP_tipoEvol = "E" And ("E" $ copciones)
						mevolr = mevolr + Iif(lcabe, Chr(10)+Ttoc(EIP_fechaH ) + " - " + Allt(nomape )+ Iif(Nvl(matriculas,0)<>0, " M.N.:"+Transform(matriculas)+ " - "+Chr(10),;
							Iif(Nvl(SF_NroMatricula ,0) <>0, " M."+Tipomat+".:"+Transform(SF_NroMatricula)+ " - "+Chr(10),'')),'')+;
							"Evolución: "+Chr(10)+Alltrim(EIP_evol )
						lcabe = .F.
					Case EIP_tipoEvol = "V" And ("V" $ copciones)
						mevolr = mevolr + Iif(lcabe, Chr(10)+Ttoc(EIP_fechaH ) + " - " + Allt(nomape )+ Iif(Nvl(matriculas,0)<>0, " M.N.:"+Transform(matriculas)+ " - ",;
							Iif(Nvl(SF_NroMatricula ,0) <>0, " M."+Tipomat+".:"+Transform(SF_NroMatricula)+ " - ",'')),'')+;
							chr(10)+Alltrim(EIP_evol )
						lcabe = .F.
					Case EIP_tipoEvol = "M" And ("M" $ copciones)
						mevolr = mevolr + Iif(lcabe, Chr(10)+Ttoc(EIP_fechaH ) + " - " + Allt(nomape )+ Iif(Nvl(matriculas,0)<>0, " M.N.:"+Transform(matriculas)+ " - ",;
							Iif(Nvl(SF_NroMatricula ,0) <>0, " M."+Tipomat+".:"+Transform(SF_NroMatricula)+ " - ",'')),'')+;
							chr(10)+Alltrim(EIP_evol )
						lcabe = .F.
					Case EIP_tipoEvol = "C" And ("C" $ copciones)
						mevolr = mevolr + Iif(lcabe, Chr(10)+Ttoc(EIP_fechaH ) + " - " + Allt(nomape )+ Iif(Nvl(matriculas,0)<>0, " M.N.:"+Transform(matriculas)+ " - ",;
							Iif(Nvl(SF_NroMatricula ,0) <>0, " M."+Tipomat+".:"+Transform(SF_NroMatricula)+ " - ",'')),'')+;
							"Cuidados realizados" +Chr(10)+Alltrim(EIP_evol )
						lcabe = .F.
					Case EIP_tipoEvol = "S" And ("S" $ copciones)
						mevolr = mevolr + Iif(lcabe, Chr(10)+Ttoc(EIP_fechaH ) + " - " + Allt(nomape )+ Iif(Nvl(matriculas,0)<>0, " M.N.:"+Transform(matriculas)+ " - ",;
							Iif(Nvl(SF_NroMatricula ,0) <>0, " M."+Tipomat+".:"+Transform(SF_NroMatricula)+ " - ",'')),'')+;
							"Escores" +Chr(10)+Alltrim(EIP_evol )
						lcabe = .F.
					Case EIP_tipoEvol = "s" And ("s" $ copciones)
						mevolr = mevolr + Iif(lcabe, Chr(10)+Ttoc(EIP_fechaH ) + " - " + Allt(nomape )+ Iif(Nvl(matriculas,0)<>0, " M.N.:"+Transform(matriculas)+ " - ",;
							Iif(Nvl(SF_NroMatricula ,0) <>0, " M."+Tipomat+".:"+Transform(SF_NroMatricula)+ " - ",'')),'')+;
							"Escores" +Chr(10)+Alltrim(EIP_evol )
						lcabe = .F.
					Case EIP_tipoEvol = "N" And ("N" $ copciones)
						mevolr = mevolr + Iif(lcabe, Chr(10)+Ttoc(EIP_fechaH ) + " - " + Allt(nomape )+ Iif(Nvl(matriculas,0)<>0, " M.N.:"+Transform(matriculas)+ " - "+Chr(10),;
							Iif(Nvl(SF_NroMatricula ,0) <>0, " M."+Tipomat+".:"+Transform(SF_NroMatricula)+ " - "+Chr(10),'')),'')+;
							"Valoración Objetiva: "+Chr(10)+Alltrim(EIP_evol )
						lcabe = .F.
					Case EIP_tipoEvol = "M" And ("M" $ copciones)
						mevolr = mevolr + Iif(lcabe, Chr(10)+Ttoc(EIP_fechaH ) + " - " + Allt(nomape )+ Iif(Nvl(matriculas,0) <>0, " M.N.:"+Transform(matriculas)+ " - "+Chr(10),;
							Iif(Nvl(SF_NroMatricula ,0) <>0, " M."+Tipomat+".:"+Transform(SF_NroMatricula)+ " - "+Chr(10),'')),'')+;
							"Valoración Subjetiva: "+Chr(10)+Alltrim(EIP_evol )
						lcabe = .F.

					Endcase
					Select mwkevolparcial
					Skip 1
				Enddo
			Enddo
		Endif
	Endif

	If Empty(miorden)
		mevol  = mevol  + mevolr
	Else && desc
		mevol  = mevolr  + mevol
	Endif
Endif
