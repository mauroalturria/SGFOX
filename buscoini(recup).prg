*
* Busco INI
*

lparameters mieje

private liniserv
lleoini = .t.
if used("mwkambitoini")
    if reccount("mwkambitoini")>0
        lleoini = .f.
    endif
endif
zzvolumen = left(justpath(sys(16,0)),2)
zzvolumen = iif(substr(zzvolumen, 2,1) <> ':', "C:", zzvolumen)

if file("X:\Qepd1a1\Exe\inicio\ini.txt")
    cldsk = "X:"+substr(justpath(sys(16,0)),3)
    liniserv = .t.
else
    if file("H:\Qepd1a1\Exe\inicio\ini.txt")
        cldsk = "H:"+substr(justpath(sys(16,0)),3)
        liniserv = .t.
    else
        cldsk = alltrim(justpath(sys(16,0)))
        liniserv = (upper(mieje) = "SISTEMAS")
    endif
endif

if prg_ipsistemas()
    cldsk = alltrim(justpath(sys(16,0)))
    liniserv = .f.
endif

lcErrorAnt = on("ERROR")
on error = aerr(eros)
mfile = cldsk + "\inicio\ini.txt"
*MESSAGEBOX(mfile)
if at("EXE",upper(mfile))=0
    mfile = "..\exe\inicio\ini.txt"
endif
if lleoini
    mcadcon = filetostr(mfile)
*	MESSAGEBOX( "mcadcon" )
else
    mcadcon = mwkambitoini.ini
*	MESSAGEBOX( "mwkambitoini" )
endif
*MESSAGEBOX( left(mcadcon,255) )
on error &lcErrorAnt

if type('mcadcon') = "C" and !empty(mcadcon)
    nlineas = alines(mimatini,mcadcon)
    lSRV1 = ascan(mimatini,"[SERVER1]")
	if lSRV1 >0
	    lmsg = ascan(mimatini,"[MSG]",lSRV1 )
	    lfinsrv1 = ascan(mimatini,"[FINSERVER1]")
	    csiip = iif(lSRV1  >0 and lSRV1 < lmsg,mimatini(lSRV1  +1 ),"")
	    lgenerico = (right(alltrim(csiip ),1)=".")
	    lSrv1  = lSrv1  +1
	    do while left(alltrim(csiip),9) # "[FINSERVER1]" ;
	            and !(csiip $ myip) and !empty(csiip)
	        if lgenerico and csiip $ myip OR (lSrv1 = lmsg)
	            exit
	        endif
	        
	        csiip = iif(lSrv1  >0,mimatini(lSrv1  +1 ),"")
	        lgenerico = (right(alltrim(csiip ),1)=".")
	        lSrv1  = lSrv1 +1
	    enddo
	    if (csiip $ myip and lgenerico ) or csiip = myip
	        lEXE = ascan(mimatini,"[FINSERVER1]", lSRV1 )
	        lsrvini  = lEXE +1
	        mServer 	= alltrim(mimatini(1+lEXE   ))
	        mDatabase 	= alltrim(mimatini(2+lEXE))
	        mPort 		= alltrim(mimatini(4+lEXE))
	        lcStringConn="Driver={InterSystems ODBC};" + mPort + ;
	            ";" + mServer + ;
	            ";" + mDatabase + ;
	            ";Uid=_SYSTEM" +;
	            ";Pwd=SYS"
	*!*						";Uid=" +;
	*!*						";Pwd="
	*BOX( lcStringConn)

	        loleserver = ascan(mimatini,"[OLESERVER]", lsrvini  )
	        coleserver = iif(loleserver>0,mimatini(loleserver +1 ),"")
*	MESSAGEBOX( lcStringConn)
	        limagen = ascan(mimatini,"[NOVERIMAGEN]", lsrvini  )
	        lnoverimagen = iif(limagen>0,val(mimatini(limagen+1 )),0)

	        lalerta = ascan(mimatini,"[ALERTA]", lsrvini  )
	        nalerta = iif(lalerta >0,val(mimatini(lalerta +1 )),0)
	        lmsg = ascan(mimatini,"[MSG]", lsrvini  )
	        if liniserv
	            lvolumen = ascan(mimatini,"[VOLUMEN]", lsrvini  )
	            zzvolumen = iif(lvolumen >0 and lvolumen < lmsg ,alltrim(mimatini(lvolumen +1 )),"H:")
	        endif

	        if nalerta >0
	            cmsg = iif(lmsg > 0,mimatini( lmsg + 1 ),0)
	            messagebox(cmsg, 16, "SISTEMAS")
	        endif
	        if nalerta <=1
	            mNameSpaces = mimatini(3+lEXE)
	            mNameSpaces =alltrim(substr(mNameSpaces,at("=",mNameSpaces)+1))
	            if !empty('mNameSpaces') and used('mwktabcfg')
	                select mwktabcfg
	                go top
	                replace olespaces with mNameSpaces
	                if !empty(coleserver)
	                    replace oleserver with coleserver
	                endif
	                return
	            endif
	        else
	            cancel
	        endif
	    endif

	endif


