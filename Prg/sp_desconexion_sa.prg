lparameters mprg
if type('mprg')#"C"
	mprg =""
endif
if used("mwkserver2")
	mClientName	= mwkserver2.ClientName
	mDevice		= mwkserver2.Device
	mIPaddress	= mwkserver2.IPaddress
	mMemoria	= mwkserver2.Memoria
	mName 		= mwkserver2.Name
	mProcessId	= mwkserver2.ProcessId
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

	mret = sqlexec(mcon3,"insert into TabCtrlServer (TCS_ClientName,TCS_Device,TCS_Estado"+;
		",TCS_Fechah,TCS_IPaddress,TCS_Memoria,TCS_Name,TCS_ProcessId,TCS_Usuario,TCS_program)"+;
		" values  (?mClientName,?mDevice,0,?mfechas,?mIPaddress,?mMemoria,?mName"+;
		",?mProcessId, ?mcodvax,?mprg)")
	use in mwkserver2
Endif
lcErrorAnt = ON("ERROR")
on error =AERR(eros)
=sqldisconnect(mcon3)
On Error &lcErrorAnt
mcon3 = 0

select 0
