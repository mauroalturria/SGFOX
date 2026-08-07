*
* Busco INI
*

Lparameters mieje
cpass = ";Uid=cacheapp;Pwd=KaxHe025"
*!*	IF DATE()=CTOD("15/05/2025")
*	cpass = ";Uid=_system;Pwd=sys"
*!*	endif
Private liniserv
*cpass = ";Uid=SGGENERAL;Pwd=sg2021"

*Set Step On

lleoini = .T.
If Used("mwkambitoini")
	If Reccount("mwkambitoini")>0
		lleoini = .F.
	Endif
Endif
zzvolumen = Left(Justpath(Sys(16,0)),2)
zzvolumen = Iif(Substr(zzvolumen, 2,1) <> ':', "C:", zzvolumen)
mServer = ''
If File("X:\Qepd1a1\Exe\inicio\ini.txt")
	cldsk = "X:"+Substr(Justpath(Sys(16,0)),3)
	liniserv = .T.
Else
	If File("H:\Qepd1a1\Exe\inicio\ini.txt")
		cldsk = "H:"+Substr(Justpath(Sys(16,0)),3)
		liniserv = .T.
	Else
		cldsk = Alltrim(Justpath(Sys(16,0)))
		liniserv = (Upper(mieje) = "SISTEMAS")
	Endif
Endif

If prg_ipsistemas()
	cldsk = Alltrim(Justpath(Sys(16,0)))
	liniserv = .F.
	lleoini = .T.
Endif

lcErrorAnt = On("ERROR")
On Error = Aerr(eros)
mfile = cldsk + "\inicio\ini.txt"
*Messagebox(mfile)
If At("EXE",Upper(mfile))=0
	mfile = "..\exe\inicio\ini.txt"
Endif
If lleoini
	mcadcon = Filetostr(mfile)
Else
	mcadcon = mwkambitoini.ini
* 	 MESSAGEBOX( "mwkambitoini" )
Endif

*  messageBOX( left(mcadcon,255) )
On Error &lcErrorAnt

If Type('mcadcon') = "C" And !Empty(mcadcon)
	nlineas = Alines(mimatini,mcadcon)
	If mieje <> "OTROAMBITO"
		For timmy = 1 To 9
			miservidor = "[SERVER"+Alltrim(Transform(timmy))+"]"
			mifinservidor = "[FINSERVER"+Alltrim(Transform(timmy))+"]"
			lSRV1 = Ascan(mimatini,miservidor)
			If lSRV1 >0
				lmsg = Ascan(mimatini,"[MSG]",lSRV1 )
				lfinsrv1 = Ascan(mimatini,mifinservidor )
				csiip = Iif(lSRV1  >0 And lSRV1 < lmsg,mimatini(lSRV1  +1 ),"")
				lgenerico = (Right(Alltrim(csiip ),1)=".")
				lSRV1  = lSRV1  +1
				Do While Left(Alltrim(csiip),9) # mifinservidor  ;
						and !(csiip $ myip) And !Empty(csiip)
					If lgenerico And csiip $ myip Or (lSRV1 = lmsg)
						Exit
					Endif

					csiip = Iif(lSRV1  >0,mimatini(lSRV1  +1 ),"")
					lgenerico = (Right(Alltrim(csiip ),1)=".")
					lSRV1  = lSRV1 +1
				Enddo
				If (csiip $ myip And lgenerico ) Or csiip = myip
					lEXE = Ascan(mimatini,mifinservidor , lSRV1 )
					lsrvini  = lEXE +1
					mServer 	= Alltrim(mimatini(1+lEXE   ))
					mDatabase 	= Alltrim(mimatini(2+lEXE))
					mPort 		= Alltrim(mimatini(4+lEXE))
					lcStringConn="Driver={InterSystems ODBC};" + mPort + ;
						";" + mServer + ;
						";" + mDatabase + ;
						cpass
*!*						";Uid=" +;
*!*						";Pwd="
*BOX( lcStringConn)

					loleserver = Ascan(mimatini,"[OLESERVER]", lsrvini  )
					coleserver = Iif(loleserver>0,mimatini(loleserver +1 ),"")
