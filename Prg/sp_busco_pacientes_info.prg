*
* Busqueda de Pacientes Ambulatorios Turnos, Vales Demanda
*
parameters mdesde, midmedico, mcCursor, mbuscoVal, mBuscoTur

*!*	mdesde = Ctod("03/08/2009")
*!*	mhasta = mdesde
*!*	midmedico =  1048   && 1048&&1506&& 2549	
*!*	mcCursor = "caux1"

If Vartype(mbuscoVal)# "C" 
	mbuscoVal = ""
Endif	
If Vartype(mbuscoTur)# "C" 
	mbuscoTur = ""
Endif	

*--------------------------------------------------
if vartype(midmedico) # "N"
	msel_med = ""
else
	msel_med = " turnos.codmed = ?midmedico and "
endif

if !used('mwkentidad')
	mret = sqlexec(mcon1,"select * from entidades","mwkentidad")
endif

*!*	do sp_busco_phorarios with mdesde, mdesde, midmedico, 0

*!*	---------------------------------------------------------
*!*	BUSCO LOS SERVICIOS PARA EL MEDICO
*!*	---------------------------------------------------------
mbusco = " and demanda = 1 and codmed = ?midmedico "
Do sp_busco_Serv_medprest With mdesde, mbusco && mwkSrvMP
*!*	---------------------------------------------------------

mcServ = ""
Select mwkSrvMP
Scan All
	If Empty(mcServ)
		mcServ = mcServ + Alltrim(Str(mwkSrvMP.CodServ))
	Else
		mcServ = mcServ + ", " + Alltrim(Str(mwkSrvMP.CodServ))
	Endif 	
	Select mwkSrvMP
Endscan

Use In mwkSrvMP

*!*	--------------------------------------------------------- 	
mbusco = Iif(Empty(mcServ),""," and Ser_CodServ in (" + mcServ + ") ")
Do sp_busco_prestacion With "" && mwkprestac
*!*	--------------------------------------------------------- 	

mbusco = Iif(Empty(mcServ),""," and VAL_codservvale in (" + mcServ + ") ") + mbuscoVal

mret = sqlexec(mcon1, "select VAL_fechasolicitud, REG_nrohclinica, reg_nroregistrac, VAL_nroprotocolo, " + ;
		" REG_numdocumento, REG_nombrepac, VAL_codservvale, Val_codadmision, VAL_codsector, " + ;
		" VAL_horasolicitud, pia_codprest, reg_fecnacimiento, coberturas.COB_codentidad, " + ;
		" val_codpun, VAL_codvaleasist, codestado, TabTipoAltas.Descrip as EstadoAlta,	 " + ;
		" TabAmbulatorio.Id as AMB_Id, TabAmbulatorio.Protocolo, VAL_FHSolicitud  " + ;
	 	" from valesasist, pacientes, registracio " + ;
		" Inner join presinsuvas on presinsuvas.pia_valesasist = val_codpun " + ;
		" left join TabAmbulatorio on NroVale = val_codpun and CodPrest = pia_codprest " + ;
		" left join coberturas on valesasist.VAL_codadmision = coberturas.COB_pacientes " + ;
		" Left Join TabTipoAltas on CodEstado = TabTipoAltas.ID " + ;
		" where VAL_codsector = 'AMB' and VAL_circuitoorigen = 2 and " + ;
		" pacientes = VAL_codadmision and "+;
		" PAC_codhci = registracio and "+;
		" VAL_fechasolicitud = ?mdesde " + ;
		" " + mbusco + " " + ;
		"", "mwkconsumos")

*!*			
*!*			

if mret < 0
	messagebox("EN CONSULTA DE VALES DE DEMANDA" + chr(10) + "AVISE A SISTEMAS",48,"VALIDACION")
	Aerror(eros)
	return .f.
Endif

*!*	ESTO TRAE TODOS LOS PACIENTES EN SALA DE ESPERA
*!*	EL MEDICO SELECCIONA PARA ATENDER
*!*			" VAL_prestador =?midmedico " + mbusco + " " + ;

*!*		msql = "select VAL_fechasolicitud, REG_nrohclinica, " + ;
*!*			" REG_numdocumento,REG_nombrepac,VAL_codservvale,pre_descriprest " + ;
*!*			" from mwkconsumos3 order by VAL_fechasolicitud desc into cursor mwkconsu"

