****
**** Armo la Conexion a la base
****
lparameters miexe
*atsdfsdf
if used('mwkexe')
	miexe = alltrim(mwkexe.nomexe)
else
	miexe = alltrim(iif(type('miexe')#"C","Sistemas",miexe))
endif
mcon1= 0
nalerta = 0
lcStringConn = ''
do buscoini with upper(miexe)
*strtofile(lcStringConn,"c:\conec.txt")
if nalerta <=1
	mcon1= 0
	nreintenta = 1
	nloop = 1
	lsigue = 6
*	do while lsigue=6 and  mcon1<=0
	do while nreintenta < 4 and  mcon1<=0
		if !empty(lcStringConn)
			mcon1  = sqlstringconnect(lcStringConn)
		else
			mcon1= sqlconnect('Conec01','_system','sys')
		endif
*!*			if mcon1 < 0
*!*				mcon1= sqlconnect('Conec01','_system','sys')
*!*			endif
		if mcon1 < 0
			messagebox("Conexion :"+alltrim(lcStringConn)+" Nº de Reintento... "+transf(nloop) )
*			wait windows "Nº de Reintento... "+transf(nloop) nowait
			=aerr(eros)
			tiempo = seconds()
			if eros(1)#1526
				messagebox("Error "+ transf(eros(1))+" - "+ eros(3))
				do prg_cancelo
			else
				nloop = nloop +1
				nreintenta = nreintenta +1
			endif
			do buscoini with upper(miexe)
		endif
	enddo

	if mcon1 < 0
		messagebox("LA CONEXION ESTA OCUPADA. REINTENTE...", 16, "Validación")
		cancel
	else
		mret = sqlexec(mcon1,"select * from server","mwkserver1")
		if mret>0
			mClientName	= mwkserver1.ClientName
			mDevice		= mwkserver1.device
			mIPaddress	= mwkserver1.IPaddress
			mMemoria	= mwkserver1.Memoria
			mName 		= mwkserver1.name
			mProcessId	= mwkserver1.processid
			mClientName	= iif(empty(mClientName),left(sys(0),at("#",sys(0))-1),mClientName)
			mName 		= iif(empty(mName ),substr(sys(0),at("#",sys(0))+1),mName )
			modify windows screen ;
				title proper(miexe)+"      P.Id:" + mwkserver1.processid
			if used("mwkusuario")
				mcodvax	= mwkusuario.codigovax
			else
				mcodvax	= 0
			endif
			mfechas		= sp_busco_fecha_serv('DT')
			mprg 		= "sp_conexion"
			mret = sqlexec(mcon1,"insert into TabCtrlServer (TCS_ClientName,TCS_Device,TCS_Estado"+;
				",TCS_Fechah,TCS_IPaddress,TCS_Memoria,TCS_Name,TCS_ProcessId,TCS_Usuario,TCS_program)"+;
				" values  (?mClientName,?mDevice,0,?mfechas,?mIPaddress,?mMemoria,?mName"+;
				",?mProcessId, ?mcodvax,?mprg)")
			mret = sqlexec(mcon1,"select * from TabCtrlServer where TCS_ClientName = ?mClientName and "+;
				"TCS_IPaddress = ?mIPaddress and TCS_Fechah = ?mfechas and "+;
				"TCS_Name = ?mName and TCS_ProcessId = ?mProcessId and TCS_Usuario = ?mcodvax","mwkTCS")
			wait clear
			select 0

		endif
	endif
else
	cancel
endif

procedure buscoini
	lparameters mieje
	private liniserv
	zzvolumen = left(justpath(sys(16,0)),2)
	if file("X:\Qepd1a1\Exe\inicio\ini.txt")
		cldsk = "X:"+substr(justpath(sys(16,0)),3)
		liniserv = .t.
	else
		if file("H:\Qepd1a1\Exe\inicio\ini.txt")
			cldsk = "H:"+substr(justpath(sys(16,0)),3)
			liniserv = .t.
		else
			cldsk = alltrim(justpath(sys(16,0)))
			liniserv = .f.
		endif
	endif
	if inlist(myip,"172.16.1.7","172.16.1.9","172.16.1.10")
		cldsk = alltrim(justpath(sys(16,0)))
		liniserv = .f.
	endif

	on error =aerr(eros)
	mfile = cldsk + "\inicio\ini.txt"
	if at("EXE",mfile)=0
		mfile = "..\exe\inicio\ini.txt"
	endif
*messagebox(mfile)
	mcadcon = filetostr(mfile)
*messagebox(mcadcon )
	on error
	if type('mcadcon') = "C"
		nlineas = alines(mimatini,mcadcon)
		lEXE = ascan(mimatini,"["+ alltrim(mieje) +"]")
		lexeini = lEXE +1
		mServer 	= alltrim(mimatini(1+lEXE   ))
		mDatabase 	= alltrim(mimatini(2+lEXE))
		mPort 		= alltrim(mimatini(4+lEXE))
		lcStringConn="Driver={InterSystems ODBC};" + mPort + ;
			";" + mServer + ;
			";" + mDatabase + ;
			";Uid=" +;
			";Pwd="
*!*				";Uid=_system" +;
*!*				";Pwd=sys"

		loleserver = ascan(mimatini,"[OLESERVER]", lexeini)
		coleserver = iif(loleserver>0,mimatini(loleserver +1 ),"")

		lalerta = ascan(mimatini,"[ALERTA]", lexeini)
		nalerta = iif(lalerta >0,val(mimatini(lalerta +1 )),0)
		lmsg = ascan(mimatini,"[MSG]", lexeini)
		if liniserv
			lvolumen = ascan(mimatini,"[VOLUMEN]", lexeini)
			zzvolumen = iif(lvolumen >0 and lvolumen < lmsg ,alltrim(mimatini(lvolumen +1 )),"H:")
			zzvolumen = iif(left(zzvolumen,1) # ':', zzvolumen ="C:", zzvolumen )
		endif
		if nalerta >0
			cmsg = iif(lmsg > 0,mimatini( lmsg + 1 ),0)
			messagebox(cmsg, 16, "SISTEMAS")
		endif
		if nalerta <=1
			mNameSpaces = mimatini(3+lexe)
			mNameSpaces =alltrim(substr(mNameSpaces,at("=",mNameSpaces)+1))
			if !empty('mNameSpaces') and used('mwktabcfg')
				select mwktabcfg
				go top
				replace olespaces with mNameSpaces
				if !empty(coleserver)
					replace oleserver with coleserver
				endif
			endif
			lnoip = ascan(mimatini,"[NOIP]", lexeini)
			cnoip = iif(lnoip >0 and lnoip < lmsg,mimatini(lnoip +1 ),"")
			lnoip = lnoip +1
			do while left(alltrim(cnoip),9) # "[FINNOIP]" and !(cnoip $ myip) and !empty(cnoip)
				cnoip = iif(lnoip >0,mimatini(lnoip +1 ),"")
				lnoip = lnoip +1
			enddo
			if cnoip $ myip
				messagebox("USTED ESTA TEMPORARIAMENTE BLOQUEADO. DISCULPE", 16, "SISTEMAS")
				cancel
			endif
			lSIip = ascan(mimatini,"[SIIP]", lexeini)
			csiip = iif(lsiip >0 and lsiip < lmsg,mimatini(lsiip +1 ),"")
			lsiip = lsiip +1
			do while left(alltrim(csiip),9) # "[FINSIIP]" and !(csiip $ myip) and !empty(csiip)
				csiip = iif(lsiip >0,mimatini(lsiip +1 ),"")
				lsiip = lsiip +1
			enddo
			if csiip $ myip
				lEXE = ascan(mimatini,"[FINSIIP]", lexeini)
				lexeini = lEXE +1
				mServer 	= alltrim(mimatini(1+lEXE   ))
				mDatabase 	= alltrim(mimatini(2+lEXE))
				mPort 		= alltrim(mimatini(4+lEXE))
				lcStringConn="Driver={InterSystems ODBC};" + mPort + ;
					";" + mServer + ;
					";" + mDatabase + ;
			";Uid=" +;
			";Pwd="
*!*						";Uid=_system" +;
*!*						";Pwd=sys"

				loleserver = ascan(mimatini,"[OLESERVER]", lexeini)
				coleserver = iif(loleserver>0,mimatini(loleserver +1 ),"")

				lalerta = ascan(mimatini,"[ALERTA]", lexeini)
				nalerta = iif(lalerta >0,val(mimatini(lalerta +1 )),0)
				lmsg = ascan(mimatini,"[MSG]", lexeini)
				if liniserv
					lvolumen = ascan(mimatini,"[VOLUMEN]", lexeini)
					zzvolumen = iif(lvolumen >0 and lvolumen < lmsg ,alltrim(mimatini(lvolumen +1 )),"H:")
				endif

				if nalerta >0
					cmsg = iif(lmsg > 0,mimatini( lmsg + 1 ),0)
					messagebox(cmsg, 16, "SISTEMAS")
				endif
				if nalerta <=1
					mNameSpaces = mimatini(3+lexe)
					mNameSpaces =alltrim(substr(mNameSpaces,at("=",mNameSpaces)+1))
					if !empty('mNameSpaces') and used('mwktabcfg')
						select mwktabcfg
						go top
						replace olespaces with mNameSpaces
						if !empty(coleserver)
							replace oleserver with coleserver
						endif
					endif
				else
					cancel
				endif
			endif
		else
			cancel
		endif

		SQLSETPROP(0,"DispLogin",3)
	endif
