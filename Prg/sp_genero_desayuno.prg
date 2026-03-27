*!*	---------------------------------------------------------------------------
*!*	Preparo el desayuno
*!*
*!*	EL REPROCESO ES SOLO PARA EL DIA DE LA FECHA
*!*
*!*	do sp_genero_desayuno with DATE(), 2+ 1, 1
*!*	do sp_genero_desayuno with DATE(), 2+ 2, 1
*!*	---------------------------------------------------------------------------
Parameter mfecha, mtiposer, mrepro,mprueba

If Vartype(mfecha)#"D"
	mfecha = sp_busco_fecha_serv("DD")
Endif
If Vartype(mtiposer)#"N"
	mtiposer = 3
Endif
If Vartype(mrepro)#"N"
	mrepro = 0
Endif
mindimed = ''
If Vartype(mprueba)#"N"
	mprueba = 0
Endif
Dimension cf(100)
Store '' To cf
Do sp_busco_estados With 60,' and tipo = 0 ','mwkcambioingr' &&&ingrediente a cambiar en  Areas cerradasc

Do sp_busco_estados With 7,' and tipo = 15 ','mwkHabUrgencia' &&&busca Areas cerradasc
lareacerrada = ''
Go Top In 'mwkHabUrgencia'
*!*	madm = ''
*!*	IF DATE()=CTOD("31/03/2025")
*!*	madm =  " and TNP_codadmision in ('641362-0','675761-0') "
*!*	endif
Select mwkHabUrgencia
msechab = ''
Scan
	If mwkHabUrgencia.estado > 1 &&or mwkusuario.Sector = "SISTEMAS"
		msechab = msechab + Alltrim(mwkHabUrgencia.Descrip) +","
	Endif
Endscan
msechab = Left(msechab,Len(msechab)-1)
lareacerrada = Strtran(msechab,"EME","NADA")

If  Int(mtiposer/2)*2 <> mtiposer && =3
	mdiaant  = mfecha - 1
	mtipoant = mtiposer + 1
Else
	mdiaant  = mfecha
	mtipoant = mtiposer -1
Endif
*19010222,19010223,19010246
mfechanull  = "1900-01-01 00:00:00"
mfechabaja = mwkfecserv.fechahora
mfechabajaay = mfechabaja

*!*	Do sp_busco_tabintnut With 4, " order by IH_admision,ih_secuencia " ;
*!*		,'mwkIntNutsuspp'
*!*	Select * From mwkIntNutsuspp Group By IH_admision Into Cursor mwkIntNutsuspa
*!*	Select * From mwkIntNutsuspp  Where  IH_admision+Transform(ih_secuencia,"99") ;
*!*			in (Select  IH_admision+Transform(ih_secuencia,"99") From mwkIntNutsuspa) Into Cursor mwkIntNutsusp

*!*	Select IH_admision From mwkIntNutsusp Where INA_fechaHoraIni <= mfechabaja Into Cursor mwkayunos
*  19010235,19010234       19010215
Do sp_busco_tabintnut With 4, " order by IH_admision  ", 'mwkIntNutsusp'
Select ih_admision From mwkIntNutsusp Where ina_fechahoraini <= mfechabaja Into Cursor  mwkayunos
Select ih_admision,"AYUNO desde:" + Ttoc(ina_fechahoraini) As ayuno From mwkIntNutsusp  ;
	WHERE ina_fechahoraini <=  mfechabaja Into Cursor   mwkayunos
Do sp_busco_tabintnut With 3, "  order by IH_admision,ih_secuencia ",'mwkIntNutUCIp'
Select * From mwkIntNutUCIp Group By IH_admision,in_idevol,in_codprest Into Cursor mwkIntNutprevio
Select * From mwkIntNutprevio Group By IH_admision, in_codprest Into Cursor mwkIntNutUCIp

Select * From mwkIntNutUCIp Group By IH_admision Into Cursor mwkIntNutUCIa
Select * From mwkIntNutUCIp Where  (IH_secagrup In ('UCI','UCR' ) Or pac_sectorinternac In ('UC6','UCO'))   ;
	AND IN_codprest In (19010234,19010235,19010245,19010215,19010236)  And IH_admision+Transform(ih_secuencia,"99") ;
	in (Select  IH_admision+Transform(ih_secuencia,"99") From mwkIntNutUCIa) Into Cursor mwkIntNutUCI &&& iddsi+DBT en UCI

Select * From mwkIntNutUCIp Where  IN_codprest In (19010235,19010234,19010215)  Into Cursor mwkIntNutdbt45

Select Count(IH_admision) As cuantos,* From mwkIntNutdbt45 Group By IH_admision Into Cursor mwkIntsumdbt45
Select * From mwkIntsumdbt45 Where cuantos>1 Into Cursor mwkIntNutdbt45
Select * From mwkIntNutUCIp Where  IN_codprest In (19010235,19010234 ) And  IH_admision;
	NOT In (Select IH_admision From mwkIntNutdbt45 Where IN_codprest=IN_codprest )  Into Cursor mwkIntNutnodbt45
If mwkusuario.idusuario="CARMENA"
	Set Step On
Endif
*---------------------------------------------------------------------------------
*!*	9400 - ALIMENTACION

mret =	SQLExec(mcon1, "select pre_codprest, PRE_descriprest " + ;
	"from prestacions " + ;
	"where pre_codservicio = 9400 and PRE_fechapasiva is null " , "mwkpres")

If mret<1
	=Aerr(eros)
	Messagebox(eros(2))
Endif
*---------------------------------------------------------------------------------
Do sp_busco_agrup && Obtiene mwkTNagr && Agrupamientos
Do sp_busco_ingred && Obtiene mwkTNIngr && Ingredientes


mfecpas = Ctod("01/01/1900")

&& Agrupamientos y cantidad de ingredientes que agrupa
Select  TNA_CodAgr, TNA_Descripcion, Count(TN_CodAgr) As cantxgr ;
	from mwkTNIngr ;
	left Join mwkTNagr On TNA_CodAgr = TN_CodAgr ;
	group By TN_CodAgr ;
	into Cursor mwktotgr


