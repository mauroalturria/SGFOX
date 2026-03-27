*
* Manejador de Errores
*
Lparameters lnError, lcMsg, lcMsg1, lcProg, lnLinNro,lcerr

cDirLocal = "C:\Tempdoc\"
#Define       FIN_DE_ARCHIVO       2
#Define		  BYTES_MOVIDOS        0

Local cNameLog
Local gnErrFile
if vartype(lcerr)#"C"
	lcerr = ''
endif
If Used("mwkusuario")
	mUser = mwkusuario.idusuario
Else
	mUser = Sys(0)
Endif 	

cNameLog = "Error_" + Dtos(Date()) + ".Log"

If File(cDirLocal + cNameLog)
	gnErrFile = Fopen(cDirLocal + cNameLog,12)
Else
	gnErrFile = Fcreate(cDirLocal + cNameLog)
	=Fwrite(gnErrFile,"Errores del dia: " + Dtoc(Date()) + Chr(13) + Chr(10))
	=Fwrite(gnErrFile, "*-----------------------------------------------------------" + Chr(13) + Chr(10))
Endif

=Fseek (gnErrFile,BYTES_MOVIDOS,FIN_DE_ARCHIVO)

lcError = "Hora: " 	   + Time()		 + Chr(13) + Chr(10)+ ;
	"PROGRAMA: " + lcProg		 + Chr(13) + Chr(10) + ;
	"LINEA:    " + Str(lnLinNro) + Chr(13) + Chr(10) + ;
	"MENSAJE:  " + lcMsg 		 + Chr(13) + Chr(10) + ;
	"MENSAJE 1:" + lcMsg1		 + Chr(13) + Chr(10) + ;
	"ERROR:    " + Str(lnError)+ "-" + alltrim(lcerr) + Chr(13) + Chr(10)

=Fwrite(gnErrFile,	lcError)
*=Fwrite(gnErrFile,	mimensaje)

=Fseek (gnErrFile,BYTES_MOVIDOS,FIN_DE_ARCHIVO)
=Fwrite(gnErrFile, "*-----------------------------------------------------------" + Chr(13) + Chr(10))
=Fclose(gnErrFile)

*!* intento de hacer el insert del Ctrl

If Vartype(mcon1) = "N"
	If mcon1 > 0
		If Not Inlist(lnError,1466) && agregar errores de conexion

*!*				lcError = "Hs:" + Time() + "|" + "PRG:" + lcProg+ "|" + "Lin:" + Str(lnLinNro) + ;
*!*					+ "|" + "Msg:" + lcMsg+ "|" + "Msg1:" + lcMsg1+ "|" + "Err:" + Str(lnError)

			lcError = "Msg:" + lcMsg+ "|" + "Msg1:" + lcMsg1+ "|" + "Err:" + Str(lnError)

			lcOnError = On("ERROR")
			On Error *

			mversion = prg_version_exe()

			Do sp_insert_tabCtrlErr With lcError ,ALLTRIM(myip)+"-"+SYS(0), mUser, mwkexe.nomexe,;
				lnLinNro, lcProg, mversion

			On Error &lcOnError

		Endif

*!*     Manejo de loop errores
		mfh1  = sp_busco_fecha_serv('DT') - 120
		mfh2  = sp_busco_fecha_serv('DT')
		

		Use In Select("mwkerrves")
		mret = SQLExec(mcon1,"select * from TabCtrlErr"+;
			" where tc_linea = ?lnLinNro and tc_rutina = ?lcProg"+;
			" and tc_usuario = ?muser"+;
			" and tc_fecha >= ?mfh1 and tc_fecha <= ?mfh2","mwkerrves")
		If mret > 0
			If Used("mwkerrves")
				If Reccount("mwkerrves") > 5
					Cancel
				Endif
			Endif
		Else
			cancel
		Endif
		Use In Select("mwkerrves")
	Endif
Endif

&& EVALUAR QUE MOSTRAR EN EL ERROR
If Used("mwkusuario")
	if mwkusuario.sector="SISTEMAS"
		Messagebox("ERROR EN LA CONSULTA LOG",48, "VALIDACION")
		wait windows "ERROR EN CONSULTA VERIFICAR LOG GENERADO" TIMEOUT 2
	endif
endif
Return


