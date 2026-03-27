****
**** Armo la Conexion a la base de Shadow
****
lparameters miexe
zzvolumen = "H:"
if used('mwkexe')
	miexe = alltrim(mwkexe.nomexe)
else
	miexe = alltrim(iif(type('miexe')#"C","Sistemas",miexe))
endif
release mcon1s
public mcon1s
mcon1s= 0
nalerta = 0
lcStringConn = ''
do buscoinishdw 
*strtofile(lcStringConn,"c:\conec.txt")
if nalerta <=1
	mcon1s= 0
	nreintenta = 1
	nloop = 1
	lsigue = 6
	if !empty(lcStringConn)
		mcon1s  = sqlstringconnect(lcStringConn)
	else
		mcon1s= sqlconnect('Conec02','_system','sys')
	endif
	if mcon1s < 0
		messagebox("CONEXION SHADOW OCUPADA. REINTENTA...", 16, "Validación")
	else
		mret = sqlexec(mcon1s,"select * from server","mwkserver1S")
		if mret>0 and Used("mwkserver1s")
			mClientName	= mwkserver1s.ClientName
			mDevice		= mwkserver1s.device
			mIPaddress	= mwkserver1s.IPaddress
			mMemoria	= mwkserver1s.Memoria
			mName 		= mwkserver1s.name
			mProcessId	= mwkserver1s.processid
			mClientName	= iif(empty(mClientName),left(sys(0),at("#",sys(0))-1),mClientName)
			mName 		= iif(empty(mName ),substr(sys(0),at("#",sys(0))+1),mName )
			modify windows screen ;
				title proper(miexe)+"      P.Id:" + mwkserver1s.processid
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

procedure buscoinishdw
	mieje="SHADOW"
	lcErrorAnt = ON("ERROR")
	on error =aerr(eros)
	mfile = justpath(sys(16,0))+"\inicio\ini.txt"
	if at("EXE",mfile)=0
		mfile = "..\exe\inicio\ini.txt"
	endif
*messagebox(mfile)
	mcadcon = filetostr(mfile)
*messagebox(mcadcon )
	On Error &lcErrorAnt
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
			";Uid=_system" +;
			";Pwd=sys"

		loleserver = ascan(mimatini,"[OLESERVER]", lexeini)
		coleserver = iif(loleserver>0,mimatini(loleserver +1 ),"")

		lalerta = ascan(mimatini,"[ALERTA]", lexeini)
		nalerta = iif(lalerta >0,val(mimatini(lalerta +1 )),0)
		lmsg = ascan(mimatini,"[MSG]", lexeini)
		lvolumen = ascan(mimatini,"[VOLUMEN]", lexeini)
		zzvolumen = iif(lvolumen >0 and lvolumen < lmsg ,alltrim(mimatini(lvolumen +1 )),"H:")
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
					";Uid=_system" +;
					";Pwd=sys"

				loleserver = ascan(mimatini,"[OLESERVER]", lexeini)
				coleserver = iif(loleserver>0,mimatini(loleserver +1 ),"")

				lalerta = ascan(mimatini,"[ALERTA]", lexeini)
				nalerta = iif(lalerta >0,val(mimatini(lalerta +1 )),0)
				lmsg = ascan(mimatini,"[MSG]", lexeini)
				lvolumen = ascan(mimatini,"[VOLUMEN]", lexeini)
				zzvolumen = iif(lvolumen >0 and lvolumen < lmsg ,alltrim(mimatini(lvolumen +1 )),"H:")
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