*---------------------------------------------------------------------------------------------

mret = SQLExec(mcon1, "select PAC_habitacion, PAC_cama, PAC_nombrepaciente, " + ;
	"PAC_descripdiagn, PAC_fechaadmision, PAC_horaadmision, pin_codentidad, PAC_edad, " + ;
	"PAC_codadmision, PAC_fecnacimiento, PAC_codhci, " + ;
	"sec_descripsec, entidexclu.fecpasiva, TabNutPaciente.*, TNP_codfactu, " + ;
	"TNP_factura, TNP_dieta,TNP_Observaciones,  " + ;
	"TND_idPaciente, TND_codPrest, TND_NroVale, TND_FHoraCarga, TND_observa,PAC_sectorinternac " + ;
	"from pacinternad " + ;
	"left join pacientes on pacinternad.pin_codadmision = pacientes.PAC_codadmision " + ;
	"left join habitacions on habitacions.hab_codpaciente = pacientes.PAC_codadmision " + ;
	"left outer join sectores on sectores.sec_codsector = pacientes.PAC_sectorinternac " + ;
	"left join TabNutPaciente on pacinternad.pin_codadmision = TabNutPaciente.TNP_codadmision " + ;
	"left join TabNutDetalle on TabNutDetalle.TND_idPaciente = TabNutPaciente.id " + ;
	"left join TabNutPrest on TabNutPrest.TNP_codPrest= TabNutDetalle.TND_codPrest " + ;
	"left join afiliacion on pacientes.PAC_codhci = afiliacion.registracio and " + ;
	"	pacinternad.pin_codentidad = afiliacion.AFI_codentidad " + ;
	"left join entidexclu on pacinternad.pin_codentidad = entidexclu.codent and entidexclu.tpopac = 'INT' " +;
	"where TNP_Fecha >= ?mfecha and TNP_CodServ = 0 and tnd_fecbaja = ?mfechanull and TNP_dieta <> 6 "+;
	" and not (NVL(TNP_codfact,'')='AE' ) " , "mwknutact1_")
If mret<1
	=Aerr(eros)
	Messagebox (eros(2))
Endif
Select pac_codadmision As pacnxb From mwknutact1_ Where  Inlist(tnd_codprest,19010222,19010223);
	INTO Cursor mwkpacnxb

Select PAC_habitacion, PAC_cama, PAC_nombrepaciente, PAC_descripdiagn, PAC_fechaadmision, PAC_horaadmision, pin_codentidad, PAC_edad, ;
	PAC_codadmision, PAC_fecnacimiento, PAC_codhci, ;
	sec_descripsec, fecpasiva,Id , TNP_codadmision , TNP_Fecha , TNP_CodServ , TNP_CodFact , ;
	TNP_Usuario , TNP_FecImp , TNP_Modi , TNP_codfactu, ;
	TNP_factura, TNP_dieta,TNP_Observaciones,   ;
	TND_idPaciente, TND_codPrest, TND_NroVale, TND_FHoraCarga, TND_observa,PAC_sectorinternac  ;
	from mwknutact1_ ;
	where  ((TNP_codserv = 0 And  TND_codPrest>0) Or TNP_codserv>0) And ;
	!Empty(Alltrim(Strtran(Strtran(TNP_Observaciones, 'Alimentacion Enteral', ""), '+', ""))) Into Cursor mwknutact1
*---------------------------------------------------------------------------------------------

mfechacarga = sp_busco_fecha_srv2('DT')
mfiltro = Iif(mprueba=1,' and 1=2 ','')

If mrepro = 1 And mfecha = Ttod(mfechacarga) And mprueba = 0
*---------------------------------------------------------------------------------------------
	mret = SQLExec(mcon1, "select TabNutPaciente.* " + ;
		"from pacinternad "+;
		"left join TabNutPaciente on pacinternad.pin_codadmision = TabNutPaciente.TNP_codadmision " + ;
		"where TNP_Fecha = ?mfecha and TNP_CodServ = ?mtiposer "+;
		"and TNP_fecimp is null "  , "mwkdietanul")

	If mret < 1
		=Aerr(eros)
		Messagebox (eros(2))
	Endif
*---------------------------------------------------------------------------------------------
	mret = SQLExec(mcon1, "delete from TabNutPaciente " + ;
		"where TNP_Fecha = ?mfecha and TNP_CodServ = ?mtiposer and TNP_codadmision " + ;
		"in (select pin_codadmision from pacinternad ) " + ;
		"and TNP_fecimp is null " )

	If mret<1
		=Aerr(eros)
		Messagebox (eros(2))
	Endif
*---------------------------------------------------------------------------------------------
	Select mwkdietanul
*	scan
*			Do sp_borra_dieta With Id
*	endscan
Else
*---------------------------------------------------------------------------------------------
	mret = SQLExec(mcon1, "select TNP_codadmision " + ;
		" from TabNutPaciente  " + ;
		" where TNP_Fecha = ?mfecha and TNP_CodServ=?mtiposer " +mfiltro, "mwkdietaExis")

	If mret<1
		=Aerr(eros)
		Messagebox (eros(2))
	Endif
*---------------------------------------------------------------------------------------------
Endif
*** Desayunos generados

*---------------------------------------------------------------------------------------------
mret = SQLExec(mcon1, "select PAC_habitacion, PAC_cama, PAC_nombrepaciente, " + ;
	"PAC_descripdiagn, PAC_fechaadmision, PAC_horaadmision, pin_codentidad, PAC_edad, " + ;
	"PAC_codadmision, PAC_fecnacimiento, PAC_codhci, TN_Ingrediente, TN_CodAgr, TN_Tipo, " + ;
	"sec_descripsec, entidexclu.fecpasiva, TabNutPaciente.*, " + ;
	"TND_idPaciente, TND_codPrest, TND_NroVale, TND_FHoraCarga, TND_observa,PAC_sectorinternac " + ;
	"from pacinternad " + ;
	"left join pacientes on pacinternad.pin_codadmision = pacientes.PAC_codadmision " + ;
	"left join habitacions on hab_codpaciente = pacientes.PAC_codadmision " + ;
	"left outer join sectores on sec_codsector = pacientes.PAC_sectorinternac " + ;
	"left join TabNutPaciente on pacinternad.pin_codadmision = TabNutPaciente.TNP_codadmision " + ;
	"left join TabNutDetalle on TND_idPaciente = TabNutPaciente.id " + ;
	"left join TabNutIngr on TabNutIngr.id = TND_codPrest " + ;
	"left join  afiliacion on " + ;
	"	pacientes.PAC_codhci = afiliacion.registracio and " + ;
	"	pacinternad.pin_codentidad = afiliacion.AFI_codentidad " + ;
	"left join  entidexclu on pacinternad.pin_codentidad = entidexclu.codent and entidexclu.tpopac = 'INT' " + ;
	"where TNP_Fecha = ?mfecha and TNP_CodServ = ?mtiposer " + ;
	"and tnd_fecbaja = ?mfechanull"+ mfiltro , "mwkdietdes")

