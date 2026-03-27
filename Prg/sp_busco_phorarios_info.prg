***
** Generacion de planilla de Turnos para informes
***
parameter mfectur1, midmedico, mcodesp , msel_med

if type ('msel_med')#"C"
	msel_med =	' turnos.codmed = ?midmedico and '
endif

if type('mcodesp') # "C"
	msel_esp = ""
else
	msel_esp = " turnos.codesp = ?mcodesp and "
endif

lsigue = .t.
mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	' where id<100000 order by fechacierre ','mwkctrlfecha')
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_phorarios1'
	cancel
endif
go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
use in mwkctrlfecha

if !used('mwkpmed')
	do sp_busco_phordatos
endif
&& busco en turnos
if mfectur1 > mfechalimite
	mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
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
		'turnos.fechatur = ?mfectur1 ' + ;
		'group by turnos.fechatur, afi_nroafiliado, turnos.codreserva ' + ;
		'', 'mwkphorario1')
else
&& busco en turnoshis
	mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
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
		'turnos.fechatur = ?mfectur1 ' + ;
		'group by turnos.fechatur, afi_nroafiliado, turnos.codreserva ' + ;
		'', 'mwkphorario1')
endif
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	do prg_error with eros,'sp_busco_phorarios4'
endif
select fechatur, left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
	ent_descrient, pre_descriprest, codreserva, nvl(val_nroprotocolo,1000000-1000000) as val_nroprotocolo,reg_telefonos, ;
	iif(isnull(fechaobserva),"                   ",ttoc(fechaobserva)) as fechaobserva, ;
	left(reg_nrohclinica, 10) as reg_nrohclinica, usuario, fechatomado, ;
	afi_nroafiliado, reg_numdocumento, observa,idturnoexterno, ;
	nombre, horatur, mwkphorario1.id, codent, codmed, codmedsoli, ;
	tipoturno, solicigia, mwkphorario1.codesp, codprest, diasem, confirmado, codserv, afi_fechabaja, ;
	ent_turnoshabilit, ent_fecpas, afiliado, nrovale, '' as sala ;
	,int((mfectur1-nvl(fechanac,mfectur1))/365) as edad,esp_descripcion,VAL_codpun ;
	, VAL_codadmision, VAL_codsector, VAL_fechasolicitud,  VAL_horasolicitud,;
   VAL_codvaleasist,  VAL_urgenciaserv, VAL_tipopaciente,  VAL_codservvale,;
   VAL_cama,  VAL_habitacion,  VAL_FHSolicitud,  VAL_FechaHoraImagen;
   ,sp_busco_datos_regis_cond( afiliado," and RCE_tipoCondesp  = 15 And  RCE_fechahasta>= {fn curdate()} ",;
			"mwkpacvip",1) As lespactras ;
 	from mwkphorario1 ;
	left join mwkpent on codent = ent_codent ;
	left join mwkpesp on codesp = esp_codesp ;
	left join mwkpmed on codmed = mwkpmed.id ;
	left join mwkppres on codprest = pre_codprest ;
	order by horatur, afiliado;
	into cursor mwkphorario


msql = "select * from mwkphorario order by fechatur, codmed,horatur into cursor mwkphorarios"

if used('mwkphorario1')
	use in mwkphorario1
endif