mret = sqlexec(mcon1, "select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp," + ;
	"turnos.diasem, turnos.codprest, afi_nroafiliado, reg_telefonos, REG_nroregistrac," + ;
	"turnos.codreserva, registracio.reg_nrohclinica, registracio.reg_numdocumento,turnos.codserv," + ;
	"registracio.reg_nombrepac," + ;
	"turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva," + ;
	"turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia," + ;
	"afi_fechabaja, turnos.afiliado, turnos.nrovale, medpresta.sala, " + ;
	"hdesde1, hhasta1 ,reg_fecnacimiento as fechanac,hhmmtur, " +;
	"registracio.reg_nroregistrac,Prestacions.PRE_descriprest as prestacion, "+ ;
	"Pre_Especialidad, " + ;
	"Prestadores.nombre as nombre " + ;
	" from turnos,registracio,afiliacion,medpresta" + ;
	" join Prestacions on pre_codprest = turnos.codprest"+ ;
	" left join Prestadores on Prestadores.Id = turnos.CodMed" + ;
	" where " + ;
	"turnos.afiliado = registracio.reg_nroregistrac and " + ;
	"registracio.reg_nroregistrac = afiliacion.registracio and " + ;
	"turnos.codent = afiliacion.afi_codentidad and " + ;
	"turnos.codmed   = medpresta.codmed and " + ;
	"turnos.codprest = medpresta.codprest and " + msel_med +;
	"turnos.diasem	 = medpresta.diasem and " + ;
	"turnos.fechatur >= medpresta.fecvigend and " + ;
	"medpresta.fecvigend <> medpresta.fecvigenh and " + ;
	"turnos.fechatur <  medpresta.fecvigenh and " + ;
	"turnos.hhmmtur >= medpresta.hhmmdes and " + ;
	"turnos.hhmmtur < medpresta.hhmmhas and " + ;
	"turnos.fechatur = ?mdesde " + ;
	" group by turnos.fechatur,afi_nroafiliado,turnos.codreserva,turnos.hhmmtur", "mwkphorarios")

if mret < 0
	messagebox("EN CONSULTA DE TURNOS REGISTRADOS" + chr(10) + "AVISE A SISTEMAS",16,"ERROR")
	return .f.
endif

*!*	---------------------------------------------------------
mret = sqlexec(mcon1,"select TabAmbulatorio.*, " + ;
	"TabTipoAltas.Descrip as EstadoAlta " + ;
	" from TabAmbulatorio"+;
	" Left Join TabTipoAltas on CodEstado = TabTipoAltas.ID " + ;
	" where fechahoraing = ?mdesde " + mBuscoTur + " " ,"mwkambula")

mret = sqlexec(mcon1,"select * from TabAmbMsg"+;
	" where TAM_fechah = ?mdesde ","mwkambmsg")

*!*	---------------------------------------------------------

select horatur,;
	iif(ttod(fechahoraing)=ctod("01/01/1900"),{//},fechahoraing) as fechahoraing,;
	reg_nombrepac as paciente,;
	mwkphorarios.prestacion,;
	mwkentidad.ENT_descrient,;
	fechanac,;
	TAM_mensaje as mensaje,;
	mwkAmbula.protocolo as protocolo,;
	mwkAmbula.id,;
	sala,;
	mwkphorarios.codmed,;
	mwkphorarios.codent,;
	mwkAmbula.codent as codent1,;
	codestado,;
	CodEsp,;
	codserv,;
	nombre, ;
	Reg_NroRegistrac,ENT_nroprestadorexterno, ;
	mwkphorarios.NroVale, mwkphorarios.codprest, EstadoAlta ;
	from mwkphorarios ;
	left join mwkentidad on ENT_codent=mwkphorarios.codent ;
	left join mwkAmbula on mwkAmbula.codprest=mwkphorarios.codprest and mwkAmbula.nrovale=mwkphorarios.nrovale;
	left join mwkAmbMsg on TAM_protocolo=mwkAmbula.protocolo and alltrim(TAM_protocolo) <> "0";
	into cursor mwkambula