If mret<1
	=Aerr(eros)
	Messagebox (eros(2))
Endif
*---------------------------------------------------------------------------------------------
If mwkusuario.idusuario="CARMENA"
*	Set Step On
Endif
Select Distinct TNP_codadmision ;
	from mwkdietdes ;
	where  ((TNP_codserv = 0 And  TND_codPrest>0) Or TNP_codserv>0) ;
	into Cursor mwkctrldesmer

Select Distinct TNP_codadmision ;
	from mwknutact1 ;
	into Cursor mwkctrldietas

*** Nutricion anterior
*---------------------------------------------------------------------------------------------
mret = SQLExec(mcon1, "select *  from TabNutPaciente " + ;
	" where TNP_Fecha = ?mdiaant and  TNP_CodServ = ?mtipoant" , "mwknutant1")

If mret<1
	=Aerr(eros)
	Messagebox (eros(2))
Endif
*---------------------------------------------------------------------------------------------

If (mrepro = 1 Or Reccount("mwkctrldesmer") < Reccount("mwkctrldietas")) And mfecha = Ttod(mfechacarga )

	If Used('mwkauxi')
		Use In mwkauxi
	Endif

	Select PAC_habitacion + '-' + PAC_cama As habitac, PAC_nombrepaciente,  ;
		proper(PAC_descripdiagn) As PAC_descripdiagn, ;
		dtoc(PAC_fechaadmision) + " " + Ttoc(PAC_horaadmision,2) As PAC_fechaadmision, ;
		pin_codentidad, PAC_codadmision, ;
		prg_edad(PAC_fecnacimiento,mfecha,"AM")  As anios, ;
		TNP_Fecha, TNP_CodServ, TNP_CodFact, TNP_codfactu, TNP_factura, TNP_Observaciones, ;
		TNP_Usuario, TND_observa, TND_idPaciente, TND_codPrest, TND_NroVale, TND_FHoraCarga, pre_descriprest, ;
		sec_descripsec, mwknutact1.fecpasiva, TNP_Observaciones As indicacion, ;
		space(250) As Observaciones,PAC_sectorinternac ;
		from mwknutact1 ;
		left Join mwkpres On TND_codPrest = pre_codprest ;
		where pac_codadmision  Not In (Select IH_admision From mwkayunos) ;
		order By habitac, PAC_codadmision, TNP_CodServ, TND_NroVale ;
		into Cursor mwknutcdact1

	Wait Windows ("Generando Dieta... Aguarde") Nowait

	Select * ;
		from mwknutcdact1 ;
		group By habitac, PAC_codadmision, TNP_CodServ ;
		into Cursor mwkauxi

	Select * ;
		from mwknutcdact1 ;
		group By PAC_codadmision, TND_codPrest ;
		into Cursor mwkauxiprest

** ahora vemos compatibilidades

	mfecpas = Ctod("01/01/1900")
** indispensables

*---------------------------------------------------------------------------------------------


	mret = SQLExec(mcon1, "select TND_codPrest, TNP_codadmision, TND_idPaciente, TabNutIngr.*, PAC_edad,PAC_sectorinternac  " + ;
		"from pacinternad " + ;
		"left join pacientes on pacinternad.pin_codadmision = pacientes.PAC_codadmision " + ;
		"left join TabNutPaciente on pacinternad.pin_codadmision = TabNutPaciente.TNP_codadmision " + ;
		"left join TabNutDetalle on TabNutDetalle.TND_idPaciente = TabNutPaciente.id " + ;
		"left join TabNutComp on (TabNutComp.TNC_codPrest= TND_codPrest and TabNutComp.TNC_tipo=1 ) " + ;
		"left join TabNutIngr on TabNutComp.TNC_idIngr = TabNutIngr.id " + ;
		"where TNP_Fecha >= ?mfecha and TNP_CodServ=0  and tnd_fecbaja = ?mfechanull and " +;
		"TN_tipo <= 2 and TNC_fecpasiva = ?mfecpas " + ;
		"and TNP_codadmision not in (select TNP_codadmision " + ;
		"from TabNutPaciente " + ;
		" where TNP_Fecha = ?mfecha and TNP_CodServ = ?mtiposer &mfiltro )" +  ;
		"group by TNP_codadmision, TabNutIngr.id, TN_codagr ", "mwknutdesa1")

	If mret<1
		=Aerr(eros)
		Messagebox (eros(3))
	Endif

