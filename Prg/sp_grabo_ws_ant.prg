*******************************
* Graba respusta de WebService
*****************************
parameters vbusco,vafi,vapeynom,vfechabaja,vnimdoc,vplan

wsafi = dat_fac(6)
wsapeynom =  dat_fac(5)
wscontrol = val(dat_fac(22))
wsestado = dat_fac(19)
vfecha	= sp_busco_fecha_serv("DT")
wsplan = dat_fac(7)
vfechabaja = iif(vfechabaja=ctod("  /  /  "),ctod("01/01/1900"),vfechabaja)
if !empty(wsafi)   &&existen datos
	mret=sqlexec(mcon1,'Insert into tabCtrlWS (RegAfiliado, RegApeyNom, RegFechaBaja, RegNroDocumento, '+;
		'RegPlan, WSAfiliado , WSApeyNom , WSControl, WSEstado, WSFechaHora, '+;
		'WSPlan,WSBusqueda,WSIp ) '+;
		'VALUES (?vafi, ?vapeynom, ?vfechabaja, ?vnimdoc, ?vplan, '+;
		'?wsafi,?wsapeynom,?wscontrol ,?wsestado ,?vfecha,?wsplan,?vbusco,?myip)')
else
	mret=sqlexec(mcon1,'Insert into tabCtrlWS (RegAfiliado, RegApeyNom, RegFechaBaja, RegNroDocumento, '+;
		'RegPlan, WSControl,WSFechaHora, WSBusqueda, WSIp ) '+;
		'VALUES (?vafi, ?vapeynom, ?vfechabaja, ?vnimdoc, ?wsplan, '+;
		'?wscontrol ,?vfecha,?vbusco,?myip)')
endif
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	messagebox('ERROR grabacion WS ',16,'VALIDACION')
	mret=0
endif
