*
* FTP Farmacia PYXIS FTP ( Notifico Admision & Prescripción )
*

Use In Select("mwkconsu3P")
Select * From mwkconsu3	Where mwkconsu3.esta = 1 Into Cursor mwkconsu3P

mmsgv  = ''
Select mwkconsu3P
Go Top
Scan All
	If sp_busco_vale_pyxis(mwkconsu3P.val_codvaleasist)
		If Used("mwkvalePyxis")
			If Reccount("mwkvalePyxis") > 0
				mmsgv = mmsgv + Alltrim(Str(mwkconsu3P.val_codvaleasist)) + ' - '
			Endif
		Endif
	Endif
	Use In Select("mwkvalePyxis")
	Select mwkconsu3P
Endscan

If !Empty(mmsgv)
	If Messagebox(mmsgv + Chr(10) + "ESTAN NOTIFICADOS, PROCESA", 4+32+256, "VALES") = 7
		Return
	Endif
Endif

Set Procedure To prg_ftp.prg Additive

loFTP = Createobject('ftp_service')
loFTP.cStartupFolder = ""

If loFTP.OpenInternet("appeng", "b4uleave!2", "172.16.60.1", "21")

	merror = .F.
	mctos  = 0
	
	Select mwkconsu3P
	Go Top
	Scan All

		If At(Alltrim(mwkconsu3P.SECTORN), 'UC1 UC2 UC3 UC4 TI5') > 0

			mctos = mctos + 1

*!*    		Admision

			lcRemoteFile = "PYXIS"+chrtran(Transform(Seconds()),',.','')+".TXT"
			*"PYXIS"+Strtran(Transform(Seconds()),'.','')+".TXT"
			lcLocalFile  = "C:\TEMP\" + lcRemoteFile

			sp_pyxis_msgadm('ADMISION', 'TXT', 'ADMISION', Alltrim(mwkconsu3P.PAC_NOMBREPACIENTE), mwkconsu3P.VAL_CODADMISION, mwkconsu3P.NOMBRE, mwkconsu3P.SECTORN,;
				mwkconsu3P.HABITAN,mwkconsu3P.CAMAN, lcLocalFile)

			Wait Window "Cargando en PYXIS" Nowait

			If !loFTP.PutFTPFile(lcRemoteFile, lcLocalFile)

				mltabla = "FTP PYXIS"
				Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
				Messagebox("EN PROCESO " + mltabla + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
				Return .F.

			Else

*!*         	Prescripcion
				Select mwkconsu3P
				Go Top

				Scan All

					mvale  = Alltrim(Str(mwkconsu3P.val_codvaleasist))
					Do prg_cvalecnt With mvale
					nroitem = Reccount("mwkIteAsist")

					mNroOrden = 0 && Hardcodeo Nro Orden

					For mindi = 1 To nroitem

						mv1  = Transform(item_vale[mindi,2])       && Cantidad
						mv2  = item_vale[mindi,3]                  && Desc. Insumo
						mv1a = Int(Val(chrtran(mv1 , "*", "")))    && Cantidad sin agregados
*						Int(Val(Strtran(mv1 , "*", "")))    && Cantidad sin agregados
						mv3  = item_vale[mindi,1]                  && Codigo Insumo

						If sp_busco_en_pyxis(mv3) && Verifico que Exista en PYXIS

							mNroOrden = mNroOrden + 1
							mfech     = Ttoc(sp_busco_fecha_serv('DT'))
							mfech2    = Substr(mfech,4,2) + Left(mfech,2) + Substr(mfech,7,4) + Chrtran(Right(mfech,8), ':', '')
							mIniDis   = mfech2
							mInsumo   = mv3
							mNotaci   = 'ADMINISTRAR ' + mv2
							mdiasem   = Dow( sp_busco_fecha_serv('DD') ) && Hardcodeo

							lcRemoteFile = "PYXIS"+chrtran(Transform(Seconds()),',.','')+".TXT"
							*"PYXIS"+Strtran(Transform(Seconds()),'.','')+".TXT"
							
							lcLocalFile  = "C:\TEMP\" + lcRemoteFile

							sp_pyxis_msgadm('PRESCRIBE', 'TXT', 'INICIO', , mwkconsu3P.VAL_CODADMISION, mwkconsu3P.NOMBRE, , , , lcLocalFile, Transform(mNroOrden), mIniDis, mInsumo,;
								mNotaci, Transform(mv1a), mdiasem, '1' )

							If !loFTP.PutFTPFile(lcRemoteFile, lcLocalFile)
								mltabla = "FTP PYXIS UPLOAD DE ARCHIVO"
								Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
								Messagebox("EN PROCESO " + mltabla + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
								Return .F.
							Endif

&&                          Dar de ALTA

							sp_grabo_dispensa_pyxis(mwkconsu3P.val_codvaleasist, mInsumo, 'PREPARADOR')

						Endif

					Next mindi
				Endscan
			Endif
		Endif
	Endscan

	Messagebox("REGISTROS PROCESADOS : "+Alltrim(Str(mctos)),48,"PYXIS NOTIFICA")

Else

	mltabla = "FTP PYXIS"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN PROCESO " + mltabla + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.

Endif

=loFTP.CloseInternet()
Release Procedure prg\prg_ftp.prg Additive
Use In Select("mwkconsu3P")

Return .T.