*---------------------------------------------------------------------------------------------
*!*
*!*	ESTA CONSULTA SE MODIFICO POR EL CAMBIO DE VERSION DE CACHE 2009

	mret = SQLExec(mcon1, "select TND_codPrest, TNP_codadmision, TND_idPaciente, " + ;
		"elid as Id, TN_Ingrediente, TN_CodAgr, TN_Tipo , PAC_edad ,PAC_sectorinternac,TNP_Observaciones  " + ;
		"from pacinternad " + ;
		"left join pacientes on pacinternad.pin_codadmision = pacientes.PAC_codadmision " + ;
		"left join TabNutPaciente on pacinternad.pin_codadmision = TabNutPaciente.TNP_codadmision " + ;
		"left join TabNutDetalle on TabNutDetalle.TND_idPaciente = TabNutPaciente.id " + ;
		"inner join (Select TabNutDietaPrest.*, TabNutIngr.*, TabNutIngr.Id as elid from TabNutDietaPrest " + ;
		"inner join TabNutIngr on TabNutDietaPrest.TNDP_idIngr  = TabNutIngr.id and TN_tipo <= 2 " + ;
		"where TNDP_fecpasiva = ?mfechanull and TNDP_tipo = 1 and TNDP_CodServ = 3  ) on TNDP_codPrest = TND_codPrest " + ;
		"where TNP_Fecha >= ?mfecha and TNP_CodServ = 0 and not (NVL(TNP_codfact,'')='AE')  and tnd_fecbaja = ?mfechanull and pac_edad <= TNDP_edad " + ;
		"and TNP_codadmision not in (select TNP_codadmision from TabNutPaciente " + ;
		"where TNP_Fecha = ?mfecha and TNP_CodServ = 3) " + ;
		"group by TNP_codadmision, elid, TN_codagr ", "mwknutdesa11_")

	If mret<1
		=Aerr(eros)
		Messagebox (eros(3))
	Endif
	Select TND_codPrest, TNP_codadmision, TND_idPaciente, Id, TN_Ingrediente, TN_CodAgr, TN_Tipo , ;
		PAC_edad ,PAC_sectorinternac From mwknutdesa11_ ;
		where !Empty(Alltrim(Strtran(Strtran(TNP_Observaciones, 'Alimentacion Enteral', ""), '+', "")));
		and TNP_codadmision  Not In (Select IH_admision From mwkayunos) ;
		into Cursor mwknutdesa11

*!*		mret = sqlexec(mcon1, "select TND_codPrest, TNP_codadmision, TND_idPaciente, TabNutIngr.*, PAC_edad " + ;
*!*			"from TabNutDietaPrest, pacinternad " + ;
*!*			"left join pacientes on pacinternad.pin_codadmision = pacientes.PAC_codadmision " + ;
*!*			"left join TabNutPaciente on pacinternad.pin_codadmision = TabNutPaciente.TNP_codadmision " + ;
*!*			"left join TabNutDetalle on TabNutDetalle.TND_idPaciente = TabNutPaciente.id " + ;
*!*			"left join TabNutIngr on TabNutDietaPrest.TNDP_idIngr  = TabNutIngr.id " + ;
*!*			"where TNP_Fecha >= ?mfecha and TNP_CodServ = 0 and TN_tipo <= 2 and TNDP_CodServ = ?mtiposer " + ;
*!*			"and TNDP_codPrest = TND_codPrest and TNDP_tipo = 1 " + ;
*!*			"and tnd_fecbaja = ?mfechanull and pac_edad <= TNDP_edad and TNP_codadmision not in (select TNP_codadmision from TabNutPaciente " + ;
*!*			" where TNP_Fecha = ?mfecha and TNP_CodServ = ?mtiposer )" + ;
*!*			"group by TNP_codadmision, TabNutIngr.id, TN_codagr ", "mwknutdesa11a")

*!*		If mret<1
*!*			=Aerr(eros)
*!*			Messagebox (eros(3))
*!*		Endif

*---------------------------------------------------------------------------------------------
** Prohibidos

	mret = SQLExec(mcon1, "select * " + ;
		"from TabNutComp " + ;
		"left join TabNutIngr on TabNutComp.TNC_idIngr = TabNutIngr.id " + ;
		"where TNC_tipo=2 and TN_tipo <= 2 and TNC_fecpasiva = ?mfecpas "   + ;
		" ", "mwknutdesa2")

	If mret<1
		=Aerr(eros)
		Messagebox (eros(3))
	Endif
*---------------------------------------------------------------------------------------------

	Select PAC_codadmision, TNC_idIngr ;
		from mwkauxiprest ;
		left Join mwknutdesa2 On TND_codPrest = TNC_codPrest ;
		group By PAC_codadmision, TNC_idIngr ;
		having TNC_idIngr > 0 ;
		into Cursor mwkingproh

** no compatibles
	mfecpas = Ctod("01/01/1900")
*---------------------------------------------------------------------------------------------

	mret = SQLExec(mcon1, "select  TND_codPrest, TNP_codadmision, TND_idPaciente, TabNutIngr.*, PAC_edad ,PAC_sectorinternac ,TNP_Observaciones " + ;
		"from TabNutIngr, pacinternad " + ;
		"left join pacientes on pacinternad.pin_codadmision = pacientes.PAC_codadmision " + ;
		"left join TabNutPaciente on pacinternad.pin_codadmision = TabNutPaciente.TNP_codadmision " + ;
		"left join TabNutDetalle on TabNutDetalle.TND_idPaciente = TabNutPaciente.id " + ;
		"left join TabNutPrest on TabNutPrest.TNP_codPrest= TabNutDetalle.TND_codPrest " + ;
		"where TNP_Fecha >= ?mfecha and TNP_CodServ=0 and not (NVL(TNP_codfact,'')='AE' )  and TN_tipo <= 2 and tnd_fecbaja = ?mfechanull " + ;
		" and TNP_dieta <> 6 and TNP_codadmision not in (select TNP_codadmision from TabNutPaciente " + ;
		" where TNP_Fecha = ?mfecha and TNP_CodServ=?mtiposer &mfiltro) " +  ;
		"order by TNP_codadmision, TND_codPrest ", "mwknutdesa01_")

	If mret<1
		=Aerr(eros)
		Messagebox (eros(3))
	Endif
	Select TND_codPrest, TNP_codadmision, TND_idPaciente, Id , TN_Ingrediente , TN_CodAgr , TN_Tipo ;
		, PAC_edad ,PAC_sectorinternac From mwknutdesa01_  ;
		where !Empty(Alltrim(Strtran(Strtran(TNP_Observaciones, 'Alimentacion Enteral', ""), '+', ""))) ;
		and TNP_codadmision  Not In (Select IH_admision From mwkayunos) ;
		into Cursor mwknutdesa01

