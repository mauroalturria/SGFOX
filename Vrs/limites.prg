*al ingresar a la evolucion
Do sp_busco_estados With 109,' and tipo = 103 ','mwklimxesp' &&& limites por especialidad si es dada por un profesional de at.directa o no
Do sp_busco_estados With 109,' and tipo = 100 ','mwkhablimxesp' &&& habilita los limites por especialidad

* en los controles con el protocolo
************* control para limites y derivaciones de Medico de familia
.lprestadirecta = 1

Select mwkveoproto
lnmfentidad = Nvl(mwkafient.ENT_codagrup,mwkambu1.codent)
Select mwkMFamEnt
Locate For EMF_CodEntidad = lnmfentidad
If Found()
	.lprestadirecta = prg_medfam_directa(mwkveoproto.CodPrest,mwkveoproto.pre_especialidad)
Else

Endif
Do sp_busco_tabsol_Limite With mwkveoproto.REG_nroregistrac, mwkveoproto.pre_especialidad
If .lprestadirecta = 9
	Select Mwksollimite
	Locate For SL_cantidad <SL_limite
	If (Eof() Or Reccount("Mwksollimite")=0) And Vartype(frmambula03)="O" &&& solo si ingresa por consultorio del dia
&&& si no existe y lo estoy atendiendo asumo que viene de antes por lo que grabo el registro que debiera haberse grabado
* antes pero con el limite minimo
		mlimite = 1
		Do sp_grabo_tabsol_Limite With 1,mwkveoproto.REG_nroregistrac, mwkveoproto.pre_especialidad ,mlimite,mimedico
		Do sp_busco_tabsol_Limite With mwkveoproto.REG_nroregistrac, mwkveoproto.pre_especialidad
		Select Mwksollimite
		Locate For SL_cantidad <SL_limite
	Else
		Select Mwksollimite &&& si no es que ya llego al limite de consultas y ubico e registro para bloquear los pedidos de turnos o IC
		Go Bott
	Endif

Endif
***********
*!*	determina si una prestacion es de atencion directa si es de atencion directa devuelve 2 si no devuelve 9 si esta liberada devuelve 1 practicas x ejemplo
* prg_medfam_directa
Lparameters lncodprest,lncodesp,lncodent
Local lnDirecta
lnDirecta = 1
If Vartype(lncodesp)<>"C"
	lncodesp = ''
Endif
If Vartype(lncodent)<>"N"
	lncodent= 948
Endif
mret = SQLExec(mcon1,"select pre_descriprest, pre_codprest , pre_codservicio, pre_especialidad "+;
	" FROM prestacions where pre_fechapasiva is null and " + ;
	"pre_codprest = ?lncodprest " , "mwkprestdi")
lncodesp = mwkprestdi.pre_especialidad
lnservi = mwkprestdi.pre_codservicio
Use In Select("mwkprestdi")
If lnservi  <>2200
	Return lnDirecta
Else
	mret = SQLExec(mcon1," select id  FROM Zabespecexcluentidad "+;
		" where {fn curdate()} between  EXE_VigenciaDesde and  EXE_VigenciaHasta"+;
		" and EXE_CodEntidad = ?lncodent and CodAmbito=?mxambito and EXE_CodEspecialidad = ?lncodesp "  +;
		" and EXE_TipoExclusion = -1 ", "mwkMFdir")
	If Reccount("mwkMFdir")>0
		lnDirecta = 2
		Use In Select("mwkMFdir")
		Return lnDirecta
	Else
		mret = SQLExec(mcon1," select id FROM Zabprestacexcluentidad "+;
			" where {fn curdate()} between  PXE_VigenciaDesde and  PXE_VigenciaHasta"+;
			" and PXE_CodEntidad= ?lncodent and CodAmbito=?mxambito and PXE_CodPrestacion= ?lncodprest "  +;
			" and PXE_TipoExclusion= -1 ", "mwkMFdir")
		lnDirecta = Iif(Reccount("mwkMFdir")>0,2,9)
		Use In Select("mwkMFdir")
		Return lnDirecta
	Endif
Endif

*******************
* antes de ir a buscar un turno
*******
If Thisform.lprestadirecta>1 And mwkveoproto.pre_codservicio = 2200 And  mwkhablimxesp.estado = 1

	If !Used('mwkExcEsp')
		mret = SQLExec(mcon1," select CodAmbito, EXE_CodEntidad, EXE_CodEspecialidad,  EXE_TipoExclusion"+;
			" FROM Zabespecexcluentidad "+;
			" where {fn curdate()} between  EXE_VigenciaDesde and  EXE_VigenciaHasta", "mwkExcEsp")
	Endif
	Select * From mwkExcEsp Where EXE_CodEspecialidad = mwkveoproto.pre_especialidad And EXE_TipoExclusion = 5 Into Cursor mwkesplibre
	If Reccount('mwkesplibre')=0  &&& significa que no es una especialidad de las sin limite
