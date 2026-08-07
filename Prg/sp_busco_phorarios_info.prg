***
** Generacion de planilla de Turnos para informes
***
Parameter mfectur1, midmedico, mcodesp , msel_med,lxcentro

If Vartype (msel_med)#"C"
	msel_med =	' turnos.codmed = ?midmedico and '
Endif
If Vartype(lxcentro)<>"N"
	lxcentro = 0
Endif
mccentro =''
Do Case
Case lxcentro= 0 Or mxambito >1
	mccentro = ''
Case lxcentro=1
	mccentro =  " and ambcentro = 1 "
Case lxcentro=2
	mccentro =   " and ambcentro = 99 "
Case lxcentro=3
	mccentro =  " and ambcentro = 98 "
Case lxcentro=9
	mccentro = Iif(mxcentromedico =1," and ambcentro = 1 ",;
		Iif(mxcentromedico =2, " and  ambcentro = 99 "," AND  ambcentro = 98 "  ))
Endcase


 
If Vartype(mcodesp) # "C"
	msel_esp = ""
Else
	msel_esp = " turnos.codesp = ?mcodesp and "
Endif

lsigue = .T.
mret = SQLExec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	' where id<100000 order by fechacierre ','mwkctrlfecha')
If mret < 0
	=Aerr(eros)
	Do prg_error With eros,'sp_busco_phorarios1'
	Cancel
Endif
Go Bottom In mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
Use In mwkctrlfecha

If !Used('mwkpmed')
	Do sp_busco_phordatos
Endif
&& busco en turnos
If mfectur1 > mfechalimite
	mret = SQLExec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
		'turnos.diasem, turnos.codprest, afi_nroafiliado, reg_telefonos, ' + ;
		'turnos.codreserva, registracio.reg_nrohclinica, registracio.reg_numdocumento,turnos.codserv,  ' + ;
		'registracio.reg_nombrepac,turnos.afiliado,turnos.idturnoexterno,' + ;
		'turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva, ' + ;
		'turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia, ' + ;
		'afi_fechabaja, turnos.afiliado, turnos.nrovale,reg_fecnacimiento as fechanac,Valesasist.* ' +;
		'from registracio, afiliacion,turnos  ' + ;
		' left join Valesasist on turnos.nrovale = Valesasist.VAL_codvaleasist '+ ;
		'where ' + ;
		'turnos.afiliado = registracio.reg_nroregistrac and ' + ;
		'registracio.reg_nroregistrac = afiliacion.registracio and ' + ;
		'turnos.codent = afiliacion.afi_codentidad and ' +  msel_esp + msel_med +;
		'turnos.fechatur = ?mfectur1 ' + mccentro +;
		'group by turnos.fechatur, afi_nroafiliado, turnos.codreserva ' + ;
		'', 'mwkphorario1')
Else
&& busco en turnoshis
	mret = SQLExec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
		'turnos.diasem, turnos.codprest, afi_nroafiliado, reg_telefonos, ' + ;
		'turnos.codreserva, registracio.reg_nrohclinica, registracio.reg_numdocumento, ' + ;
		'registracio.reg_nombrepac, Valesasist.*,turnos.afiliado,turnos.idturnoexterno,' + ;
		'turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva, turnos.codserv, ' + ;
		'turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia, ' + ;
		'afi_fechabaja, turnos.afiliado, turnos.nrovale ,reg_fecnacimiento as fechanac     ' +;
		'from registracio, afiliacion, turnoshis as turnos  ' + ;
		' left join Valesasist on turnos.nrovale = Valesasist.VAL_codvaleasist '+ ;
		'where ' + ;
		'turnos.afiliado = registracio.reg_nroregistrac and ' + msel_esp +msel_med+;
		'registracio.reg_nroregistrac = afiliacion.registracio and ' + ;
		'turnos.codent = afiliacion.afi_codentidad and ' + ;
		'turnos.fechatur = ?mfectur1 ' + mccentro +;
		'group by turnos.fechatur, afi_nroafiliado, turnos.codreserva ' + ;
		'', 'mwkphorario1')
Endif
If mret < 0
	=Aerr(eros)
	Messagebox(eros(3))
	Do prg_error With eros,'sp_busco_phorarios4'
Endif
Select fechatur, Left(Ttoc(horatur,2), 5) As hora, Left(reg_nombrepac, 40) As reg_nombrepac, ;
	ent_descrient, pre_descriprest, codreserva, Nvl(val_nroprotocolo,1000000-1000000) As val_nroprotocolo,reg_telefonos, ;
	iif(Isnull(fechaobserva),"                   ",Ttoc(fechaobserva)) As fechaobserva, ;
	left(reg_nrohclinica, 10) As reg_nrohclinica, usuario, fechatomado, ;
	afi_nroafiliado, reg_numdocumento, observa,idturnoexterno, ;
	nombre, horatur, mwkphorario1.Id, codent, codmed, codmedsoli, ;
	tipoturno, solicigia, mwkphorario1.codesp, codprest, diasem, confirmado, codserv, afi_fechabaja, ;
	ent_turnoshabilit, ent_fecpas, afiliado, nrovale, '' As sala ;
	,Int((mfectur1-Nvl(fechanac,mfectur1))/365) As edad,esp_descripcion,VAL_codpun ;
	, VAL_codadmision, VAL_codsector, VAL_fechasolicitud,  VAL_horasolicitud,;
	VAL_codvaleasist,  VAL_urgenciaserv, VAL_tipopaciente,  VAL_codservvale,;
	VAL_cama,  VAL_habitacion,  VAL_FHSolicitud,  VAL_FechaHoraImagen;
	,sp_busco_datos_regis_cond( afiliado," and RCE_tipoCondesp  = 15 And  RCE_fechahasta>= {fn curdate()} ",;
	"mwkpacvip",1) As lespactras ;
	from mwkphorario1 ;
	left Join mwkpent On codent = ent_codent ;
	left Join mwkpesp On codesp = esp_codesp ;
	left Join mwkpmed On codmed = mwkpmed.Id ;
	left Join mwkppres On codprest = pre_codprest ;
	order By horatur, afiliado;
	into Cursor mwkphorario


msql = "select * from mwkphorario order by fechatur, codmed,horatur into cursor mwkphorarios"

If Used('mwkphorario1')
	Use In mwkphorario1
Endif