*---------------------------------------------------------------------------------------------

	mret = SQLExec(mcon1, "select TabNutComp.* " + ;
		" from TabNutIngr " + ;
		" left join TabNutComp on (TabNutComp.TNC_idIngr = TabNutIngr.id and TabNutComp.TNC_tipo = 0 ) "+;
		" where TN_tipo <= 2 and TNC_fecpasiva = ?mfecpas " , "mwknutdesa02")

	If mret<1
		=Aerr(eros)
		Messagebox (eros(3))
	Endif
*---------------------------------------------------------------------------------------------
	Select PAC_codadmision, TNC_idIngr ;
		from mwkauxiprest ;
		left Join mwknutdesa02 On TND_codPrest = TNC_codPrest ;
		group By PAC_codadmision, TNC_idIngr Having TNC_idIngr > 0 ;
		into Cursor mwkingNoComp

	mret = SQLExec(mcon1, "select TabNutDietaPrest.* " + ;
		" from TabNutDietaPrest " + ;
		" left join TabNutIngr on TabNutDietaPrest.TNDP_idIngr = TabNutIngr.id "+;
		" where TNDP_fecpasiva = ?mfecpas and TNDP_tipo = 2 and TNDP_CodServ = ?mtiposer " , "mwknutDPnova")

	If mret<1
		=Aerr(eros)
		Messagebox (eros(3))
	Endif
*---------------------------------------------------------------------------------------------
*   Medialunas para los pisos VIP 11 y 13
*---------------------------------------------------------------------------------------------

	mret = SQLExec(mcon1, "select TabNutDietaPrest.* " + ;
		" from TabNutDietaPrest " + ;
		" left join TabNutIngr on TabNutDietaPrest.TNDP_idIngr = TabNutIngr.id "+;
		" where TNDP_fecpasiva = ?mfecpas and TNDP_tipo = 3 and TNDP_CodServ = ?mtiposer ","mwknutDPvip")

	If mret<1
		=Aerr(eros)
		Messagebox (eros(3))
	Endif
	Select *,Iif(tndp_edad<110,"CO","T")+Alltrim(Transf(tndp_edad-100)) As piso From mwknutDPvip Into Cursor mwknutDvip
*---------------------------------------------------------------------------------------------
	If myip = '172.16.17'
*SET STEP ON
	Endif
	Select * ;
		from mwknutdesa01 ;
		where Alltrim(TNP_codadmision )+Transf(Id,"999999");
		not In (Select Alltrim(PAC_codadmision )+Transf(TNC_idIngr,"999999") From mwkingNoComp) ;
		into Cursor mwknutdesa01a

	Select * ;
		from mwknutdesa01a ;
		union ;
		select * ;
		from mwknutdesa11 ;
		union ;
		select * ;
		from mwknutdesa1 ;
		where !Isnul(Id);
		into Cursor mwknutdesau

	Select * ;
		from mwknutdesau ;
		where Alltrim(TNP_codadmision ) + Transf(Id,"999999");
		not In (Select Alltrim(PAC_codadmision ) + Transf(TNC_idIngr,"999999") From mwkingproh ) ;
		into Cursor mwknutdesa01b

	Select * ;
		from mwknutdesa01b ;
		left Join mwknutDPnova On (TND_codPrest = TNDP_codPrest  ;
		and TNDP_idIngr = mwknutdesa01b.Id ) ;
		into Cursor mwknutsdpedad


	Select * ;
		from mwknutdesa01b ;
		inner Join mwknutDvip On (TND_codPrest = TNDP_codPrest  ;
		and piso = mwknutdesa01b.PAC_sectorinternac) ;
		group By tnp_codadmision,TNDP_idingr Into Cursor mwknutpacvip

	Select * ;
		from mwknutsdpedad ;
		where Isnull(TNDP_edad) Or (TNDP_edad < PAC_edad And TNDP_CodServ = mtiposer) ;
		into Cursor mwknutdesa01c

	If Used("mwkfiltro")
		Use In mwkfiltro
	Endif
	If Used("mwkfiltro2")
		Use In mwkfiltro2
	Endif
	If Used("mwkprohib")
		Use In mwkprohib
	Endif
	If Used("mwksesaca")
		Use In mwksesaca
	Endif

	Use In Select('mwkdesayunos')

	Select mwknutdesa01c.*, mwktotgr.* ;
		from mwknutdesa01c ;
		left Join mwktotgr On TN_CodAgr=TNA_CodAgr ;
		where TNP_codadmision  Not In (Select IH_admision From mwkayunos) ;
		AND TNP_codadmision  Not In (Select pacnxb From mwkpacnxb);
		order By mwknutdesa01c.TNP_codadmision, TN_CodAgr, tn_ingrediente ;
		group By mwknutdesa01c.TNP_codadmision, TN_CodAgr, tn_ingrediente ;
		into Cursor mwkdesayunos Readwrite
	Select mwkcambioingr
	Scan
		miingno = mwkcambioingr.estado
		mnuevoing = mwkcambioingr.subestado
		Select mwkTNIngr
		Locate For Id = mwkcambioingr.subestado
		mides = TN_Ingrediente
		miagr = TN_CodAgr
		mitipo = tn_tipo
		Select mwkTNagr
		Locate For TNA_CodAgr = miagr
		magrup = TNA_Descripcion
		Update mwkdesayunos  Set id_a = mnuevoing ,tn_ingrediente = mides,tna_codagr=miagr,TNA_Descripcion=	magrup ;
			,tn_codagr = miagr ,tn_tipo = mitipo,cantxgr = 1;
			WHERE id_a = miingno And Inlist(pac_sectorinternac,&lareacerrada)
	Endscan
	If Used('auxidesa')
		Use In auxidesa
	Endif
	If Used("mwkTNIngr")
		Use In mwkTNIngr
	Endif


