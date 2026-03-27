*******************************
* Graba respusta de WebService
*****************************
parameters vbusco,vafi,vapeynom,vfechabaja,vnimdoc,vplan

wsafi = dat_ws(6)
mwsapeynom =  dat_ws(5)
mwscontrol = dat_ws(22)
mwsestado = dat_ws(19)
vfecha	= sp_busco_fecha_serv("DT")
mwsplan = dat_ws(7)
mwsPMI = dat_ws(23)
mwsAntecedentes = dat_ws(24)
mipc = ALLTRIM(myip)+"-"+SYS(0)
vnimdoc = val(transf(vnimdoc))
vfechabaja = iif(vfechabaja=ctod("  /  /  "),ctod("01/01/1900"),vfechabaja)
if !empty(wsafi)   &&existen datos
	mret=sqlexec(mcon1,'Insert into tabCtrlWS (RegAfiliado, RegApeyNom, RegFechaBaja, RegNroDocumento, '+;
		'RegPlan, WSAfiliado , WSApeyNom , WSControlC, WSEstado, WSFechaHora, '+;
		'WSPlan,WSBusqueda,WSIp,WSPMI,WSAntecedentes  ) '+;
		'VALUES (?vafi, ?vapeynom, ?vfechabaja, ?vnimdoc, ?vplan, '+;
		'?wsafi,?mwsapeynom,?mwscontrol ,?mwsestado ,?vfecha,?mwsplan,?vbusco,?mipc,?mwsPMI ,?mwsAntecedentes )')
else
	mret=sqlexec(mcon1,'Insert into tabCtrlWS (RegAfiliado, RegApeyNom, RegFechaBaja, RegNroDocumento, '+;
		'RegPlan, WSControlC,WSFechaHora, WSBusqueda, WSIp,WSPMI,WSAntecedentes  ) '+;
		'VALUES (?vafi, ?vapeynom, ?vfechabaja, ?vnimdoc, ?mwsplan, '+;
		'?mwscontrol ,?vfecha,?vbusco,?mipc,?mwsPMI ,?mwsAntecedentes )')
endif
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	messagebox('ERROR grabacion WS ',16,'VALIDACION')
	mret=0
endif