&&& limites por especialidad si es dada por un profesional de at.directa o no
		Select mwklimxesp
		Locate For subestado = Thisform.lprestadirecta
		milim = Val(Descrip)
		ldfechoy  = sp_busco_fecha_serv('DD')
		lfecdes = prg_dtoc(ldfechoy )&&-60 tomo de hoy rn adelane
		mespe = " and pre_especialidad = '"+Alltrim(mwkveoproto.pre_especialidad)+"' "
		msql_cons = ''
*!*			Do sp_busco_tabsolprac With 2," where  ASP_tipopac = 'AMB' and ASP_fechasol >='&lfecdes' and ASP_codestado = 1 and "+;
*!*				" ASP_protocolo <>'"+Alltrim(Thisform.lcprotocolo)+"' and ASP_nroregistrac = "+Transform(mwkveoproto.REG_nroregistrac);
*!*				+mespe + " order by TabSolPract.Id", "mwksolprac1"
		Do sp_busco_tabsolprac With 2," where  ASP_tipopac = 'AMB' and ASP_fechasol >='&lfecdes' and ASP_codestado = 1 and "+;
			" ASP_nroregistrac = "+Transform(mwkveoproto.REG_nroregistrac);  &&&  ASP_protocolo <>'"+Alltrim(Thisform.lcprotocolo)+"' and
		+mespe + " order by TabSolPract.Id", "mwksolprac1"

		Do sp_busco_turnos_tomados With ldfechoy+1, ldfechoy + 50," and afiliado =  "+Transform(mwkveoproto.REG_nroregistrac)+mespe			natendido =Iif(mwkveoproto.tipoest >0 And  Vartype(frmambula03)="O" ,1,0)+ Mwksollimite.SL_cantidad
*agregu esto
		natendido =Iif(mwkveoproto.tipoest >0 And  Vartype(frmambula03)="O" ,1,0)+ Mwksollimite.SL_cantidad
*
		If .lprestadirecta = 9
*			If  Mwksollimite.SL_limite <= Mwksollimite.SL_cantidad +Reccount("mwkTurnosTom") +Reccount('mwksolprac1')
			If  Mwksollimite.SL_limite <= natendido  +Reccount("mwkTurnosTom") +Reccount('mwksolprac1')

				Messagebox("NO ESTA AUTORIZADO A CITAR NUEVAMENTE AL PACIENTE,"+Chr(13)+;
					"DEBE DERIVARLO A UN MEDICO DE FAMILIA",16,"Plan Médico de Familia")
				Return
			Endif
		Endif
	Endif

Endif
*********************
*al grabar la evolucion actualizo
** actualizo limite

mid = 0
mcodprest = mwkveoproto.CodPrest
milinea =  39
mnroreg		= mwkveoproto.REG_nroregistrac
Select mwkMFamEnt
Locate For  EMF_CodEntidad  = mwkbuspacie.ENT_codagrup
diasvto = 90
If Found()
	diasvto = mwkMFamEnt.EMF_DuracPrescripcio
Endif
fecvig = prg_dtoc(sp_busco_fecha_serv("DD")- diasvto ) &&&actualmente 90 dias para atras
mbusca = " and ASP_nroregistrac = "+Transform(mnroreg)+" and ASP_fechasol>=?fecvig and ASP_codprest = "+Transform(mcodprest)
Do sp_busco_prest_hab With mbusca
If Reccount('mwkderivsol')>0
	micant = mwkderivsol.ASP_cantidad - 1 &&& esto quedo asi porque pensaba usar la cantidad aca y descontar xq no entendia que pedian las PM
	midpl = mwkderivsol.Id
	miestado = Iif(micant <1 Or mwkveoproto.codserv <>2200,2,1) &&& le debe poner estado 2 que es realizado
	Select mwkderivsol
	Do sp_grabo_tabSolPrac With 2,miestado ,,,,micant ,,,,midpl