&&&  Genero los registros
	Select  *, id_a As Id From mwkdesayunos Into Cursor mwkdesa
	mcodadm =''

	If !Used("mwkusuario")
		Create Cursor mwkusuario (idusuario c(20),codigovax N(7),Password c(10),Id N(2),nivel N(2),sector c(30),nomape c(30))
		Insert Into mwkusuario Values ("CFUNES",54035,'',146,1,'SISTEMAS',"Carmencita")
	Endif

	If Used('mwkdesayuno')
		Use In mwkdesayuno
	Endif
	Use Dbf('mwkdesa') In 0 Again Alias mwkdesayuno
	micodadm		= mwkdesa.TNP_codadmision
	mipresta		= mwkdesa.Id
	Select mwkdesayuno
	mitope = Reccount()
	Select mwkdesa
	Go Top

	Do While !Eof('mwkdesa') And Recno('mwkdesa') <=mitope
		mtipo = mtiposer
		mingr = mwkdesa.Id
		msec = Iif(	mcodadm	= mwkdesa.TNP_codadmision,msec+1,1)
		mcodadm		= mwkdesa.TNP_codadmision
		mpresta		= mwkdesa.Id
		mvale 		= msec
		mobserva	= ""
		musu_carga 	= mwkusuario.codigovax
		mmedico		= 0
		mcodvax	= mwkusuario.codigovax
		lsigue = .T.
*	If mrepro = 0
		Select PAC_codadmision From mwkdietdes Where ((TNP_codserv = 0 And  TND_codPrest>0) Or TNP_codserv>0) ;
			and PAC_codadmision = mcodadm Into Cursor mwkexis
		lsigue = (Reccount('mwkexis')=0)
		Select  mwkdesa
*	Endif
		If lsigue
			If mprueba = 0
				Do sp_actualizo_tab_nut_pac With 1, mcodadm, mtiposer, '','','',mfecha
			Endif
			mret =SQLExec(mcon1, "select id from TabNutPaciente "+;
				"where TNP_codadmision = ?mcodadm and TNP_Fecha = ?mfecha "+;
				" and TNP_CodServ = ?mtiposer","mwkexistepac")
			midpac= mwkexistepac.Id
			Do While !Eof('mwkdesa') And  mcodadm = mwkdesa.TNP_codadmision And Recno('mwkdesa') <=mitope

				mtipo = mtiposer
				mingr = mwkdesa.Id
				msec = Iif(	mcodadm	= mwkdesa.TNP_codadmision,msec+1,1)
				mcodadm		= mwkdesa.TNP_codadmision
				mpresta		= mwkdesa.Id
				mvale 		= msec
				mobserva	= ""
				musu_carga 	= mwkusuario.codigovax
				mmedico		= 0
				mcodvax	= mwkusuario.codigovax

				If mprueba = 0
					Do sp_actualizo_tab_nut_det With 1, midpac, mingr, mvale,mfechacarga,mobserva
				Endif
				Skip 1 In mwkdesa
			Enddo

			Select * From mwknutpacvip Where tnp_codadmision = mcodadm ;
				and Alltrim(TNP_codadmision ) + Transf(TNDP_idingr,"999999");
				not In (Select Alltrim(PAC_codadmision ) + Transf(TNC_idIngr,"999999") From mwkingproh ) ;
				into Cursor mkedesvip

			Do While !Eof('mkedesvip')
				Select * From mwkdesayuno Where TNP_codadmision=micodadm And Id = mipresta Into Cursor mwkpacvip1
				Use In Selec("miregistro")
				Use Dbf('mwkpacvip1') Alias miregistro In 0 Again
				mingr = mkedesvip.TNDP_idingr
				If mprueba = 0
					Do sp_actualizo_tab_nut_det With 1, midpac, mingr, mvale,mfechacarga,mobserva
				Endif
				Select mwkdesayuno
				Update miregistro Set TNP_Observaciones = mwkdesayuno.mingr,TN_INGREDIENTE="MEDIALUNAS",TNA_DESCRIPCION= "SIN AGRUPAMIENTO "
				Select mwkdesayuno
				Append From Dbf('miregistro')
				Select mkedesvip
				Skip 1 In mkedesvip
			Enddo
			Select mwkdesa
		Else
			Do While !Eof('mwkdesa') And  mcodadm = mwkdesa.TNP_codadmision And Recno('mwkdesa') <=mitope
				Skip 1 In mwkdesa
			Enddo
		Endif

		micodadm		= mwkdesa.TNP_codadmision
		mipresta		= mwkdesa.Id
		Select mwkdesa

	Enddo

	Create Cursor auxidesa (codadm c(8), desayuno c(250),indimed c(250))


	If Used("mwkdietanul")
		Use In mwkdietanul
	Endif
	If Used("mwkdietdes")
		Use In mwkdietdes
	Endif

	If Used("mwkdesayunos")
		Use In mwkdesayunos
	Endif

	Select * From mwkdesayuno Order By tnp_codadmision,tna_codagr,Id Into Cursor mwkdesayunos
	Select  mwkdesayunos
	Go Top

	Do While !Eof()
		mcod = TNP_codadmision
		magr = TN_CodAgr
		midpac = TND_idPaciente
		mdes = ''
		mingr = Nvl(Alltrim(Lower(tn_ingrediente)),'')
		mdesgr = Nvl(Alltrim(Lower(TNA_Descripcion)),'')
		mdes = mdesgr
		lena = 0
		canxg = 1
		mcanxg = cantxgr
		Skip
		If mcod = TNP_codadmision
			mdes = ''
		Endif
		Do While !Eof() And mcod = TNP_codadmision

			Do While !Eof() And mcod = TNP_codadmision And magr = TN_CodAgr
				If magr > 0
					mingr = mingr + Iif(Len(mingr)>0,' o ','') + Nvl(Alltrim(Lower(tn_ingrediente)),'')
					canxg = canxg + 1
				Else
					If canxg >= mcanxg And canxg > 1
						mingr = Iif(lena=0,'',Left(mingr,lena)+', ')+ mdesgr
					Endif
					lena = Len(mingr)
					mingr = mingr +  Nvl(Alltrim(Lower(tn_ingrediente)),'')
					canxg = 1
					mcanxg = cantxgr
				Endif
				Skip
			Enddo
			mdes = Iif(Len(mdes)=0,'',mdes+', ')+ Iif(canxg >= mcanxg,mdesgr,mingr)
			mingr = ''
			canxg = 1
			mdesgr = Nvl(Alltrim(Lower(TNA_Descripcion)),'')
			magr = TN_CodAgr
		Enddo
