***
** Generacion de planilla de Turnos para informes
***
Parameter mfectur1, midmedico, mcodesp , msel_med

If type ('msel_med')#"C"
	msel_med =	' turnos.codmed = ?midmedico and '
Endif

If type('mcodesp') # "C"
	msel_esp = ""
Else
	msel_esp = " turnos.codesp = ?mcodesp and "
Endif

lsigue = .t.
mret = sqlexec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	' where id<100000 order by fechacierre ','mwkctrlfecha')
If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_busco_phorarios1'
	Cancel
Endif
Go bottom in mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
Use in mwkctrlfecha

If !used('mwkpmed')
	Do sp_busco_phordatos
Endif

&& busco en turnos

If mfectur1 > mfechalimite
	mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
		'turnos.diasem, turnos.codprest, afi_nroafiliado, reg_telefonos, ' + ;
		'turnos.codreserva, registracio.reg_nrohclinica, registracio.reg_numdocumento,turnos.codserv,  ' + ;
		'registracio.reg_nombrepac, VAL_NroProtocolo, ' + ;
		'turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva, ' + ;
		'turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia, ' + ;
		'afi_fechabaja, turnos.afiliado, turnos.nrovale,reg_fecnacimiento as fechanac    ' +;
		'from registracio, afiliacion,turnos  ' + ;
		' left join Valesasist on turnos.nrovale = Valesasist.VAL_codvaleasist '+ ;
		'where ' + ;
		'turnos.afiliado = registracio.reg_nroregistrac and ' + ;
		'registracio.reg_nroregistrac = afiliacion.registracio and ' + ;
		'turnos.codent = afiliacion.afi_codentidad and ' +  msel_esp + msel_med +;
		'turnos.fechatur = ?mfectur1 ' + ;
		'group by turnos.fechatur, afi_nroafiliado, turnos.codreserva ' + ;
		'', 'mwkphorario1')
Else
&& busco en turnoshis
	mret = sqlexec(mcon1, 'select turnos.id, turnos.fechatur, turnos.horatur, turnos.codesp, ' + ;
		'turnos.diasem, turnos.codprest, afi_nroafiliado, reg_telefonos, ' + ;
		'turnos.codreserva, registracio.reg_nrohclinica, registracio.reg_numdocumento, ' + ;
		'registracio.reg_nombrepac, VAL_NroProtocolo,' + ;
		'turnos.fechatomado, turnos.usuario, turnos.confirmado, turnos.observa, turnos.fechaobserva, turnos.codserv, ' + ;
		'turnos.codent, turnos.codmed, turnos.codmedsoli, turnos.tipoturno, turnos.solicigia, ' + ;
		'afi_fechabaja, turnos.afiliado, turnos.nrovale ,reg_fecnacimiento as fechanac    ' +;
		'from registracio, afiliacion, turnoshis as turnos  ' + ;
		' left join Valesasist on turnos.nrovale = Valesasist.VAL_codvaleasist '+ ;
		'where ' + ;
		'turnos.afiliado = registracio.reg_nroregistrac and ' + msel_esp +msel_med+;
		'registracio.reg_nroregistrac = afiliacion.registracio and ' + ;
		'turnos.codent = afiliacion.afi_codentidad and ' + ;
		'turnos.fechatur = ?mfectur1 ' + ;
		'group by turnos.fechatur, afi_nroafiliado, turnos.codreserva ' + ;
		'', 'mwkphorario1')
Endif

If mret < 0
	=aerr(eros)
	Messagebox(eros(3))
	Do prg_error with eros,'sp_busco_phorarios4'
Endif

