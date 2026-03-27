****
** Busqueda de Protocolo
****
Parameter mnroadm, msec, msect,midant
Local mFecPasiva
mnroadm = Alltrim(mnroadm)
mFecPasiva = Ctod("01/01/1900")
mhoy = sp_busco_fecha_serv("DD")
midant= Iif(Vartype(midant)#"N",0,midant)
mfecing = mwkfecserv.fechahora
If mwkusuario.codigovax = 54035
	Set Step On
Endif
If midant>0
	mret = SQLExec(mcon1, "update tabintHCE set IH_fechaHoraIng = ?mfecing , IH_secagrup =?msect where id = ?midant")
Else
	mfecnul = Ctot("01/01/1900")
	musu    = Iif(Used('mwkusuarios'),mwkusuarios.codigovax,mwkusuario.codigovax)

	mret = SQLExec(mcon1, "insert into tabintHCE (IH_admision ,IH_codcie,IH_codmed ,IH_codmedcie"+;
	",IH_codestado, IH_fechaHoraIng, IH_secuencia,IH_horaCierre,IH_secagrup , IH_usuario,"+;
	"IH_motIngreso, IH_procedencia) values (?mnroadm, 0,1,1,0,?mfecing,?msec ,?mfecnul,?msect,?musu,0,0)")

	mret = SQLExec(mcon1, "select pacinternad.*, Tabinthce.ID, IH_admision, IH_codcie, "+;
	"IH_codestado, IH_codmed, IH_codmedcie, IH_fechaHoraIng, IH_horaCierre,"+;
	"IH_motIngreso, IH_procedencia, IH_reingre, IH_secagrup, IH_secuencia, IH_usuario,EI_idevol "+;
	" from pacinternad "+;
	" left join TabintHCE on pin_codadmision  = tabintHCE.IH_admision " + ;
	" left join TabintEvol on tabintHCE.id = tabintevol.EI_idevol " + ;
	" where pin_codadmision = ?mnroadm " , "mwkinterna010")

	Select mwkinterna010.*,SectorAgrup,mwksecagrup.descripcion  ;
	from mwkinterna010 ;
	left Join mwksecagrupnew On mwksecagrupnew.SectorAgrup = IH_secagrup  ;
	where TSA_FechaHasta >= mhoy ;
	into Cursor mwkinterna01
&& paso nutricion

	Do sp_busco_tabintnut With 2, " and IH_admision= '"+Alltrim(mnroadm)+"' order by IH_admision,ih_secuencia desc,TNP_Dieta   " ;
	,'mwkIntNutant'
	Select mwkIntNutant
	misec = mwkIntNutant.IH_secuencia
** -------- Nuevo Idevol
	Select Max(Id) As newid From  mwkinterna01 Into Cursor mwkctrlnut
	xmidevolhce = mwkctrlnut.newid
** ---------------------
	Select mwkIntNutant
	Scan
		If IH_secuencia=misec
			xmobser = mwkIntNutant.IN_observa
			xmobsernut = mwkIntNutant.IN_observanut

			xlactualizo = 2
			xtadmision = mnroadm
			xmcprest = mwkIntNutant.IN_codprest
			xcodmed = mwkIntNutant.IN_codmed
			Do sp_grabo_evol_int_nut With xmidevolhce,xmobser,xlactualizo,,xtadmision,,xmcprest,xcodmed,misec+1,xmobsernut 

		Endif
	Endscan

** ----- Marcelo Torres, 29/09/2016
** ----- Pasamos la Prescripción Medica.
** TabIntPmSolu
** TabIntPmAgre
** TabIntPmPlan
** TabIntPmPRes - Ultima prescripcion
** TabIntPmVales - Vales despues de la ultima prescripcion.

	mret = SQLExec(mcon1,"select MAX(ps_idevol) as ps_idevol from TabIntPmSolu where ps_admision = ?mnroadm and ps_fecpasiva = ?mFecPasiva group by ps_idevol order by ps_idevol desc","mwkPmsAnte")

	mIdevolAnte = 0

	Select mwkPmsAnte
	Go Top

	If Reccount("mwkPmsAnte") > 0 And mwkPmsAnte.ps_idevol < xmidevolhce

		mIdevolAnte = mwkPmsAnte.ps_idevol

		mret = SQLExec(mcon1,"insert into TabIntPmSolu (PS_Observa,PS_admision,PS_baxter,PS_cantidad,PS_cantpres,PS_comentarios,PS_estadodia,PS_fechoraini," +;
		"PS_fechoralta,PS_fechormodif,PS_fecpasiva,PS_goteo,PS_goteogtsmin,PS_goteomacmic,PS_goteomlhr,PS_goteotmp,PS_goteotuni,PS_goteovol,PS_guia," +;
		"PS_idac,PS_idevol,PS_insumo,PS_motivo,PS_tipo,PS_trajopaciente,PS_unidad,PS_unidadvol,PS_unipres,PS_urgente,PS_usuarioalta,PS_usuariomodif,PS_via,PS_volumen) " + ;
		"select PS_Observa,PS_admision,PS_baxter,PS_cantidad,PS_cantpres,PS_comentarios,PS_estadodia,PS_fechoraini,PS_fechoralta,PS_fechormodif,PS_fecpasiva," + ;
		"PS_goteo,PS_goteogtsmin,PS_goteomacmic,PS_goteomlhr,PS_goteotmp,PS_goteotuni,PS_goteovol,PS_guia,PS_idac,?xmidevolhce,PS_insumo,PS_motivo,PS_tipo,PS_trajopaciente," + ;
		"PS_unidad,PS_unidadvol,PS_unipres,PS_urgente,PS_usuarioalta,PS_usuariomodif,PS_via,PS_volumen " + ;
		"from TabIntPmSolu where ps_idevol = ?mIdevolAnte and ps_fecpasiva = ?mFecPasiva" )

		If mret<=0
			Messagebox("ERROR EN LA LECTURA DE TABINTPMSOLU",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		mret = SQLExec(mcon1,"insert into TabIntPmAgre (PA_admision,PA_baxter,PA_cantidad,PA_cantpres,PA_comentarios,PA_dosis,PA_estadodia,PA_fechoralta,PA_fechormodif," + ;
		"PA_fecpasiva,PA_guia,PA_idac,PA_idevol,PA_insumo,PA_motivo,PA_tipo,PA_trajopaciente,PA_unidad,PA_unidadvol,PA_unipres,PA_usuarioalta,PA_usuariomodif) " + ;
		"select PA_admision,PA_baxter,PA_cantidad,PA_cantpres,PA_comentarios,PA_dosis,PA_estadodia,PA_fechoralta,PA_fechormodif," + ;
		"PA_fecpasiva,PA_guia,PA_idac,?xmidevolhce,PA_insumo,PA_motivo,PA_tipo,PA_trajopaciente,PA_unidad,PA_unidadvol,PA_unipres,PA_usuarioalta,PA_usuariomodif " + ;
		"from TabIntPmAgre where pa_idevol = ?mIdevolAnte and pa_fecpasiva = ?mFecPasiva" )

		If mret<=0
			Messagebox("ERROR EN LA LECTURA DE TABINTPMAGRE",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		mret = SQLExec(mcon1,"insert into TabIntPmPlan (PP_FecHorProxDosis,PP_admision,PP_baxter,PP_dosis,PP_estadodia,PP_fechoralta,PP_fechormodif," + ;
		"PP_fecpasiva,PP_frecuencia,PP_guia,PP_idevol,PP_idopt,PP_insumo,PP_motivo,PP_tipo,PP_unidadvol,PP_urgente,PP_usuarioalta,PP_usuariomodif,PP_valfrec) " + ;
		"select PP_FecHorProxDosis,PP_admision,PP_baxter,PP_dosis,PP_estadodia,PP_fechoralta,PP_fechormodif," + ;
		"PP_fecpasiva,PP_frecuencia,PP_guia,?xmidevolhce,PP_idopt,PP_insumo,PP_motivo,PP_tipo,PP_unidadvol,PP_urgente,PP_usuarioalta,PP_usuariomodif,PP_valfrec " + ;
		"from TabIntPmPlan where pp_idevol = ?mIdevolAnte and pp_fecpasiva = ?mFecPasiva" )

		If mret<=0
			Messagebox("ERROR EN LA LECTURA DE TABINTPMPLAN",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		mret = SQLExec(mcon1,"insert into TabIntPmPres (PPS_FecHora,PPS_idevol,PPS_usuariomodif) " + ;
		"select top 1 PPS_FecHora,?xmidevolhce,PPS_usuariomodif " + ;
		"from TabIntPmPres where PPS_idevol = ?mIdevolAnte and pps_FecHora = (select max(PPS_FecHora) from tabintpmpres where pps_idevol = ?mIdevolAnte)" )

		If mret<=0
			Messagebox("ERROR EN LA LECTURA DE TABINTPMPRES",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

** --------------- Obtengo los nros. de vale maximos para cada insumo
*!*			mret = SQLExec(mret,"select IPV_confirmado,IPV_fechormodif,IPV_idevol,IPV_idreginsumo,IPV_instipo,IPV_movimiento,IPV_usuariomodif,max(ipv_vale) as IPV_vale " + ;
*!*				"from TabIntPmVales where IPV_idevol = ?mIdevolAnte group by ipv_idreginsumo order by ipv_idreginsumo","mwkValesAnte")

		mret = SQLExec(mcon1,"select a.IPV_confirmado,a.IPV_fechormodif,a.IPV_idevol,a.IPV_idreginsumo,a.IPV_instipo,a.IPV_movimiento,a.IPV_usuariomodif,max(a.ipv_vale) as IPV_vale," + ;
		"b.ps_insumo as insumo,b.ps_guia as guia,c.id as idreg " + ;
		"from TabIntPmVales as a " + ;
		"inner join tabintpmsolu as b on a.ipv_idreginsumo = b.id and a.ipv_instipo = 'P' " + ;
		"inner join tabintpmsolu as c on b.ps_insumo = c.ps_insumo and b.ps_guia = c.ps_guia and c.ps_idevol = ?xmidevolhce and c.ps_fecpasiva = '1900-01-01' " +;
		"where a.IPV_idevol = ?mIdevolAnte and b.ps_fecpasiva = '1900-01-01' and " +;
		"ipv_fechormodif >= (select max(pps_fechora) from tabintpmpres where pps_idevol = ?xmidevolhce) " +;
		"group By a.ipv_idreginsumo Order By a.ipv_idreginsumo" ,"mwkValesAnteP" )

		If mret<=0
			Messagebox("ERROR EN LA LECTURA DE VALES P",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		mret = SQLExec(mcon1,"select a.IPV_confirmado,a.IPV_fechormodif,a.IPV_idevol,a.IPV_idreginsumo,a.IPV_instipo,a.IPV_movimiento,a.IPV_usuariomodif,max(a.ipv_vale) as IPV_vale," + ;
		"b.pa_insumo as insumo,b.pa_guia as guia,c.id as idreg " + ;
		"from TabIntPmVales as a " + ;
		"inner join tabintpmAgre as b on a.ipv_idreginsumo = b.id and a.ipv_instipo = 'A' " + ;
		"inner join tabintpmAgre as c on b.pa_insumo = c.pa_insumo and b.pa_guia = c.pa_guia and c.pa_idevol = ?xmidevolhce and c.pa_fecpasiva = '1900-01-01' " +;
		"where a.IPV_idevol = ?mIdevolAnte and b.pa_fecpasiva = '1900-01-01' and " +;
		"ipv_fechormodif >= (select max(pps_fechora) from tabintpmpres where pps_idevol = ?xmidevolhce) " +;
		"group by a.ipv_idreginsumo order by a.ipv_idreginsumo" ,"mwkValesAnteA" )

		If mret<=0
			Messagebox("ERROR EN LA LECTURA DE VALES A",26,"ERROR")
			Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Return .F.
		Endif

		Select * From mwkValesAnteA Union All Select * From mwkValesAnteP Into Cursor mwkValesAnte

** -- Insertamos los registros
		Dimension aVales(8)

		Select mwkValesAnte
		Go Top
		Scan All

			aVales[1] = mwkValesAnte.IPV_confirmado
			aVales[2] = mwkValesAnte.IPV_fechormodif
			aVales[3] = xmidevolhce
			aVales[4] = mwkValesAnte.idReg  &&el nuevo nro. de registro.
			aVales[5] = mwkValesAnte.IPV_instipo
			aVales[6] = mwkValesAnte.IPV_movimiento
			aVales[7] = mwkValesAnte.IPV_usuariomodif
			aVales[8] = mwkValesAnte.IPV_vale


			mret = SQLExec(mcon1,"insert into TabIntPmVales (IPV_confirmado,IPV_fechormodif,IPV_idevol,IPV_idreginsumo,IPV_instipo,IPV_movimiento,IPV_usuariomodif,IPV_vale) " + ;
			"values(" + ;
			"?aVales[1],?aVales[2],?aVales[3],?aVales[4],?aVales[5],?aVales[6],?aVales[7],?aVales[8])" )

			If mret<=0
				Messagebox("ERROR AL INSERTAR DATOS EN TABINTPMVALES",26,"ERROR")
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Exit
			Endif
			Select mwkValesAnte

		Endscan

		Use In Select("mwkValesAnte")

	Endif

** ------------------------------------

Endif