*!*			mdes = iif(len(mdes)=0,'',mdes+', ')+ iif(canxg = mcanxg,mdesgr,mingr)
*!*			if canxg = mcanxg and canxg > 1
*!*				mingr = iif(lena=0,'',left(mingr,lena)+', ')+ mdesgr
*!*			endif
		Insert Into auxidesa (codadm, desayuno,indimed ) Values (mcod,mdes,mindimed)
		lsigue = .T.
		If mrepro=0
			Select * From mwkdietaExis Where TNP_codadmision = mcod  Into Cursor mwksigue
			lsigue = (Reccount('mwksigue')=0)
		Endif
		If lsigue
			If mprueba = 0
				Do sp_actualizo_tab_nut_pac With 1, mcod, mtiposer, mdes, '', '', mfecha
			Endif
		Endif
		Select  mwkdesayunos
	Enddo
	If mtiposer = 3 And mprueba = 0
		Do sp_cargo_colaciones With mfecha
	Endif
Endif

If Inlist(mtiposer, 3,4 )
	mret = SQLExec(mcon1, "select TabNutPaciente.id as idp,tnp_observaciones,TND_codPrest, TNP_codadmision, TND_idPaciente, TabNutIngr.*, " + ;
		" TNP_codadmision"+;
		" from pacinternad " + ;
		" left join pacientes on pacinternad.pin_codadmision = pacientes.PAC_codadmision " + ;
		" left join TabNutPaciente on pacinternad.pin_codadmision = TabNutPaciente.TNP_codadmision " + ;
		" left join TabNutDetalle on TabNutDetalle.TND_idPaciente = TabNutPaciente.id " + ;
		" left join TabNutIngr on TND_codPrest = TabNutIngr.id " + ;
		" where TNP_Fecha = ?mfecha and TNP_CodServ =?mtiposer  and tnd_fecbaja = ?mfechanull " +;
		" and tnp_observaciones='' ", "mwknutdesctrl")
	If Reccount("mwknutdesctrl")>0
		Select mwknutdesctrl.*, mwktotgr.* ;
			from mwknutdesctrl;
			left Join mwktotgr On TN_CodAgr=TNA_CodAgr ;
			order By mwknutdesctrl.TNP_codadmision, TN_CodAgr, tn_ingrediente ;
			group By mwknutdesctrl.TNP_codadmision, TN_CodAgr, tn_ingrediente ;
			into Cursor mwkdesayunosmal
		Select mwkdesayunosmal
		Do While !Eof()
			Select mwkdesayunosmal
			mcod = TNP_codadmision
			midp =  idp
			magr = TN_CodAgr
			midpac = TND_idPaciente
			mdes = ''
			mingr = Nvl(Alltrim(Lower(tn_ingrediente)),'')
			mdesgr = Nvl(Alltrim(Lower(TNA_Descripcion)),'')
			lena = 0
			canxg = 1
			mcanxg = cantxgr
			Skip
			Do While !Eof() And mcod = TNP_codadmision
				Do While !Eof() And mcod = TNP_codadmision And magr = TN_CodAgr
					If magr > 0
						mingr = mingr + Iif(Len(mingr)>0,' o ','') + Nvl(Alltrim(Lower(tn_ingrediente)),'')
						canxg = canxg + 1
					Else
						If canxg >= mcanxg And canxg > 1
							mingr = Iif(lena=0,'',Left(mingr,lena)+', ')+ mdesgr
						Endif
						lena = Len(mingr)
						mingr = mingr +  Nvl(Alltrim(Lower(tn_ingrediente)),'')
						canxg = 1
						mcanxg = cantxgr
					Endif
					Skip
				Enddo
				mdes = Iif(Len(mdes)=0,'',mdes+', ')+ Iif(canxg >= mcanxg,mdesgr,mingr)
				mingr = ''
				canxg = 1
				mdesgr = Nvl(Alltrim(Lower(TNA_Descripcion)),'')
				magr = TN_CodAgr
			Enddo
			mret = SQLExec(mcon1, "update TabNutPaciente set tnp_observaciones = ?mdes where id = ?midp")
		Enddo
	Endif
	Use In Select("mwkdesayunosmal")
	Use In Select("mwknutdesctrl")
Endif

If Inlist(mtiposer, 3,4 )  &&& controlo areas cerradas
	mret = SQLExec(mcon1, "select TabNutPaciente.id as idp,tnp_observaciones,  TNP_codadmision "+;
		" from pacinternad " + ;
		" left join pacientes on pacinternad.pin_codadmision = pacientes.PAC_codadmision " + ;
		" left join TabNutPaciente on pacinternad.pin_codadmision = TabNutPaciente.TNP_codadmision " + ;
		" where TNP_Fecha = ?mfecha and TNP_CodServ =?mtiposer   " +;
		"  ", "mwknutdesctrl")
	Select IH_admision From mwkIntNutUCI Where  IN_codprest =19010215 Into Cursor mwkpacdbt

	Select IH_admision From mwkIntNutUCI Where Inlist(IN_codprest,19010234,19010235,19010236) And;
		IH_admision  Not In (Select IH_admision From mwkpacdbt)   Into Cursor mwkpostre

	Select IH_admision From mwkIntNutUCI Where Inlist(IN_codprest,19010245) And;
		IH_admision  Not In (Select IH_admision From mwkpacdbt)   Into Cursor mwkpostreno

	Select IH_admision From mwkIntNutUCI Where Inlist(IN_codprest,19010234,19010235,19010236)  And;
		IH_admision  In (Select IH_admision From mwkpacdbt) Into Cursor mwkpostredbt
