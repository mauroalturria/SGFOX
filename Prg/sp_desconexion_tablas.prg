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
	mfechas		= sp_busco_fecha_srv2('DT')
	mret = sqlexec(mcon1,"insert into TabCtrlServer (TCS_ClientName,TCS_Device,TCS_Estado"+;
		",TCS_Fechah,TCS_IPaddress,TCS_Memoria,TCS_Name,TCS_ProcessId,TCS_Usuario,TCS_program)"+;
		" values  (?mClientName,?mDevice,3,?mfechas,?mIPaddress,?mMemoria,?mName"+;
		",?mProcessId, ?mcodvax,?mprg)")
	use in mwkserver3
endif

=sqldisconnect(mcon1)