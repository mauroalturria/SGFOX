lparameters mprg
if type('mprg')#"C"
	mprg =""
endif
mprg = alltrim(mprg) +"-1"
if used("mwkserver1")
	mClientName	= mwkserver1.ClientName
	mDevice		= mwkserver1.Device
	mIPaddress	= mwkserver1.IPaddress
	mMemoria	= mwkserver1.Memoria
	mName 		= mwkserver1.Name
	mProcessId	= mwkserver1.ProcessId
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
	use in mwkserver1
Endif
lcErrorAnt = ON("ERROR")
on error =AERR(eros)
=sqldisconnect(mcon1)
On Error &lcErrorAnt
mcon1 = 0

select 0