*	Set Step On
	If Reccount("mwkpostre")>0
		Select mwknutdesctrl.* ;
			from mwknutdesctrl;
			WHERE TNP_codadmision In (Select IH_admision From mwkpostre) And (At('vainillas',tnp_observaciones )>0 ;
			OR At('galletitas',tnp_observaciones )>0);
			Order By mwknutdesctrl.TNP_codadmision ;
			into Cursor mwkdesayunosmal
		Select mwkdesayunosmal
		Scan
			Select mwkdesayunosmal
			mcod = TNP_codadmision
			midp =  idp
			midpac = idp
			mdes = Strtran(tnp_observaciones,'vainillas','postre frio' )
			mdes = Strtran(mdes,'galletitas sin sal','postre frio' )
			mdes = Strtran(mdes,'galletitas','postre frio' )
			mret = SQLExec(mcon1, "update TabNutPaciente set tnp_observaciones = ?mdes where id = ?midp")
		Endscan
	Endif
	If Reccount("mwkpostredbt")>0
		Select mwknutdesctrl.* ;
			from mwknutdesctrl;
			WHERE TNP_codadmision In (Select IH_admision From mwkpostredbt) And (At('vainillas',tnp_observaciones )>0 ;
			OR At('galletitas',tnp_observaciones )>0);
			Order By mwknutdesctrl.TNP_codadmision ;
			into Cursor mwkdesayunosmal
		Select mwkdesayunosmal
		Scan
			Select mwkdesayunosmal
			mcod = TNP_codadmision
			midp =  idp
			midpac = idp
			mdes = Strtran(tnp_observaciones,'vainillas','postre frio diet' )
			mdes = Strtran(mdes,'galletitas sin sal','postre frio diet' )
			mdes = Strtran(mdes,'galletitas','postre frio diet' )
			mret = SQLExec(mcon1, "update TabNutPaciente set tnp_observaciones = ?mdes where id = ?midp")
		Endscan
	Endif
	If Reccount("mwkpostreno")>0
		Select mwknutdesctrl.* ;
			from mwknutdesctrl;
			WHERE TNP_codadmision In (Select IH_admision From mwkpostreno) And At('postre',tnp_observaciones )>0 ;
			into Cursor mwkdesayunosmal
		Select mwkdesayunosmal
		Scan
			Select mwkdesayunosmal
			mcod = TNP_codadmision
			midp =  idp
			midpac = idp
			mdes = Strtran(tnp_observaciones,'postre frio','vainillas' )
			mret = SQLExec(mcon1, "update TabNutPaciente set tnp_observaciones = ?mdes where id = ?midp")
		Endscan
	Endif

	If Reccount("mwkIntNutdbt45")>0
		Select mwknutdesctrl.* ;
			from mwknutdesctrl;
			WHERE TNP_codadmision In (Select IH_admision From mwkIntNutdbt45) And At('postre',tnp_observaciones )=0 ;
			into Cursor mwkdesayunosmal
		Select mwkdesayunosmal
		Scan
			Select mwkdesayunosmal
			mcod = TNP_codadmision
			midp =  idp
			midpac = idp
			mdes =  Alltrim(tnp_observaciones)+',postre frio diet'
			mret = SQLExec(mcon1, "update TabNutPaciente set tnp_observaciones = ?mdes where id = ?midp")
		Endscan
	Endif
	If Reccount("mwkIntNutnodbt45")>0
		Select mwknutdesctrl.* ;
			from mwknutdesctrl;
			WHERE TNP_codadmision In (Select IH_admision From mwkIntNutnodbt45) And At('postre',tnp_observaciones )=0 ;
			into Cursor mwkdesayunosmal
		Select mwkdesayunosmal
		Scan
			Select mwkdesayunosmal
			mcod = TNP_codadmision
			midp =  idp
			midpac = idp
			mdes = Strtran(tnp_observaciones,'vainillas','postre frio' )
			mdes = Strtran(mdes,'galletitas sin sal','postre frio' )
			mdes = Strtran(mdes,'galletitas','postre frio' )
			mret = SQLExec(mcon1, "update TabNutPaciente set tnp_observaciones = ?mdes where id = ?midp")
		Endscan
	Endif
	Use In Select("mwkdesayunosmal")
	Use In Select("mwknutdesctrl")
Endif
If Used("mwkdesayuno")
	Use In mwkdesayuno
Endif

If Used("mwkdesayunos")
	Use In mwkdesayunos
Endif
If Used("mwknutdesa1")
	Use In mwknutdesa1
Endif
If Used("mwknutdesa11")
	Use In mwknutdesa11
Endif
If Used("mwknutdesa2")
	Use In mwknutdesa2
Endif
If Used("mwknutdesa01")
	Use In mwknutdesa01
Endif
If Used("mwknutdesa02")
	Use In mwknutdesa02
Endif
If Used("mwknutDPnova")
	Use In mwknutDPnova
Endif
If Used("mwktotgr")
	Use In mwktotgr
Endif
If Used("mwkdietanul")
	Use In mwkdietanul
Endif
If Used("mwkdietdes")
	Use In mwkdietdes
Endif
If Used("mwkpres")
	Use In mwkpres
Endif
If Used("mwktotgr")
	Use In mwktotgr
Endif

Do sp_busco_dieta With mfecha, mtiposer, , 1
Select IH_admision,"AYUNO desde:"+Ttoc(INA_fechaHoraIni) As ayuno From mwkIntNutsusp Where INA_fechaHoraIni <= mfechabajaay Into Cursor mwkayunos

Select mwkdieta.*,mwkdieta.TNP_Observaciones As desayunop,ayuno,'' As mobsam ;
	from mwkdieta ;
	left Join mwkayunos On pac_codadmision = IH_admision ;
	order By habitac, PAC_codadmision ;
	group By mwkdieta.pac_codadmision ;
	into Cursor mwkdesaprev
Select *, Padr(Iif(!Isnull(ayuno),ayuno,desayunop),250) As desayuno ;
	from mwkdesaprev ;
	into Cursor mwkdesa
lok = .F.
If  Inlist(Dow(mfecha),7, 1)
	lok = .T.
Else
	mdia = Day(mfecha)
	mmes = Month(mfecha)
	mret=SQLExec(mcon1,"SELECT dia FROM feriaturnosA WHERE dia =?mfecha",'MWKFeriados')
	lok = (Reccount('MWKFeriados')>0)
	If (mdia = 24 Or mdia = 31) And mmes = 12
		lok = .T.
	Endif
Endif
If lok
	Do sp_busco_dieta With mfecha, 0, , 1
*** buscar cursor		select * from mwkdieta into cursor mwkpndieta1
	Do sp_actualizo_cf_cat With mfecha
Endif