Select fechatur, left(ttoc(horatur,2), 5) as hora, left(reg_nombrepac, 40) as reg_nombrepac, ;
	ent_descrient, pre_descriprest, codreserva, nvl(val_nroprotocolo,str(1000000-1000000)+' ') as val_nroprotocolo,reg_telefonos, ;
	iif(isnull(fechaobserva),"                   ",ttoc(fechaobserva)) as fechaobserva, ;
	left(reg_nrohclinica, 10) as reg_nrohclinica, usuario, fechatomado, ;
	afi_nroafiliado, reg_numdocumento, observa, ;
	nombre, horatur, mwkphorario1.id, codent, codmed, codmedsoli, ;
	tipoturno, solicigia, codesp, codprest, diasem, confirmado, codserv, afi_fechabaja, ;
	ent_turnoshabilit, ent_fecpas, transform(afiliado,'99999999999') as afiliado, nrovale, '' as sala ;
	,int((mfectur1-nvl(fechanac,mfectur1))/365) as edad,esp_descripcion ;
	from mwkphorario1 ;
	left join mwkpent on codent = ent_codent ;
	left join mwkpesp on codesp = esp_codesp ;
	left join mwkpmed on codmed = mwkpmed.id ;
	left join mwkppres on codprest = pre_codprest ;
	order by horatur, afiliado;
	into cursor mwkphorario

*   msql = "select * from mwkphorario order by fechatur, codmed,horatur into cursor mwkphorarios"

&& Busqueda en Ambulatorio DEMANDA

mret = sqlexec(mcon1, 'select tabambulatorio.*,reg_nombrepac,reg_telefonos,reg_nrohclinica,reg_numdocumento,afi_nroafiliado,'+;
	' afi_fechabaja,reg_nroregistrac,reg_fecnacimiento as fechanac'+;
	' from tabambulatorio'+;
	' join registracio on registracio.reg_nroregistrac = tabambulatorio.nroregistrac'+;
	' join afiliacion on afiliacion.registracio= registracio.reg_nroregistrac '+;
	' where demanda = 1 and codmed = ?midmedico and fechaate = ?mfectur1', 'mwkambulat')

If mret < 0
	Messagebox("EN CONSULTA MAESTRO AMBULATORIO",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Cancel
Endif

Select fechaate as fechatur, ;
	left(ttoc(fechahoraing,2),5) as hora, ;
	left(reg_nombrepac, 40) as reg_nombrepac, ;
	ent_descrient, pre_descriprest,space(10) as codreserva, ;
	nvl(protocolo,str(1000000-1000000)+' ') as val_nroprotocolo	,reg_telefonos, ;
	"                   " as fechaobserva, ;
	left(reg_nrohclinica, 10) as reg_nrohclinica, ;
	usuario, fechahoraing as fechatomado, ;
	afi_nroafiliado, reg_numdocumento, ;
	'DE'+space(98) as observa, ;
	nombre, fechahoraing as horatur, mwkambulat.id, int(codent) as codent, codmed, codmed AS codmedsoli, ;
	int(val('1')) as tipoturno, int(val('0')) as solicigia, esp_codesp as codesp, int(codprest) as codprest, ;
	int(dow(fechaate)) as diasem, int(val('1')) as confirmado,int(val('0')) as codserv, afi_fechabaja, ;
	' ' as ent_turnoshabilit, ent_fecpas, transform(reg_nroregistrac,'99999999999') AS afiliado, nrovale, '' as sala, ;
	int((fechaate-nvl(fechanac,fechaate))/365) as edad, esp_descripcion ;
	from mwkambulat ;
	join mwkmedico on mwkmedico.id = midmedico;
	left join mwkppres on mwkppres.pre_codprest = codprest ;
	left join mwkpent on mwkpent.ent_codent = mwkambulat.codent ;
	left join mwkpesp on codesp = esp_codesp  ;
	into cursor mwkphorariob

Select * from mwkphorario union select * from mwkphorariob into cursor mwkphorarios

msql = "select * from mwkphorarios order by fechatur,codmed,horatur into cursor mwkphorarios"

Use in select("mwkphorario1")
Use in select("mwkambulat")
Use in select("mwkphorariob")



