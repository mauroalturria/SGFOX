********************
* Claudia Antoniow
*********************************
* Fecha Actualizacion: 2/04/2003
*********************************
* actualizacion de stock
*********************************
Parameters arch_xml_cab, arch_xml_Det

*Set step on

vr_result_1 =''
vr_result_2 =''
vr_result_3 =''
vr_result_4 =''
vr_result_5 =''
vr_result_6 =''
vr_cod      ='0'

*DO &vr_path

*MESSAGEBOX("Inicio:"+TRANSFORM(CURSORGETPROP("Buffering", arch_xml_cab)))
*MESSAGEBOX("Sourcetype Inicio:"+TRANSFORM(CURSORGETPROP("SourceType", arch_xml_cab)))

*!*	Select &arch_xml_cab
*!*	Browse
*!*	Select &arch_xml_Det
*!*	Browse

Select * From &arch_xml_cab Into Cursor MwkPendientesCab
Select * From &arch_xml_Det ORDER By Art_id,REQ_TIPOCTE,Cnrd_Cantidad Into Cursor MwkPendientesDet

If Used('MwkPendientesCab') And Used('MwkPendientesDet')

	Do sp_busco_server_namespaces
	If mresul
		Return "-99999"
	Endif
	Select MwkPendientesCab
	Go Top
	Do While !Eof('MWKPendientesCab')
		Select *,sum(Cnrd_Cantidad) as cantidad From MwkPendientesDet;
			WHERE CNR_ID=?MwkPendientesCab.CNR_ID;
			group By Art_id,REQ_TIPOCTE;
			INTO Cursor MWKDetalle

		Select Count(CNR_ID) From MwkPendientesDet;
			WHERE CNR_ID=?MwkPendientesCab.CNR_ID ;
			GROUP By CNR_ID ;
			INTO Array cantDetalle

		vr_tc       = ALLTRIM(MwkPendientesCab.CT_TIPO)
		vr_nc       = Alltrim(Str(MwkPendientesCab.CNR_ID))
		vr_nc1      = MwkPendientesCab.CNR_ID
		vr_fc       = Alltrim(Dtoc(MwkPendientesCab.CNR_FECHA))
*		vr_rec      = ALLTRIM(STR(MWKPendientes.NR))
*		vr_sdep     =  "11"
		vr_sdep     =  Alltrim(Str(MwkPendientesCab.CNR_DEPOSITO))
		vr_stidep   =  "3"
		vr_ensa     =  "+"
		vr_consi    =  "0"
		vr_ope      = Iif(MwkPendientesCab.USR_ID_MUMPS=0,'99999' , Alltrim(Str(MwkPendientesCab.USR_ID_MUMPS )))  && Codigo de operador vax
		vr_nreg		= ALLTRIM(STR(cantDetalle(1),5,0))

*		MESSAGEBOX('DEPOSITO IGUAL :' + vr_sdep ,16,'DEPOSITO ENVIADO')

		vr_datos = vr_nc + vr_fc + vr_sdep + vr_ope
		If !Isnull(vr_datos)
			vr_result	= '"' + vr_tc    + Chr(9) +  vr_nc     + Chr(9) +  vr_fc   + Chr(9) +;
				vr_sdep  + Chr(9) +  vr_stidep + Chr(9) +  vr_ensa + Chr(9) +;
				vr_consi + Chr(9) +  vr_ope    + Chr(1)
		Else
			Messagebox('ALGUN DATO DEL CURSOR DE CABECERAS ESTÄ EN NULL',16,'ENVIADO DE NULOS')
		Endif

*		LOOP DETALLE
		Select MWKDetalle
		Go Top
		Do While !Eof('MWKDetalle')

			If vr_cod =  Alltrim(MWKDetalle.Art_id)
				If !(vr_prov = Alltrim(Str(MWKDetalle.Prv_id)))
					vr_result   =''
					vr_result_1 =''
					vr_result_2 =''
					vr_result_3 =''
					vr_result_4 =''
					vr_result_5 =''
					vr_result_6 =''
