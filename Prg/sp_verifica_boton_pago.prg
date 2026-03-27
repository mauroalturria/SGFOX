* Marcelo Torres, 31/03/2022 - 10/06/2022
Lparameters nID

Local loXmlHttp,lclink,lcresp,lcIdTurno,CreadoBP,cMensaje,oIn,nPos
Local cEstado,nImporte,dFecCobro,dFecVencim,cHora,nI,nBP,lAprobado,dFecCancela
Local lHabCobro
Local cUrlDeudor
Local cClaveUnica

cEstado = ""
nImporte = 0
dFecCobro = {//}
dFecVencim = {//}
nBP = 0
lPagado = .F.
dFecCancela = {//}
cUrlDeudor = ""
cClaveUnica = ""

*** Buscamos pago
If Nvl(nID,0) > 0

	Create Cursor mwkbpago ( ;
		_estado c(30), ;
		_importe N(15,2), ;
		_fechap T , ;
		_fechav T, ;
		_fechac T, ;
		_claveunica c(100), ;
		_urldeudor c(100))

	lcIdTurno = Transform(nID)

	mccon = ''
	mccon = Left(SQLGetprop(mcon1,'ConnectString'),80)

	Do Case
	Case  (".190" $ mccon) && Desarrollo 190
		lclink = "https://desa.sg.com.ar/ws-osana/cons_bp-srv.php?idturno=" + lcIdTurno+"&ambito="+Transform(mxambito)
	Case  (".50.110" $ mccon) && Desarrollo 50.110
		lclink = "https://desa.sg.com.ar/ws-osana/cons_bp-srv.php?idturno=" + lcIdTurno+"&ambito="+Transform(mxambito)
	Case  (".50.102" $ mccon) && QAS 50.102
		lclink = "https://serviciosqas.sg.com.ar/ws-osana/cons_bp-srv.php?idturno=" + lcIdTurno+"&ambito="+Transform(mxambito)
	Case ("CACHEQAS"	$ mccon)  && QAS post migración - Marcelo Torres, 29/08/2024
    	lclink = "https://serviciosqas.sg.com.ar/ws-osana/cons_bp-srv.php?idturno=" + lcIdTurno+"&ambito="+Transform(mxambito)
	Otherwise  && Producción
		lclink = "https://servicios.sg.com.ar/ws-osana/cons_bp-srv.php?idturno=" + lcIdTurno+"&ambito="+Transform(mxambito)
	Endcase

	loXmlHttp = Createobject("MSXML2.XMLHTTP.3.0")
*!*	*lclink = "https://servicios.sg.com.ar/ws-osana/cons_bp-srv.php?idturno=19884871"
*!*		lclink = "https://servicios.sg.com.ar/ws-osana/cons_bp-srv.php?idturno=" + lcIdTurno

	loXmlHttp.Open( "GET" , lclink, .F. )
	loXmlHttp.Send()
	lcresp = Alltrim(loXmlHttp.responseText)
*** ? lcresp
	Release loXmlHttp

* Set Step On

	lcresp = Strtran(lcresp,"[","")
	lcresp = Strtran(lcresp,"]","")

	cCadenaJson = lcresp

	Do While !Empty(cCadenaJson)

		nPos = At("status",cCadenaJson)

		If nPos > 0

			For nI = nPos To Len(cCadenaJson)
				If Substr(cCadenaJson,nI,1) = "}"
					nI = nI + 1
					Exit
				Endif
			Next

			lcresp = Left(cCadenaJson,nI)

			cCadenaJson = Substr(cCadenaJson,nI+1,Len(cCadenaJson)-nI+1)

			If At('"status":"approved"',lcresp) > 0  &&excluimos los registros con "status=failed"

				Alines(aValores,lcresp,",")

***Append Blank In mwkbpago

				cMensaje = "Estado del Link De Pago" + Chr(10)
				nBP = 0

				For Each oIn In aValores

					oIn = Upper(oIn)
					nPos = At(":",oIn) + 1
					cValor = Strtran(Substr(oIn,nPos,Len(oIn) ),",","")
					cValor = Strtran(cValor,'"',"")
					cHora = ""

					Do Case
					Case At("EFECTIVO",oIn) > 0
*cMensaje = cMensaje + "Efectivo = " + Alltrim(cValor) + Chr(10)
						nImporte = nImporte + Val(Alltrim(cValor))
					Case At("BONO",oIn) > 0
*cMensaje = cMensaje + "Bono = " + Alltrim(cValor) + Chr(10)
						nImporte = nImporte + Val(Alltrim(cValor))
*Case At("FECHATURNO",oIn) > 0
*cMensaje = cMensaje + "Fecha del Turno = " + Alltrim(cValor) + Chr(10)
*Case At("HORATURNO",oIn) > 0
*cMensaje = cMensaje + "Hora del Turno = " + Alltrim(cValor) + Chr(10)
*Case At("FECHACREACOBRO",oIn) > 0

*Set Step On

*!*					If !Empty(cValor)
*!*						cValor = Left(cValor,10)

*!*						cValor = Right(cValor,2)+"/"+Substr(cValor,6,2)+"/"+ Left(cValor,4)
*!*						dFecCobro = Ctod(cValor)
*!*					Endif


					Case At("FECHAVENCECOBRO",oIn) > 0

						If !Empty(cValor)
							cHora = Right(cValor,8)
							cValor = Left(cValor,10)

							cValor = Right(cValor,2)+"/"+Substr(cValor,6,2)+"/"+ Left(cValor,4) + " " + cHora
							dFecVencim = Ctot(cValor)
						Endif


					Case At("FECHA_DEL_PAGO",oIn) > 0

*!*							If !Empty(cValor)
*!*								cHora = Right(cValor,8)
*!*								cValor = Left(cValor,10)

*!*								cValor = Right(cValor,2)+"/"+Substr(cValor,6,2)+"/"+ Left(cValor,4)+" " + cHora
*!*								dFecCobro = Ctot(cValor)
*!*							Endif

						If !Empty(cValor)
							If cValor = "1900-01-01 00:00:00" Or cValor = "1900-01-01 00:00"
								dFecCobro = {//}
							Else
								cValor = Left(cValor,16)
								cHora = Right(cValor,5)
								cValor = Left(cValor,10)

								cValor = Right(cValor,2)+"/"+Substr(cValor,6,2)+"/"+ Left(cValor,4)+" " + cHora
								dFecCobro = Ctot(cValor)

							Endif

						Endif

					Case At("CREADOBP",oIn) > 0

						nBP = Val(cValor)
*!*					Do Case
*!*					Case = 0
*!*						cMensaje = cMensaje +  "BP no creado" + Chr(10)
*!*					Case = 1
*!*						cMensaje = cMensaje + "BP creado" + Chr(10)
*!*					Case = 2
*!*						cMensaje = cMensaje + "BP cobrado" +Chr(10)
*!*					Case = 3
*!*						cMensaje = cMensaje + "BP vencido" + Chr(10)
*!*					Case = 4
*!*						cMensaje = cMensaje + "BP copago $0" + Chr(10)
*!*					Case = 5
*!*						cMensaje = cMensaje + "No existe el turno" + Chr(10)
*!*					Endcase
					Case At("ESTADO",oIn) > 0
*cMensaje = cMensaje + "Estado = " + cValor
						cEstado = cValor

					Case At("CANCELADOCOBROFECHAHORA",oIn) > 0	&&CanceladoCobroFechaHora

						If !Empty(cValor)
							cHora = Right(cValor,8)
							cValor = Left(cValor,10)

							cValor = Right(cValor,2)+"/"+Substr(cValor,6,2)+"/"+ Left(cValor,4)+" " + cHora
							dFecCancela = Ctot(cValor)
						Endif

					Case At("URLDEUDOR",oIn) > 0
* SET STEP ON
* "urldeudor":"https:\/\/test-chronos-wallet.pantheonsite.io\/pagar\/47613939"
						cUrlDeudor = cValor
						cUrlDeudor = Strtran(cUrlDeudor,"\","")

					Case At("CLAVEUNICA1",oIn) > 0
* SET STEP ON
* "claveunica1":"QASS19337857-1zZ68920eeab38ae5b43e43f07bac62dfb7c159b0a9"
						cClaveUnica = cValor

					Endcase

				Next

				Select mwkbpago

				If !Empty(cEstado)

					Append Blank In mwkbpago

*!*	CreadoBP=0 then 'LinkBP_pendiente' when
*!*	CreadoBP=1 then 'LinkBP_generado' when
*!*	CreadoBP=2 then 'Cobrado'  when
*!*	CreadoBP=3 then 'Vencido' when
*!*	CreadoBP=4 then 'Monto$0' when
*!*	CreadoBP=5 then 'TurnoSInDatos' when
*!*	CreadoBP=6 then 'CanceladoSPago'  when
*!*	CreadoBP=7 then 'CanceladoCPago'
*!*	CreadoBP=11 then 'CanceladoSinDevolucion'

					Replace _estado With cEstado
					
					If !Inlist(nBP,4,5)

						If nBP = 2  && Cobrado
							lPagado = .T.
						Endif

						Replace _importe With nImporte
						Replace _fechap With dFecCobro
						Replace _fechav With dFecVencim
						Replace _fechac With dFecCancela
						Replace _claveunica With cClaveUnica
						Replace _urldeudor With cUrlDeudor

					Endif
				Endif

			Endif


		Endif

	Enddo


Endif

Return lPagado