*	 	 messageBOX( lcStringConn)
					limagen = Ascan(mimatini,"[NOVERIMAGEN]", lsrvini  )
					lnoverimagen = Iif(limagen>0,Val(mimatini(limagen+1 )),0)

					lalerta = Ascan(mimatini,"[ALERTA]", lsrvini  )
					nalerta = Iif(lalerta >0,Val(mimatini(lalerta +1 )),0)
					lmsg = Ascan(mimatini,"[MSG]", lsrvini  )
					If liniserv
						lvolumen = Ascan(mimatini,"[VOLUMEN]", lsrvini  )
						zzvolumen = Iif(lvolumen >0 And lvolumen < lmsg ,Alltrim(mimatini(lvolumen +1 )),"H:")
					Endif

					If nalerta >0
						cmsg = Iif(lmsg > 0,mimatini( lmsg + 1 ),0)
						Messagebox(cmsg, 16, "SISTEMAS")
					Endif
					If nalerta <=1
						mNameSpaces = mimatini(3+lEXE)
						mNameSpaces =Alltrim(Substr(mNameSpaces,At("=",mNameSpaces)+1))
						If !Empty('mNameSpaces') And Used('mwktabcfg')
							Select mwktabcfg
							Go Top
							Replace olespaces With mNameSpaces
							If !Empty(coleserver)
								Replace OLEServer With coleserver
							Endif
							Return
						Endif
					Else
						Cancel
					Endif
				Endif

			Endif

			lSRV1 = Ascan(mimatini,miservidor )
			If lSRV1 >0
				lmsg = Ascan(mimatini,"[MSG]",lSRV1 )
				lfinsrv1 = Ascan(mimatini,mifinservidor )
				csiip = Iif(lSRV1  >0 And lSRV1 < lmsg,mimatini(lSRV1  +1 ),"")
				lgenerico = (Right(Alltrim(csiip ),1)=".")
				lSRV1  = lSRV1  +1
				Do While Left(Alltrim(csiip),9) # mifinservidor  ;
						and !(csiip $ myip) And !Empty(csiip)
					If lgenerico And csiip $ myip Or (lSRV1 = lmsg)
						Exit
					Endif

					csiip = Iif(lSRV1  >0,mimatini(lSRV1  +1 ),"")
					lgenerico = (Right(Alltrim(csiip ),1)=".")
					lSRV1  = lSRV1 +1
				Enddo
				If (csiip $ myip And lgenerico ) Or csiip = myip
					lEXE = Ascan(mimatini,mifinservidor , lSRV1 )
					lsrvini  = lEXE +1
					mServer 	= Alltrim(mimatini(1+lEXE   ))
					mDatabase 	= Alltrim(mimatini(2+lEXE))
					mPort 		= Alltrim(mimatini(4+lEXE))
					lcStringConn="Driver={InterSystems ODBC};" + mPort + ;
						";" + mServer + ;
						";" + mDatabase + ;
						cpass
*!*						";Uid=" +;
*!*						";Pwd="
*BOX( lcStringConn)

					loleserver = Ascan(mimatini,"[OLESERVER]", lsrvini  )
					coleserver = Iif(loleserver>0,mimatini(loleserver +1 ),"")
* 	 messageBOX( lcStringConn)
					limagen = Ascan(mimatini,"[NOVERIMAGEN]", lsrvini  )
					lnoverimagen = Iif(limagen>0,Val(mimatini(limagen+1 )),0)

					lalerta = Ascan(mimatini,"[ALERTA]", lsrvini  )
					nalerta = Iif(lalerta >0,Val(mimatini(lalerta +1 )),0)
					lmsg = Ascan(mimatini,"[MSG]", lsrvini  )
					If liniserv
						lvolumen = Ascan(mimatini,"[VOLUMEN]", lsrvini  )
						zzvolumen = Iif(lvolumen >0 And lvolumen < lmsg ,Alltrim(mimatini(lvolumen +1 )),"H:")
					Endif

					If nalerta >0
						cmsg = Iif(lmsg > 0,mimatini( lmsg + 1 ),0)
						Messagebox(cmsg, 16, "SISTEMAS")
					Endif
					If nalerta <=1
						mNameSpaces = mimatini(3+lEXE)
						mNameSpaces =Alltrim(Substr(mNameSpaces,At("=",mNameSpaces)+1))
						If !Empty('mNameSpaces') And Used('mwktabcfg')
							Select mwktabcfg
							Go Top
							Replace olespaces With mNameSpaces
							If !Empty(coleserver)
								Replace OLEServer With coleserver
							Endif
							Return
						Endif
					Else
						Cancel
					Endif
				Endif

			Endif

		Next timmy
	Endif
******************************************************
*Set Step On
	
	If Empty(mServer )
		lEXE = Ascan(mimatini,"["+ Alltrim(mieje) +"]")
		lnoexe = (lEXE = 0)
		lexeini = lEXE +1
		mServer 	= Alltrim(mimatini(1+lEXE   ))
		mDatabase 	= Alltrim(mimatini(2+lEXE))
		mPort 		= Alltrim(mimatini(4+lEXE))
		lcStringConn="Driver={InterSystems ODBC};" + mPort + ;
			";" + mServer + ;
			";" + mDatabase + ;
			cpass