*					COMPROBANTE CON CODIGO DE ARTICULO REPETIDO con prov distinto
					vr_ok = '424'+ Chr(9)
					Exit

				Endif
			Endif
			vr_cod      = Alltrim(MWKDetalle.Art_id)
			vr_reqid	= MWKDetalle.Req_id
			vr_observ	= MWKDetalle.CT_OBSERV
			vr_tipo		= MWKDetalle.REQ_TIPOCTE

			Select Sum(cantidad) As cant From MWKDetalle;
				WHERE Art_id = ?vr_cod AND Req_id = ?vr_reqid;
				GROUP By Art_id ;
				INTO Array vr_cant_sum

			vr_cant	=  Alltrim(Str(vr_cant_sum))
			vr_prov =  Alltrim(Str(MWKDetalle.Prv_id))  && Codigo de Proveedor
			vr_req	=  Alltrim(Str(MWKDetalle.Req_id))	&& Requisición de Compras
			vr_req 	= Iif(IsNull(vr_req), '', vr_req)

			Select Orc_id  From MWKDetalle;
				WHERE Art_id = ?vr_cod ;
				GROUP By Orc_id;
				INTO Cursor MWKOrcDet

			If Used('MwkOrcDet')
				If Reccount('MWKOrcDet')= 1
					vr_np 	    =  Alltrim(Str(MWKOrcDet.Orc_id))
				Else
					vr_np 	    =  '99999999'
				Endif
				Select MWKOrcDet
				Use
			Endif

			Select Rpv_id  From MWKDetalle;
				WHERE Art_id = ?vr_cod ;
				GROUP By Rpv_id;
				INTO Cursor MWKRemDet

			If Used('MwkRemdet')
				If Reccount('MWKRemDet')= 1
					vr_rem      =  Alltrim(Str(MWKRemDet.Rpv_id))
				Else

					vr_rem      =  '999999999999'
				Endif
				Select MWKRemDet
				Use

			Endif

			Iif (Isnull(vr_cod + vr_cant + vr_prov + vr_np + vr_rem),;
				MESSAGEBOX('ALGUN DATO DEL CURSOR DE DETALLE ESTA EN NULL',16,'ENVIADO DE NULOS'),'')

			If Len(Alltrim(vr_result_1))= 0
				vr_result_1 =  vr_cod  + Chr(9) + vr_cant  + Chr(9) +;
					vr_prov + Chr(9) + vr_np    + Chr(9) + vr_rem + Chr(9) + vr_req + Chr(9) +ALLTRIM(vr_observ) + Chr(9) + vr_tipo

			Else
				vr_arti_sig =  vr_cod  + Chr(9)  + vr_cant  + Chr(9) +;
					vr_prov  + Chr(9) +	vr_np   + Chr(9) + vr_rem + Chr(9) + vr_req + Chr(9) + ALLTRIM(vr_observ)  + Chr(9) + vr_tipo

				If (Len(vr_result_1) + Len(vr_arti_sig)+ Len(vr_result))< 501 And Len(Alltrim(vr_result_2)) =0
					vr_result_1 = vr_result_1  + vr_arti_sig
				Else
					If (Len(vr_result_2) + Len(vr_arti_sig))< 501 And Len(Alltrim(vr_result_3)) =0
						If  Len(Alltrim(vr_result_2)) = 0
							vr_result_1	= vr_result_1
							vr_result_2 = vr_arti_sig
						Else
							vr_result_2 = vr_result_2  + vr_arti_sig
						Endif

					Else
						If (Len(vr_result_3) + Len(vr_arti_sig))< 501 And Len(Alltrim(vr_result_4)) =0
							If  Len(Alltrim(vr_result_3)) = 0
								vr_result_2	= vr_result_2
								vr_result_3 = vr_arti_sig
							Else
								vr_result_3 = vr_result_3  +  vr_arti_sig
							Endif
						Else
							If (Len(vr_result_4) + Len(vr_arti_sig))< 501 And Len(Alltrim(vr_result_5)) =0
								If  Len(Alltrim(vr_result_4)) = 0
									vr_result_3	= vr_result_3
									vr_result_4 = vr_arti_sig
								Else
									vr_result_4 = vr_result_4  +  vr_arti_sig
								Endif
							Else
								If (Len(vr_result_5) + Len(vr_arti_sig))< 501 And Len(Alltrim(vr_result_6)) =0
									If  Len(Alltrim(vr_result_5)) = 0
										vr_result_4	= vr_result_4
										vr_result_5 = vr_arti_sig
									Else
										vr_result_5 = vr_result_5  +  vr_arti_sig
									Endif
								Else
									If Len(Alltrim(vr_result_6)) =0
										vr_result_6 = vr_arti_sig
									Else
										vr_result_6 = vr_result_6  +  vr_arti_sig
									Endif
								Endif
							Endif

						Endif
					Endif
				Endif
			Endif

			Skip 1 In MWKDetalle
			If Eof()
				Exit
			Else

				If  Len(Alltrim(vr_result_2 + vr_result_3)) = 0
					vr_result_1	= vr_result_1  +  Chr(1)
				Else
					If  Len(Alltrim(vr_result_3 + vr_result_4)) = 0
						vr_result_2	= vr_result_2  +  Chr(1)
					Else
						If  Len(Alltrim(vr_result_4 + vr_result_5)) = 0
							vr_result_3	= vr_result_3  +  Chr(1)
						Else
							If  Len(Alltrim(vr_result_5 + vr_result_6)) = 0
								vr_result_4	= vr_result_4  +  Chr(1)
							Else
								If  Len(Alltrim(vr_result_6)) = 0
									vr_result_5	= vr_result_5  +  Chr(1)
								Else
									vr_result_6	= vr_result_6  +  Chr(1)
								Endif
							Endif
						Endif
					Endif

				Endif

			Endif

