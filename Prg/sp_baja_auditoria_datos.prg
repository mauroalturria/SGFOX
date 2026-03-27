*
* Pasiva datos, Auditoria: 1=documento, 2=telefono
*
lparameters mtipo,mtipodocb,mndocub,mtipodoc,mndocu,mregistracio,mform

if vartype(mtipo)<> "N"
	mtipo = 0
endif

if used("mwkdatreg")
	use in mwkdatreg
endif
mret = sqlexec(mcon1,"select * from REGISTRACIO where REG_nroregistrac = ?mregistracio","mwkdatreg")

if mret > 0

	do case
		case mtipo = 1  && documento
			select mwkdatreg
			go top

			mnudoc = mwkdatreg.REG_numdocumento
			mfpasi = sp_busco_fecha_serv("DD")
			mfnull = ctod("01/01/1900")

			mret = sqlexec(mcon1,"update TabRegDocu set TRD_FechaPasiva=?mfpasi"+;
				" where TRD_registracio=?mregistracio"+;
				" and TRD_NroDoc=?mndocub and TRD_TipoDoc=?mtipodocb")

			if mret > 0
*If mnudoc = mndocu
				if used("mwkdatdoc")
					use in mwkdatdoc
				endif
				mret = sqlexec(mcon1,"select * from TabRegDocu"+;
					" where TRD_registracio=?mregistracio "+;
					" and TRD_FechaPasiva=?mfnull"+;
					" order by TRD_FechaActiva","mwkdatdoc")
				if mret > 0
					if used("mwkdatdoc")
						if reccount("mwkdatdoc")>0
							select mwkdatdoc
							go bottom
							mndoc2 = mwkdatdoc.TRD_NroDoc
							mtdoc2 = mwkdatdoc.TRD_TipoDoc
							mret = sqlexec(mcon1,"update REGISTRACIO set REG_numdocumento=?mndoc2,"+;
								"REG_tipodocumento=?mtdoc2 where REG_nroregistrac=?mregistracio")
							if mret > 0
								mform.txtnrodoc.value = mndoc2
								mform.cbodocu.value   = mtdoc2
							endif
						else
							mform.txtnrodoc.value = 0
						endif
						mform.txtnrodoc.setfocus()
					endif
				endif
*Endif
			endif
			if mret < 0
				=aerror(merror)
				messagebox("EN AUDITORIA, PASIVA DATOS"+chr(10)+merror(3)+;
					chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			endif


		case mtipo = 2 && telefono
			select mwkdatreg
			go top
			mnudoc = mwkdatreg.REG_telefonos
			mfpasi = sp_busco_fecha_serv("DD")
			mfnull = ctod("01/01/1900")
			mret = sqlexec(mcon1,"update TabRegTel set TRT_Pasiva=?mfpasi"+;
				" where TRT_registracio=?mregistracio"+;
				" and TRT_Numero=?mndocu")
			if mret > 0
*If mnudoc = mndocu
				if used("mwkdatdoc")
					use in mwkdatdoc
				endif
				mret = sqlexec(mcon1,"select * from TabRegTel"+;
					" where TRT_registracio=?mregistracio "+;
					" and TRT_Pasiva=?mfnull","mwkdatdoc")
				if mret > 0
					if used("mwkdatdoc")
						select * from mwkdatdoc where len(alltrim(TRT_Numero))>0 into cursor mwkdatdoc
						if reccount("mwkdatdoc")>0
							select mwkdatdoc
							go bottom
							mndoc2 = left(alltrim(mwkdatdoc.TRT_Numero),20)
							mret = sqlexec(mcon1,"update REGISTRACIO set REG_telefonos=?mndoc2"+;
								" where REG_nroregistrac=?mregistracio")
							if mret > 0
								mform.txttel.value = mndoc2
							endif
						else

							mret = sqlexec(mcon1,"update REGISTRACIO set REG_telefonos=''"+;
								" where REG_nroregistrac=?mregistracio")
							if mret > 0
								mform.txttel.value = ''
							endif

						endif
						mform.txttel.setfocus()
					endif
				endif
*Endif
			endif
			if mret < 0
				=aerror(merror)
				messagebox("EN AUDITORIA PASIVA DATOS"+chr(10)+merror(3)+;
					chr(10)+"AVISE A SISTEMAS",16,"ERROR")
			endif

	endcase
else
	messagebox("EN CONSULTA DATOS DE REGISTRO"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	return
endif