Endif
Select mwklimxesp
Locate For subestado = Thisform.lprestadirecta
milim = Val(Descrip)
Do sp_busco_tabsol_Limite With mwkveoproto.REG_nroregistrac, Alltrim(mwkveoproto.pre_especialidad)
*If Thisform.lprestadirecta = 9 And  Reccount('mwkderivsol')>0 && es el pedido que finalice recien, para que solo descuente cuando graba la primera vez, si vuelve a ingresar a la evoluciony graba no descuenta nada				If Thisform.lprestadirecta = 9 AND  (mwkveoproto.tipoest >0 and  Vartype(frmambula03)="O" )
If Thisform.lprestadirecta = 9 AND  (mwkveoproto.tipoest >0 and  Vartype(frmambula03)="O" )
	Select Mwksollimite
	Locate For SL_cantidad <SL_limite
	If !(Eof() Or Reccount("Mwksollimite")=0)
		mlimite = Mwksollimite.SL_cantidad-1
		midpl = Mwksollimite.Id
		Do sp_grabo_tabsol_Limite With 2,mwkveoproto.REG_nroregistrac, mwkveoproto.pre_especialidad ,mlimite,Thisform.medcabecera,midpl,milim
		Do sp_busco_tabsol_Limite With mwkveoproto.REG_nroregistrac, mwkveoproto.pre_especialidad
	Endif
Endif
*********************
*******************************
* al ir a solicitar una derivacion(practica) frmautor13
******************************
*primero verifico que tipo de practica estoy brindandole a lpacinete
Thisform.lprestadirecta = 1

Select mwkveoproto
lnmfentidad = mwkafient.ENT_codagrup
Select mwkMFamEnt
Locate For EMF_CodEntidad = lnmfentidad
If Found()
	Thisform.lprestadirecta = prg_medfam_directa(mwkveoproto.CodPrest)
Endif

*despues de seleccionar la practica solicitada
If Thisform.lprestadirecta>1 And mwkbuscotexto.pre_codservicio = 2200 And mwkhablimxesp.estado = 1
&&& limites por especialidad si es dada por un profesional de at.directa o no
	Select mwklimxesp
	Locate For subestado = Thisform.lprestadirecta
	milim = Val(Descrip)
	If !Used('mwkExcEsp')
		mret = SQLExec(mcon1," select CodAmbito, EXE_CodEntidad, EXE_CodEspecialidad,  EXE_TipoExclusion"+;
			" FROM Zabespecexcluentidad "+;
			" where {fn curdate()} between  EXE_VigenciaDesde and  EXE_VigenciaHasta", "mwkExcEsp")
	Endif
	Select * From mwkExcEsp Where EXE_CodEspecialidad = mwkbuscotexto.pre_especialidad And EXE_TipoExclusion = 5 Into Cursor mwkesplibre
	If Reccount('mwkesplibre')=0  &&& significa que no es una especialidad de las sin limite
		ldfechoy  = sp_busco_fecha_serv('DD') &&- 60
		lfecdes = prg_dtoc(ldfechoy )
		mespe = " and pre_especialidad = '"+Alltrim(mwkbuscotexto.pre_especialidad)+"' "
		msql_cons = ''
		Do sp_busco_tabsolprac With 2," where  ASP_tipopac = 'AMB' and ASP_fechasol >='&lfecdes' and ASP_codestado = 1 and "+;
			"ASP_protocolo <>'"+Alltrim(Thisform.lcprotocolo)+"' and ASP_nroregistrac = "+Transform(mwkbuspacie.REG_nroregistrac);
			+mespe + " order by TabSolPract.Id", "mwksolprac1"
		Do sp_busco_turnos_tomados With ldfechoy+1, ldfechoy + 60," and afiliado =  "+Transform(mwkveoproto.REG_nroregistrac)+mespe

		If Thisform.lprestadirecta = 9 And mwkbuscotexto.pre_especialidad = mwkveoproto.pre_especialidad
	natendido =IIF( mwkveoproto.tipoest >0 And  Vartype(frmambula03)="O" ,1,0)+ Mwksollimite.SL_cantidad
				If  Mwksollimite.SL_limite <= natendido  +Reccount("mwkTurnosTom") +Reccount('mwksolprac1')
		
		*	If  Mwksollimite.SL_limite <= Mwksollimite.SL_cantidad+Reccount("mwkTurnosTom") +Reccount('mwksolprac1')
				Messagebox("NO ESTA AUTORIZADO A CITAR NUEVAMENTE AL PACIENTE,"+Chr(13)+;
					"DEBE DERIVARLO A UN MEDICO DE FAMILIA",16,"Plan Médico de Familia")
				lsigue = .F.
			Endif
		Endif
	Endif
Endif
*****************
*  al grabar, busco los limites
&&& limites por especialidad si es dada por un profesional de at.directa o no
Select mwklimxesp
Locate For subestado = Thisform.lprestadirecta
milim = Val(Descrip)
* Y para todo lo solicitado grabo los limites
Select mwkreceta
Go Top
Scan
	If  Thisform.lprestadirecta>1 And mwkreceta.servicio = 2200
		Do sp_grabo_tabsol_Limite With 1,mApv_registracio ,mwkreceta.codesp,milim ,mcsolic
	Endif
Endscan


