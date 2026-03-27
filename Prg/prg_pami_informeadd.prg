Lparameters nrovale

mVale = nrovale
mhayarchivoad = ''

mret = SQLExec(mcon1, " select * from informes where nrovale = ?mvale  AND EstadoInforme < 5 and " + ;
	"TipoArch not in " + prg_ext_sonido(2) + "","mwkValePrest")

** Llevara la cuenta de los informes por vale.

mCuenta = 0

Select mwkValePrest
miext 	= mwkValePrest.TipoArch
Count For InformePDFGenerado = .T.  To cuantoshay
If cuantoshay > 0

	If !Directory("C:\temp\informes")
		Mkdir "C:\temp\informes"
	Endif
	Select mwkValePrest
	mid = 0
	nsigo = 6
	Scan
		If mwkValePrest.EstadoInforme >3
			Messagebox("El Servicio no autorizó aún la visualización de alguno de los informes ",48,"Control Informes")
		Else
**If mid>0
**	nsigo = Messagebox("continua la visualizacion?", 4+32+256,"Validacion")
**Endif
			mid = mwkValePrest.Id
			If nsigo = 6
				mCuenta = mCuenta + 1

				Use In Selec('misdocus')
				Create Cursor misdocus (Info M)
				miext 	= "PDF"
				mid		= mwkValePrest.Id
				Wait Windows Nowait "Cargando Documentación..."
				If Used('datos')
					Use In datos
				Endif
				If Used('info_consu')
					Use In info_consu
				Endif
				Select informePDF From mwkValePrest Where Id=mid Into Cursor datos

				If File("C:\temp\informes\info_consu.dbf")
					Erase ("C:\temp\informes\info_consu.dbf")
				Endif
				If File("C:\temp\informes\info_consu.fpt")
					Erase ("C:\temp\informes\info_consu.fpt")
				Endif
				Select datos
				Copy To "C:\temp\informes\info_consu"
				Use In datos
				LL = Fopen("C:\temp\informes\info_consu.dbf",12)
				Fseek(LL,43)
				Fwrite(LL,'M')
				Fclose(LL)
				Use In 0 "C:\temp\informes\info_consu.dbf" Alias datos
				miresp = ''

				cNombreArch = 'C:\TEMPDOC\VALPRINT\'+Alltrim(Str(mVale))+"_INFADJ"+Alltrim(Str(mCuenta))

				Do prg_saveBin With datos.informePDF,cNombreArch+"."+miext,miresp,miext

				cNombreArch = cNombreArch + '.' + miext
			
* --------------------
* Verifico el archivo
* --------------------

				mestado = 0
				If File(cNombreArch)
					Adir(lcarch,cNombreArch)
					If lcarch(2) > 6361
						mestado = 3 && 'OK'
					Else
						mestado = 2 && 'PENDIENTE'
					Endif
				Else
					mestado = 1 && ' NO DISPONIBLE'
				Endif

				mhayarchivoad = ''
				If File(cNombreArch)
				mhayarchivoad = cNombreArch
				Endif

			Else
				Go Bottom
			Endif
		Endif
	Endscan
Endif

Return mhayarchivoad