*** Control numero de afiliado
parameters mcuit,codigoent,mresp,mensaje
if vartype(mensaje)#"N"
	mensaje = 0
endif
if len(alltrim(chrtran(mcuit ," -/","")))>0
	do case
		Case Inlist( codigoent,704,876 ) && Pami
			if len(alltrim(chrtran(mcuit ," -/","")))#14
				messagebox("EL NRO DE AFILIADO de PAMI NO ES CORRECTO "+chr(13)+"Ingrese los 12 números del beneficio y los 2 del GP",16,"Validacion")
			endif
		Case Inlist( codigoent,193) && Femedica
			if len(alltrim(chrtran(mcuit ," -/",""))) # 13
				messagebox("EL NRO DE AFILIADO de FEMEDICA NO ES CORRECTO "+;
				chr(13)+"debe tener este formato 99-99999999/99-9",16,"Validacion")

			endif
*!*			Case Inlist( codigoent,992 ) && sancorsalud
*!*				if len(alltrim(mcuit))>9
*!*					messagebox("EL NRO DE AFILIADO de SANCORSALUD NO ES CORRECTO",16,"Validacion")
*!*				endif
*!*		
		Case Inlist( codigoent,992 ) && sancorsalud
			if len(alltrim(chrtran(mcuit ," -/","")))#8
				messagebox("EL NRO DE AFILIADO de SANCORSALUD NO ES CORRECTO "+;
					chr(13)+"debe tener este formato 999999/99",16,"Validacion")
			endif
		case inlist( codigoent, 149)
			if !inlist(len(alltrim(mcuit)),10,11) or at(" ", alltrim(mcuit))>0
				if mensaje = 0
					messagebox("EL NRO DE AFILIADO OSDE NO ES CORRECTO",16,"Validacion")
				endif
				mresp =.f.
			Else
				lbResu = .f.
				lcResu = ''
				if mwkexe.nomexe #"AUDITORIA"				
					If !sp_valido_apligem(mcuit, .t., @lbResu, @lcResu)
					Else 
						If lbResu
	 						Messagebox("AFILIADO VALIDADO CORRECTAMENTE EN OSDE" ,48,"VALIDACION")
							mresp = .t.
						Else
						Endif 	
					Endif 	
				Endif 	
				
			endif
		case inlist( codigoent, 175, 75)
			mcuit = chrtran(mcuit," -/","")
			mcuit = left(mcuit,11)
			num01 = val(substr(mcuit,1,1))
			num02 = val(substr(mcuit,2,1))
			num03 = val(substr(mcuit,3,1))
			num04 = val(substr(mcuit,4,1))
			num05 = val(substr(mcuit,5,1))
			num06 = val(substr(mcuit,6,1))
			num07 = val(substr(mcuit,7,1))
			num08 = val(substr(mcuit,8,1))
			num09 = val(substr(mcuit,9,1))
			num10 = val(substr(mcuit,10,1))
			num11 = val(substr(mcuit,11,1))
			msuma = 0
			msuma = msuma + (num10 * 9)
			msuma = msuma + (num09 * 8)
			msuma = msuma + (num08 * 7)
			msuma = msuma + (num07 * 6)
			msuma = msuma + (num06 * 5)
			msuma = msuma + (num05 * 4)
			msuma = msuma + (num04 * 9)
			msuma = msuma + (num03 * 8)
			msuma = msuma + (num02 * 7)
			msuma = msuma + (num01 * 6)
			mresto = round(msuma % 11, 0)
			if mresto <> num11
				if mensaje = 0
					messagebox("EL CUIT NO ES VALIDO. MODIFIQUE EL NUMERO",16,"Validacion")
				endif
				mresp = .f.
			else
				mresp = .t.
			endif
	endcase
else
	if mensaje = 0
		messagebox("EL NUMERO DE AFILIADO NO ES CORRECTO",16,"Validacion")
	endif
	mresp = .f.
endif
