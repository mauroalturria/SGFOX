*
* Cuidados Domiciliarios
*
Lparameters mfecar, mregis, mestado, mlidcd, mlfecha, mfecar2

If Vartype(mlidcd) <> 'N'

	If Vartype(mfecar) <> 'D'
		mfecar = sp_busco_fecha_serv('DD')
	Endif

	If Vartype(mfecar2) <> 'D'
		mfecar2 = sp_busco_fecha_serv('DD')
	Endif

	If Vartype(mregis) <> 'N'
		mregis = 0
	Endif

	If Vartype(mestado) <> 'N'
		mestado = 1
	Endif

	mwhere = ""

	If mlfecha = 1
		mwhere = mwhere + " TCS_fecarga >= ?mfecar and TCS_fecarga <= ?mfecar2 "
	Endif

	If mregis > 0
		If !Empty(mwhere)
			mwhere = mwhere + " and "
		Endif
		mwhere = mwhere + " TCS_nroregistrac = ?mregis "
	Endif

	If  mestado <> 8
		If !Empty(mwhere)
			mwhere = mwhere + " and "
		Endif
		mwhere = mwhere + " TCS_estado = ?mestado "
	Endif

	Use In Select("mwkcuidom")
	mret = SQLExec(mcon1,"select TCS_fecarga, TCS_nroafi, TCS_nroregistrac->REG_nombrepac, TCS_direccion,"+;
		" TCS_localidad, TCS_telpar, TCS_medsolic, TabCuiDomSoli.id as lid, TCS_estado, TCS_nroregistrac,"+;
		" TCS_patologia, TCS_resumenhc,  TCS_telefono, TCS_fecest, TCS_entidad,"+;
		" Entidades.ENT_descrient as lentidad,TCS_fecnac,TCS_diagnos,TabCiap2E.Descripcion as ldiagnos,"+;
		" TCS_telcel,preregistra.nombre as lnombre, TCS_presumen"+;
		" from TabCuiDomSoli"+;
		" left join Entidades on Entidades.ENT_codent = TabCuiDomSoli.TCS_entidad "+;
		" left join TabCiap2E on TabCiap2E.id = TabCuiDomSoli.TCS_diagnos"+;
		" left join preregistra on preregistra.id =  TabCuiDomSoli.TCS_nroregistrac "+;
		Iif(!Empty(mwhere), " where "+mwhere, ""),"mwkcuidom")

*select * from preregistra order by id desc


	If mret < 0
		MTABLA = "CUIDADOS DOMICILIARIOS"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif


*!* Internaciones
*!* 2013-07-01 se agrego group by
*!* Nuesvo estado /: Anulado

	Use In Select("mwkcuidint")
	mret = SQLExec(mcon1,"Select Pacientes.PAC_codadmision, Pacientes.PAC_nombrepaciente,"+;
		" Pacientes.PAC_habitacion, Pacientes.PAC_cama, PAC_descripdiagn,"+;
		" PAC_fechaadmision,PAC_codhci,Sectores.SEC_descripsec"+;
		" From Pacinternad"+;
		" Join Pacientes On Pacientes.PAC_codadmision = Pacinternad.PIN_codadmision"+;
		" Join TabCuiDomSoli On TCS_nroregistrac = Pacientes.PAC_codhci"+;
		" Join Sectores On Sectores.SEC_codsector = Pacientes.PAC_sectorinternac"+;
		" group by pac_codadmision,pac_habitacion,pac_cama","mwkcuidint")

	If mret < 0
		MTABLA = "CUIDADOS DOMICILIARIOS - BUSQUEDA DE INTERNACIONES"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

*!* Alertas por Altas / Obitos - siempre que no hallan sido acentados con su estado correspondiente del lado de CD
*!* 2013-07-08 se excluye FINALIZADOS y ANULADOS

	Use In Select("mwkalert2")
*!*		mret = SQLExec(mcon1,"select PAC_codhci,PAC_nombrepaciente,PAC_fechaadmision,PAC_motivoadmision,"+;
*!*			" MTI_Descripcion, PAC_fechaalta, PAC_motivoalta, TCS_estado, TCS_fecest, motivoegreso.MTE_descripcion"+;
*!*			" from pacientes "+;
*!*			" join TabCuiDomSoli on TabCuiDomSoli.TCS_nroregistrac = Pacientes.PAC_codhci and TCS_estado <> 5"+;
*!*			" join motivointernac on motivointernac.MTI_CodMotivo = Pacientes.PAC_motivoadmision"+;
*!*			" join motivoegreso on motivoegreso.MTE_CodMotivo = pacientes.PAC_motivoalta "+;
*!*			" where ( Pac_tipopac<2  AND PAC_motivoalta = 6 )"+;
*!*			" or  ( Pac_tipopac<2  AND PAC_fechaalta is null and TCS_estado not in (3,4,6,7)) "+;
*!*			" or ( Pac_tipopac<2  AND PAC_fechaalta >= TCS_fecest and TCS_estado <> 2)"+;
*!*			" order by TCS_nroregistrac, PAC_fechaadmision","mwkalert2")