*ELSE
*vr_result   =''
*vr_result_1 =''
*vr_result_2 =''
*vr_result_3 =''
*vr_result_4 =''
*vr_result_5 =''
*vr_result_6 =''
* COMPROBANTE CON CODIGO DE ARTICULO REPETIDO
*vr_ok ='424'+ chr(9)
*EXIT
*ENDIF
*ENDIF

		Enddo

* 		FIN LOOP DETALLE

		If Len(Alltrim(vr_result)) > 0
		
			vr_result	= vr_result	+ vr_result_1 + '"'
			vr_2        = Iif(Len(Alltrim(vr_result_2))=0, "", '"' + vr_result_2 + '"')
			vr_3        = Iif(Len(Alltrim(vr_result_3))=0, "", '"' + vr_result_3 + '"')
			vr_4        = Iif(Len(Alltrim(vr_result_4))=0, "", '"' + vr_result_4 + '"')
			vr_5        = Iif(Len(Alltrim(vr_result_5))=0, "", '"' + vr_result_5 + '"')
			vr_6        = Iif(Len(Alltrim(vr_result_6))=0, "", '"' + vr_result_6 + '"')

			Do Form suministros_stock WITH "ZTRAN002"
			Release Windows
		Else
			vr_p2   ='Comprobante en blanco, no llamó a rutina de stock'
			vr_resp =''
		Endif

		vr_graba = sp_busco_fecha_serv('DT')

* 		devuelve cod de error

		If !(vr_ok=='')
* 			error por comprobante

			Select MwkPendientesCab

			Do prg_separo_datos_str With vr_ok,1,'C'

			If Num_error(1) >0

				mret=SQLEXEC(mcon3," Select textoerror from taberrores "+;
					" Where coderror = ?Num_error(1)","MwkTexto")
				If mret < 0
					vr_texto=''
				Else
					vr_texto=MwkTexto.textoerror
				Endif

				If Num_error(1)	<>428