******************************************************

    lEXE = ascan(mimatini,"["+ alltrim(mieje) +"]")
    lnoexe = (lEXE = 0)
    lexeini = lEXE +1
    mServer 	= alltrim(mimatini(1+lEXE   ))
    mDatabase 	= alltrim(mimatini(2+lEXE))
    mPort 		= alltrim(mimatini(4+lEXE))
    lcStringConn="Driver={InterSystems ODBC};" + mPort + ;
        ";" + mServer + ;
        ";" + mDatabase + ;
        ";Uid=_SYSTEM" +;
        ";Pwd=SYS"

*!*				";Uid=" +;
*!*				";Pwd="
*MESSAGEBOX( lcStringConn)

    loleserver = ascan(mimatini,"[OLESERVER]", lexeini)
    coleserver = iif(loleserver>0,mimatini(loleserver +1 ),"")

    limagen = ascan(mimatini,"[NOVERIMAGEN]", lexeini)
    lnoverimagen = iif(limagen>0,val(mimatini(limagen+1 )),0)

    lalerta = ascan(mimatini,"[ALERTA]", lexeini)
    nalerta = iif(lalerta >0,val(mimatini(lalerta +1 )),0)
    lmsg    = ascan(mimatini,"[MSG]", lexeini)

    if liniserv
        lvolumen  = ascan(mimatini,"[VOLUMEN]", lexeini)
        zzvolumen = iif(lvolumen >0 and lvolumen < lmsg ,alltrim(mimatini(lvolumen +1 )),"H:")
        zzvolumen = iif(substr(zzvolumen, 2,1) <> ':', "C:", zzvolumen)
    endif

    if nalerta >0
        cmsg = iif(lmsg > 0,mimatini( lmsg + 1 ),0)
        messagebox(cmsg, 16, "SISTEMAS")
    endif
    lmiambito = ascan(mimatini,"[AMBITO]", lexeini)
    cmiambito = iif(lmiambito>0,mimatini(lmiambito+1 ),"1")
    mxambito = val(cmiambito)


    if nalerta <=1
        mNameSpaces = mimatini(3+lEXE)
        mNameSpaces =alltrim(substr(mNameSpaces,at("=",mNameSpaces)+1))
        if !empty('mNameSpaces') and used('mwktabcfg')
            select mwktabcfg
            go top
            on error &lcErrorAnt
            replace olespaces with mNameSpaces
            if !empty(coleserver)
                replace oleserver with coleserver
            endif
        endif
        lnoip = ascan(mimatini,"[NOIP]", lexeini)
        cnoip = iif(lnoip >0 and lnoip < lmsg,mimatini(lnoip +1 ),"")
        lnoip = lnoip +1
        lgenerico = (right(alltrim(cnoip),1)=".")
        do while left(alltrim(cnoip),9) # "[FINNOIP]" and ;
                !(cnoip = myip) and !empty(cnoip)
            if lgenerico and cnoip $ myip
                exit
            endif
            cnoip = iif(lnoip >0,mimatini(lnoip +1 ),"")
            lgenerico = (right(alltrim(cnoip),1)=".")
            lnoip = lnoip +1
        enddo
        if (cnoip $ myip and lgenerico ) or cnoip = myip
            messagebox("USTED ESTA TEMPORARIAMENTE BLOQUEADO. DISCULPE", 16, "SISTEMAS")
            cancel
        endif
        lSIip = ascan(mimatini,"[SIIP]", lexeini)
        csiip = iif(lSIip >0 and lSIip < lmsg,mimatini(lSIip +1 ),"")
        lgenerico = (right(alltrim(csiip ),1)=".")
        lSIip = lSIip +1
        do while left(alltrim(csiip),9) # "[FINSIIP]" ;
                and !(csiip $ myip) and !empty(csiip)
            if lgenerico and csiip $ myip
                exit
            endif
            csiip = iif(lSIip >0,mimatini(lSIip +1 ),"")
            lgenerico = (right(alltrim(csiip ),1)=".")
            lSIip = lSIip +1
        enddo
        if (csiip $ myip and lgenerico ) or csiip = myip
            lEXE = ascan(mimatini,"[FINSIIP]", lexeini)
            lexeini = lEXE +1
            mServer 	= alltrim(mimatini(1+lEXE   ))
            mDatabase 	= alltrim(mimatini(2+lEXE))
            mPort 		= alltrim(mimatini(4+lEXE))
            lcStringConn="Driver={InterSystems ODBC};" + mPort + ;
                ";" + mServer + ;
                ";" + mDatabase + ;
                ";Uid=_SYSTEM" +;
                ";Pwd=SYS"
*!*						";Uid=" +;
*!*						";Pwd="
*BOX( lcStringConn)

            loleserver = ascan(mimatini,"[OLESERVER]", lexeini)
            coleserver = iif(loleserver>0,mimatini(loleserver +1 ),"")

            limagen = ascan(mimatini,"[NOVERIMAGEN]", lexeini)
            lnoverimagen = iif(limagen>0,val(mimatini(limagen+1 )),0)

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
                mNameSpaces = mimatini(3+lEXE)
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