*** Marcelo Torres, 07/05/2021
*** Parche propuesto por Rodrigo.
    mFechaFiltro = GOMONTH(sp_busco_fecha_serv('DD'),-6)

	mret = SQLExec(mcon1,"select PAC_codhci,PAC_nombrepaciente,PAC_fechaadmision,PAC_motivoadmision," +;
		"MTI_Descripcion, PAC_fechaalta, PAC_motivoalta, TCS_estado," +;
		"TCS_fecest, motivoegreso.MTE_descripcion " +;
		"from %INORDER TabCuiDomSoli  " +;
		"join pacientes on TabCuiDomSoli.TCS_nroregistrac = Pacientes.PAC_codhci " +;
		"join motivointernac on motivointernac.MTI_CodMotivo = Pacientes.PAC_motivoadmision " +;
		"join motivoegreso on motivoegreso.MTE_CodMotivo = pacientes.PAC_motivoalta " +;
		"where (( Pac_tipopac<2  AND PAC_motivoalta = 6 ) " +;
		"or  ( Pac_tipopac<2  AND PAC_fechaalta is null and TCS_estado not in (3,4,6,7)) " +;
		"or ( Pac_tipopac<2  AND PAC_fechaalta >= TCS_fecest and TCS_estado <> 2)) " +;
		"and TCS_estado <> 5 " +;
		"and TCS_fecarga between ?mFechaFiltro and current_date " +;
		"order by TCS_nroregistrac, PAC_fechaadmision","mwkAlert2")


*!*	1: "SOLICITAR"
*!*	2: "ACTIVAR"
*!*	3: "PASAR A PENDIENTE"
*!*	4: "REINTERNAR"
*!*	5: "PASAR A OBITO"
*!*	6: "FINALIZAR"
*!* 7: "ANULADO"

*!* Este query se lee :
*!*	- Obitos sin estado Obito desde CD
*!*	- Internados sin estado Pendiente o Reinternado desde CD
*!*	- Altas sin estado Activo dede CD

	If mret < 0
		MTABLA = "CUIDADOS DOMICILIARIOS - BUSQUEDA DE ALERTAS"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

Else

	Use In Select("mwkcuidomD")

	mret = SQLExec(mcon1,"select TCS_nroregistrac->REG_nombrepac, TabCuiDomSoli.*, Entidades.ENT_descrient as lentidad,"+;
		" preregistra.nombre as lnombre"+;
		" from TabCuiDomSoli"+;
		" left join Entidades on Entidades.ENT_codent = TabCuiDomSoli.TCS_entidad"+;
		" left join preregistra on preregistra.id = TabCuiDomSoli.TCS_nroregistrac "+;
		" where TabCuiDomSoli.id = ?mlidcd","mwkcuidomD")

	If mret < 0
		MTABLA = "CUIDADOS DOMICILIARIOS"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

	mfnull = Ctod("01/01/1900")

	Use In Select("mwkcuidomPre")
	mret = SQLExec(mcon1,"select * "+;
		" from TabCuiDomPres "+;
		" where TCP_idsolic = ?mlidcd and TCP_pasivado = ?mfnull","mwkcuidomPre")

	If mret < 0
		MTABLA = "CUIDADOS DOMICILIARIOS PRESTACIONES"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

	Use In Select("mwkcuidomEqp")
	mret = SQLExec(mcon1,"select * "+;
		" from TabCuiDomEqui "+;
		" Where TCE_idsolic = ?mlidcd And TCE_pasivado = ?mfnull","mwkcuidomEqp")

	If mret < 0
		MTABLA = "CUIDADOS DOMICILIARIOS EQUIPAMIENTO"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif


	Use In Select("mwkcuidomInd")
	mret = SQLExec(mcon1,"select TabCuiDomIndi.*, insumos.INS_codpuntero"+;
		" from TabCuiDomIndi "+;
		" left join insumos on insumos.INS_codinsumo = TabCuiDomIndi.TCI_codinsumo"+;
		" Where TCI_idsolic = ?mlidcd And TCI_pasivado = ?mfnull","mwkcuidomInd")

	If mret < 0
		MTABLA = "CUIDADOS DOMICILIARIOS INDICACIONES"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

	Use In Select("mwkestpre")
	mret = SQLExec(mcon1,"select descrip,subestado"+;
		" from tabestados where propietario=5 and estado=1 and tipo=0 order by subestado","mwkestpre")

	If mret < 0
		MTABLA = "CUIDADOS DOMICILIARIOS PRESTACIONES"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

	Use In Select("mwkesteqp")
	mret = SQLExec(mcon1,"select descrip,subestado"+;
		" from tabestados where propietario=5 and estado=2 and tipo=0 order by subestado","mwkesteqp")

	If mret < 0
		MTABLA = "CUIDADOS DOMICILIARIOS EQUIPOS"
		Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

Endif

Return .T.