*					MESSAGEBOX("Error no 428:"+TRANSFORM(CURSORGETPROP("Buffering", arch_xml_cab)))
*					MESSAGEBOX("Sourcetype Error no 428:"+TRANSFORM(CURSORGETPROP("SourceType", arch_xml_cab)))
					Update &arch_xml_cab Set cnr_stkerror = Num_error(1), ;
						cnr_stkstamp = vr_graba, ;
						cnr_stkerrds = vr_texto ;
						where CNR_ID = vr_nc1
				Else
					Messagebox('Error de conexión ',64,'Comunicación Invalida')
					Exit

				Endif

				Select MwkTexto
				Use
			Endif

		Else
*			Actualización exitosa

			If vr_p2 = '1'

*				MESSAGEBOX('El valor de p2 es: ' + vr_p2 ,64,'Valor P2')
*				MESSAGEBOX("valor = 1:"+TRANSFORM(CURSORGETPROP("Buffering", arch_xml_cab)))
*				MESSAGEBOX("Sourcetype valor = 1:"+TRANSFORM(CURSORGETPROP("SourceType", arch_xml_cab)))

				Update &arch_xml_cab  Set cnr_stkstamp = vr_graba,;
					cnr_transtk  = 'S';
					where CNR_ID = vr_nc1


*				UPDATE &arch_xml_cab  set   cnr_stkstamp = vr_graba;
* 						 	where cnr_id = vr_nc1
			Else
*				MESSAGEBOX("valor # 1:"+TRANSFORM(CURSORGETPROP("Buffering", arch_xml_cab)))
*				MESSAGEBOX("Sourcetype valor # 1:"+TRANSFORM(CURSORGETPROP("SourceType", arch_xml_cab)))

				Update &arch_xml_cab  Set   cnr_stkstamp = vr_graba;
					where CNR_ID = vr_nc1
			Endif

		Endif


		If !(vr_resp=='')
* 			error por codigo

			Do prg_separo_datos_str With vr_resp, cantDetalle(1), 'D'

			For i=1 To cantDetalle(1)

				If Num_error(i)>0

					mret=SQLEXEC(mcon3,"Select textoerror from taberrores "+;
						"Where coderror=?Num_error(i)","MwkTexto")
					If mret < 0
						vr_texto=''
					Else
						vr_texto=MwkTexto.textoerror
					Endif

					Update &arch_xml_Det Set cnrd_stkerror = Num_error(i), ;
						cnrd_stkstamp = vr_graba, ;
						cnrd_stkerrds = vr_texto  ;
						WHERE CNR_ID = vr_nc1 ;
						AND Art_id = cod_error(i)

					Select MwkTexto
					Use
				Endif
			Endfor

		Else
			Update &arch_xml_Det Set cnrd_stkstamp = vr_graba Where CNR_ID = vr_nc1
		Endif

		Select MwkPendientesCab
		Locate For CNR_ID = vr_nc1

		If Eof('MWKPendientesCab')

			=SQLDISCONNECT(mcon3)

		Else
			vr_result   =''
			vr_result_1 =''
			vr_result_2 =''
			vr_result_3 =''
			vr_result_4 =''
			vr_result_5 =''
			vr_result_6 =''
			vr_nc       =''
			vr_nc1      =0
			vr_fc       =Ctod('01/01/1900')
			vr_ope      =''
			vr_cod      =''
			vr_cant     =''
			vr_prov     ='' && Codigo de Proveedor
			vr_np 	    =''
			vr_rem      =''
			vr_req		=''
			vr_observ	=''
			vr_tipo		= ''
			Skip 1 In MwkPendientesCab
		Endif
	Enddo

*	CURSORTOXML('MwkPendientesCab','arch_xml_Cab',1,2)
*	CURSORTOXML('MwkPendientesDet','arch_xml_Det',1,2)

	Select MwkPendientesCab
	Use

	Select MwkPendientesDet
	Use

	Select MWKDetalle
	Use

	Select Mwkfecserv
	Use
Else
	Messagebox('ERROR: Comprobante vacio ',64,'ALTA STOCK ')
Endif

On ERROR = AERROR(eros)
= SQLDISCONNECT(mcon3)
On ERROR

Return