*!*				";Uid=" +;
*!*				";Pwd="
		loleserver = Ascan(mimatini,"[OLESERVER]", lexeini)
		coleserver = Iif(loleserver>0,mimatini(loleserver +1 ),"")

		limagen = Ascan(mimatini,"[NOVERIMAGEN]", lexeini)
		lnoverimagen = Iif(limagen>0,Val(mimatini(limagen+1 )),0)

		lalerta = Ascan(mimatini,"[ALERTA]", lexeini)
		nalerta = Iif(lalerta >0,Val(mimatini(lalerta +1 )),0)
		lmsg    = Ascan(mimatini,"[MSG]", lexeini)

		If liniserv
			lvolumen  = Ascan(mimatini,"[VOLUMEN]", lexeini)
			zzvolumen = Iif(lvolumen >0 And lvolumen < lmsg ,Alltrim(mimatini(lvolumen +1 )),"H:")
			zzvolumen = Iif(Substr(zzvolumen, 2,1) <> ':', "C:", zzvolumen)
		Endif

		If nalerta >0
			cmsg = Iif(lmsg > 0,mimatini( lmsg + 1 ),0)
			Messagebox(cmsg, 16, "SISTEMAS")
		Endif
		lmiambito = Ascan(mimatini,"[AMBITO]", lexeini)
		cmiambito = Iif(lmiambito>0,mimatini(lmiambito+1 ),"1")
		mxambito = Val(cmiambito)
		mxambito = Iif(mxambito =0,1,mxambito )


		If nalerta <=1
			mNameSpaces = mimatini(3+lEXE)
			mNameSpaces =Alltrim(Substr(mNameSpaces,At("=",mNameSpaces)+1))
			If !Empty('mNameSpaces') And Used('mwktabcfg')
				Select mwktabcfg
				Go Top
				On Error &lcErrorAnt
				Replace olespaces With mNameSpaces
				If !Empty(coleserver)
					Replace OLEServer With coleserver
				Endif
			ENDIF
			 
			lnoip = Ascan(mimatini,"[NOIP]", lexeini)
			cnoip = Iif(lnoip >0 And lnoip < lmsg,mimatini(lnoip +1 ),"")
			lnoip = lnoip +1
			lgenerico = (Right(Alltrim(cnoip),1)=".")
			Do While Left(Alltrim(cnoip),9) # "[FINNOIP]" And ;
					!(cnoip = myip) And !Empty(cnoip)
				If lgenerico And cnoip $ myip
					Exit
				Endif
				cnoip = Iif(lnoip >0,mimatini(lnoip +1 ),"")
				lgenerico = (Right(Alltrim(cnoip),1)=".")
				lnoip = lnoip +1
			Enddo
			If (cnoip $ myip And lgenerico ) Or cnoip = myip
				Messagebox("USTED ESTA TEMPORARIAMENTE BLOQUEADO. DISCULPE", 16, "SISTEMAS")
				Cancel
			Endif
			lSIip = Ascan(mimatini,"[SIIP]", lexeini)
			csiip = Iif(lSIip >0 And lSIip < lmsg,mimatini(lSIip +1 ),"")
			lgenerico = (Right(Alltrim(csiip ),1)=".")
			lSIip = lSIip +1
			Do While Left(Alltrim(csiip),9) # "[FINSIIP]" ;
					and !(csiip $ myip) And !Empty(csiip)
				If lgenerico And csiip $ myip
					Exit
				Endif
				csiip = Iif(lSIip >0,mimatini(lSIip +1 ),"")
				lgenerico = (Right(Alltrim(csiip ),1)=".")
				lSIip = lSIip +1
			Enddo
			If (csiip $ myip And lgenerico ) Or csiip = myip
				lEXE = Ascan(mimatini,"[FINSIIP]", lexeini)
				lexeini = lEXE +1
				mServer 	= Alltrim(mimatini(1+lEXE   ))
				mDatabase 	= Alltrim(mimatini(2+lEXE))
				mPort 		= Alltrim(mimatini(4+lEXE))
				lcStringConn="Driver={InterSystems ODBC};" + mPort + ;
					";" + mServer + ;
					";" + mDatabase + ;
					cpass
*!*						";Uid=" +;
*!*						";Pwd="
*BOX( lcStringConn)

				loleserver = Ascan(mimatini,"[OLESERVER]", lexeini)
				coleserver = Iif(loleserver>0,mimatini(loleserver +1 ),"")

				limagen = Ascan(mimatini,"[NOVERIMAGEN]", lexeini)
				lnoverimagen = Iif(limagen>0,Val(mimatini(limagen+1 )),0)

				lalerta = Ascan(mimatini,"[ALERTA]", lexeini)
				nalerta = Iif(lalerta >0,Val(mimatini(lalerta +1 )),0)
				lmsg = Ascan(mimatini,"[MSG]", lexeini)
				If liniserv
					lvolumen = Ascan(mimatini,"[VOLUMEN]", lexeini)
					zzvolumen = Iif(lvolumen >0 And lvolumen < lmsg ,Alltrim(mimatini(lvolumen +1 )),"H:")
				Endif

				If nalerta >0
					cmsg = Iif(lmsg > 0,mimatini( lmsg + 1 ),0)
					Messagebox(cmsg, 16, "SISTEMAS")
				Endif
				If nalerta <=1
					mNameSpaces = mimatini(3+lEXE)
					mNameSpaces =Alltrim(Substr(mNameSpaces,At("=",mNameSpaces)+1))
					If !Empty('mNameSpaces') And Used('mwktabcfg')
						Select mwktabcfg
						Go Top
						Replace olespaces With mNameSpaces
						If !Empty(coleserver)
							Replace OLEServer With coleserver
						Endif
					Endif
				Else
					Cancel
				Endif
			Endif
		Else
			Cancel
		Endif
	Endif
* MESSAGEBOX( lcStringConn)
	SQLSetprop(0,"DispLogin",3)
Endif
