lparameters mprg
if type('mprg')#"C"
	mprg =""
endif
if used("mwkserver3")
	mClientName	= mwkserver3.ClientName
	mDevice		= mwkserver3.Device
	mIPaddress	= mwkserver3.IPaddress
	mMemoria	= mwkserver3.Memoria
	mName 		= mwkserver3.Name
	mProcessId	= mwkserver3.ProcessId
	mClientName	= iif(empty(mClientName),left(sys(0),at("#",sys(0))-1),mClientName)
	mName 		= iif(empty(mName ),substr(sys(0),at("#",sys(0))+1),mName )
	if used("mwkusuario")
		mcodvax	= mwkusuario.codigovax
	else
		mcodvax	= 0
	endif
	if used('MWKFecServ')
		mfechas		= MWKFecServ.fechaHora
	else
		mfechas		= datetime()
	endif

	mret = sqlexec(mcon1,"insert into TabCtrlServer (TCS_ClientName,TCS_Device,TCS_Estado"+;
		",TCS_Fechah,TCS_IPaddress,TCS_Memoria,TCS_Name,TCS_ProcessId,TCS_Usuario,TCS_program)"+;
		" values  (?mClientName,?mDevice,0,?mfechas,?mIPaddress,?mMemoria,?mName"+;
		",?mProcessId, ?mcodvax,?mprg)")
	use in mwkserver3
endif
on error =AERR(eros)
=sqldisconnect(mcon3)
on error

select 0
