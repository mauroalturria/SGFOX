****
** Grabo evolucion del paciente
****
*!*		do sp_grabo_evolucion_INT with mnreg, thisform.txtprotocolo.value,thisform.medcabecera;
*!*			, thisform.PgConsulta.pgEvolmed,thisform.PgConsulta.pgIndNur,thisform.PgConsulta.pgCSV;
*!*			,iif(thisform.mformorigen=28, mwkusuarios.codigovax,0),;
*!*			thisform.lmodifresumen,thisform.lclose,iif(thisform.mformorigen=28 ,0,thisform.miorigen)

Parameters mnroreg, mprot, mmedico, mopage3,mopage4,mopage5,musua,morigen,lnARM,mopage1,lmodifscore61
Dimension admfar(11),pract(13)
Set Escape Off
**** mopage1 = ThisForm.PgConsulta.PgIndic.pgindicaciones.Page1
* mopage3 = thisform.PgConsulta.pgIndNur
* mopage4 = thisform.PgConsulta.pgCSV;
***** mopage5 = thisform.PgConsulta.pgescalas; sin mopage5.pgescalas
***** mopage6 = thisform.PgConsulta.pgEpicris;
***** 	mopage7 = thisform.PgConsulta.PgIndic
*****
* Campos reutilizados
*****
midusuario = Iif(Used('mwkusuarios'),mwkusuarios.Id ,mwkusuario.Id)
mfechahora  = sp_busco_fecha_serv("DT")
mfechadia = Ttod(mfechahora )
mfecini = Ctod("01/01/1900")
mfechaini  = Ctot("01/01/1900")
mfecfin = Ctod("01/01/2100")
mcodcienanda = 0
msoloevol = ''

mltipalta = mopage3.Parent.Parent.ltipalta
mlcodesta = mopage3.Parent.Parent.lcodesta
mlcierreant = mopage3.Parent.Parent.lcierreant
midevol	= mopage3.Parent.Parent.midevol
mlmodifevoln = mopage3.Parent.Parent.lmodifevoln
mlcambiocsv  = mopage3.Parent.Parent.lcambiocsv
mlmedcabe = .F.

miprotquir = ''
mcodmedpq  = 0
mevolnursea = ''
mevolnursett = ''
mindictt = ''

calta 	 = '' &&iif(mwkveoproto.tipoest =0 or lcierreant,"Evolución Posterior al CIERRE del Protocolo ","")
caltanur = ''&&iif((mwkveoproto.tipoest =0 or lcierreant) and !empty(mopage3.txtedtindic.value),"Indicación Posterior al CIERRE del Protocolo ","")
mresumen = ''
mintercons = ''
mnurse = ''
mnursered = ''
If mlmodifevoln
	With mopage1
		If .txtpuntos.Value >0
			mnurse = mnurse + "Screening nutricional MST: Malnutrition Screening Tool"+Chr(10)
			mnursered = mnursered + "Screening nutricional MST"
			mc1 = '.opt1.option'+Transform(.opt1.Value,"9")+'.caption'
			If .opt1.Value>0
				mnurse = mnurse + "PERDIDA DE PESO  Involuntaria en los últimos 3 meses: "+ &mc1 + Chr(10)
			Endif
			mc1 = '.opt2.option'+Transform(.opt2.Value,"9")+'.caption'
			If .opt2.Value>0
				mnurse = mnurse + "¿CUANTO PESO PERDIÓ?: "+ &mc1 + Chr(10)
			Endif
			mc1 = '.opt3.option'+Transform(.opt3.Value,"9")+'.caption'
			If .opt3.Value>0
				mnurse = mnurse + "¿Ha estado comiendo poco por tener menos apetito?: "+ &mc1 + Chr(10)
			Endif
			mnurse = mnurse + "PUNTAJE DE MST (Pérdida de peso + Apetito): "+ Transform(.txtpuntos.Value,"99") + Chr(10)
			mnursered = mnursered + " - PUNTAJE DE MST (Pérdida de peso + Apetito): "+ Transform(.txtpuntos.Value,"99")
			If !Empty(.TxteditEvol.Value)
				mnurse = mnurse + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
				mnursered = mnursered + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
			Else
				mnursered = mnursered + Chr(10)
			Endif
			If .txtpuntos.Value<=1
				mnurse = mnurse + "Riesgo Bajo "+ Chr(10)
				mnursered = mnursered + " - Riesgo Bajo" + Chr(10)
			Else
				If .txtpuntos.Value >=4
					mnurse = mnurse + "Riesgo Alto "+ Chr(10)
					mnursered = mnursered + " - Riesgo Alto" + Chr(10)
				Else
					mnurse = mnurse + "Riesgo Medio"+ Chr(10)
					mnursered = mnursered + " - Riesgo Medio" + Chr(10)

				Endif

			Endif

		Endif
	Endwith

	With mopage5.pgescalas
		With .page2
			If .opt1.Value>0
				mnurse = mnurse + "Evaluación del riesgo de caídas - J.H.Downton"+Chr(10)
				mnursered = mnursered + "Evaluación del riesgo de caídas - J.H.Downton: "
				If .opt1.Value>0
					mc1 = '.opt1.option'+Transform(.opt1.Value,"9")+'.caption'
					mnurse = mnurse + "Caídas previas: "+ &mc1 + Chr(10)
				Endif
				If .opt3.Value>0
					mc1 = '.opt3.option'+Transform(.opt3.Value,"9")+'.caption'
					mnurse = mnurse + "Medicamentos: "+ &mc1 + Chr(10)
				Endif
				If .opt5.Value>0
					mc1 = '.opt5.option'+Transform(.opt5.Value,"9")+'.caption'
					mnurse = mnurse + "Déficits sensoriales: "+ &mc1 + Chr(10)
				Endif
				If .opt4.Value>0
					mc1 = '.opt4.option'+Transform(.opt4.Value,"9")+'.caption'
					mnurse = mnurse + "Estado mental: "+ &mc1 + Chr(10)
				Endif
				If .opt2.Value>0
					mc1 = '.opt2.option'+Transform(.opt2.Value,"9")+'.caption'
					mnurse = mnurse + "Deambulación: "+ &mc1 + Chr(10)
				Endif
				mnurse = mnurse + "PUNTAJE: "+ Transform(.txtpuntos.Value,"999") + Chr(10)
				mnursered = mnursered + "PUNTAJE: "+ Transform(.txtpuntos.Value,"999")
				If !Empty(.TxteditEvol.Value)
					mnurse = mnurse + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
					mnursered = mnursered + " - Observaciones: "+ Alltrim(.TxteditEvol.Value)
				Endif
				If .txtpuntos.Value>1
					mnurse = mnurse + "Riesgo de caída ALTO "+ Chr(10)
					mnursered = mnursered + " - Riesgo de caída ALTO " + Chr(10)
				Endif
			Endif
		Endwith
		With .page3
			If .txtpuntos.Value >0
				mnurse = mnurse + "Escala de riesgo de UPP - Norton"+Chr(10)
				mnursered = mnursered + "Escala de riesgo de UPP - Norton"
				mc1 = '.opt1.option'+Transform(.opt1.Value,"9")+'.caption'
				If .opt1.Value>0
					mnurse = mnurse + "Estado fisico general: "+ &mc1 + Chr(10)
				Endif
				mc1 = '.opt2.option'+Transform(.opt2.Value,"9")+'.caption'
				If .opt2.Value>0
					mnurse = mnurse + "Incontinencia: "+ &mc1 + Chr(10)
				Endif
				mc1 = '.opt3.option'+Transform(.opt3.Value,"9")+'.caption'
				If .opt3.Value>0
					mnurse = mnurse + "Estado mental: "+ &mc1 + Chr(10)
				Endif
				mc1 = '.opt4.option'+Transform(.opt4.Value,"9")+'.caption'
				If .opt4.Value>0
					mnurse = mnurse + "Actividad: "+ &mc1 + Chr(10)
				Endif
				mc1 = '.opt5.option'+Transform(.opt5.Value,"9")+'.caption'
				If .opt5.Value>0
					mnurse = mnurse + "Movilidad: "+ &mc1 + Chr(10)
				Endif
				mnurse = mnurse + "PUNTAJE: "+ Transform(.txtpuntos.Value,"999") + Chr(10)
				mnursered = mnursered + " - PUNTAJE: "+ Transform(.txtpuntos.Value,"999")
				If !Empty(.TxteditEvol.Value)
					mnurse = mnurse + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
					mnursered = mnursered + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
				Else
					mnursered = mnursered + Chr(10)
				Endif
			Endif
		Endwith
		With .page6
			If .txtpuntos.Value >0 And  .opt1.Value >0
				mnurse = mnurse + "Estadío de UPP"+Chr(10)
				mnursered = mnursered + "Estadío de UPP "
				If .opt1.Value>0
					mc1 = '.opt1.option'+Transform(.opt1.Value,"9")+'.comment'
					mc2 = '.opt1.option'+Transform(.opt1.Value,"9")+'.caption'

					mnurse = mnurse + "PUNTAJE: " + &mc1 + " - "+ &mc2 + Chr(10)
					mnursered = mnursered + " PUNTAJE: " + &mc1 + " - "+ &mc2
				Endif
				If !Empty(.TxteditEvol.Value)
					mnurse = mnurse + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
					mnursered = mnursered + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
				Else
					mnursered = mnursered + Chr(10)
				Endif
			Endif
		Endwith
		With .page4
			If .txtpuntos.Value >0 And  .opt1.Value >0 And  .opt2.Value >0 And  .opt3.Value >0
				mnurse = mnurse + "Escala de coma de Glasgow"+Chr(10)
				mnursered = mnursered + "Escala de coma de Glasgow "
				mc1 = '.opt1.option'+Transform(.opt1.Value,"9")+'.caption'
				mnurse = mnurse + "Respuesta Apertura ocular: "+ &mc1 + Chr(10)
				mc1 = '.opt2.option'+Transform(.opt2.Value,"9")+'.caption'
				mnurse = mnurse + "Respuesta verbal: "+ &mc1 + Chr(10)
				mc1 = '.opt3.option'+Transform(.opt3.Value,"9")+'.caption'
				mnurse = mnurse + "Mejor respuesta motora: "+ &mc1 + Chr(10)
				mnurse = mnurse + "PUNTAJE: "+ Transform(.txtpuntos.Value,"99")+"/15" + Chr(10)
				mnursered = mnursered + " PUNTAJE: "+ Transform(.txtpuntos.Value,"99")+"/15"
				If !Empty(.TxteditEvol.Value)
					mnurse = mnurse + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
					mnursered = mnursered + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
				Else
					mnursered = mnursered + Chr(10)
				Endif
			Endif
		Endwith
		With .page5
			If  .opt1.Value >0
				mnurse = mnurse +Chr(10)+ "Escala agitación / sedación - RASS"+Chr(10)
				mnursered = mnursered +Chr(10)+ "Escala agitación / sedación - RASS  "
				mc1 = ".label14"+Alltrim(Transform(.opt1.Value,"99"))+".caption"
				mnurse = mnurse + "PUNTAJE: "+ Transform(.txtpuntos.Value)+ " => " +&mc1 + Chr(10)
				mnursered = mnursered + "PUNTAJE: "+ Transform(.txtpuntos.Value)+ " => " +&mc1
				If !Empty(.TxteditEvol.Value)
					mnurse = mnurse + " Observaciones: "+ .TxteditEvol.Value+ Chr(10)
					mnursered = mnursered + "Observaciones: "+ .TxteditEvol.Value
				Else
					mnursered = mnursered + Chr(10)
				Endif
*!*					mnurse = mnurse + "Nivel de sedación - Ramsay"+chr(10)
*!*					mc1 = '.opt1.option'+transform(.opt1.value,"9")+'.caption'
*!*					mnurse = mnurse + "Nivel de sedación: "+ &mc1 + chr(10)
*!*					mnurse = mnurse + "PUNTAJE: "+ transform(.txtpuntos.value,"999") + chr(10)
*!*					if !empty(.TxteditEvol.value)
*!*						mnurse = mnurse + "Observaciones: "+ .TxteditEvol.value+ chr(10)
*!*					endif
			Endif
		Endwith
		With .page1
			If .txtpuntos.Value <11
				mnurse = mnurse + "Evaluacion del dolor"+Chr(10)
				mnursered = mnursered + "Evaluacion del dolor  "
				mnurse = mnurse + "PUNTAJE: "+ Transform(.txtpuntos.Value,"999") + Chr(10)
				mnursered = mnursered + "PUNTAJE: "+ Transform(.txtpuntos.Value,"999")
				If !Empty(.TxteditEvol.Value)
					mnurse = mnurse + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
					mnursered = mnursered + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
				Else
					mnursered = mnursered + Chr(10)
				Endif
			Endif
		Endwith
		With .page7
			If .txtpuntos.Value >0 And  .opt1.Value >0 And  .opt2.Value >0 And  .opt3.Value >0 And .opt4.Value >0
				mnurse = mnurse +Chr(10)+ " Valoración del dolor Cuidados Críticos - CPOT"+Chr(10)
				mnursered = mnursered + " Valoración del dolor Cuidados Críticos - CPOT"
				mc1 = '.opt1.option'+Transform(.opt1.Value,"9")+'.caption'
				mnurse = mnurse + "Expresion facial: "+ &mc1 + Chr(10)
				mc1 = '.opt2.option'+Transform(.opt2.Value,"9")+'.caption'
				mnurse = mnurse + "Movimiento Corporal: "+ &mc1 + Chr(10)
				mc1 = '.opt3.option'+Transform(.opt3.Value,"9")+'.caption'
				mnurse = mnurse + "Tono Muscular: "+ &mc1 + Chr(10)
				mc1 = '.opt4.option'+Transform(.opt4.Value,"9")+'.caption'
				mnurse = mnurse + "Adaptación al ventilador: "+ &mc1 + Chr(10)
				mc1 = '.opt5.option'+Transform(.opt5.Value,"9")+'.caption'
				mnurse = mnurse + "Vocalización (extubados): "+ &mc1 + Chr(10)
				mnurse = mnurse + "PUNTAJE: "+ Transform(.txtpuntos.Value,"99")+"/15" + Chr(10)
				mnursered = mnursered + " PUNTAJE: "+ Transform(.txtpuntos.Value,"99")+"/15"
				If !Empty(.TxteditEvol.Value)
					mnurse = mnurse + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
					mnursered = mnursered + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
				Else
					mnursered = mnursered + Chr(10)
				Endif
			Endif
		Endwith
		With .page8
			With .pgescore
				mopc1 = .page1.opt1.Value
				mopc2 = .page2.opt1.Value
				mopc3 = .page3.opt1.Value
				mopc4 = .page4.opt1.Value
				mopc5 = .page5.opt1.Value
				mopc6 = .page6.opt1.Value
			Endwith
			If .txtpuntos.Value >0 And  mopc1 >0 And mopc2  >0 And mopc3 >0 And mopc4 >0 And mopc5 >0 And mopc6>0
				mnurse = mnurse +Chr(10)+ " Escala de Braden para la predicción del riesgo de úlceras por presión"+Chr(10)
				mnursered = mnursered + " Escala de Braden para la predicción del riesgo de úlceras por presión"
				mc1 = '.pgescore.page1.opt1.option'+Transform(mopc1,"9")+'.caption'
				mnurse = mnurse + "Percepción sensorial - Capacidad para reaccionar ante una molestia relacionada con la presión: "+ &mc1 + Chr(10)
				mc1 = '.pgescore.page2.opt1.option'+Transform(mopc2,"9")+'.caption'
				mnurse = mnurse + "Exposición a la humedad - Nivel de exposición de la piel a la humedad: "+ &mc1 + Chr(10)
				mc1 = '.pgescore.page3.opt1.option'+Transform(mopc3,"9")+'.caption'
				mnurse = mnurse + "Actividad - Nivel de actividad: "+ &mc1 + Chr(10)
				mc1 = '.pgescore.page4.opt1.option'+Transform(mopc4,"9")+'.caption'
				mnurse = mnurse + "Movilidad - Capacidad para cambiar y controlar la posición del cuerpo: "+ &mc1 + Chr(10)
				mc1 = '.pgescore.page5.opt1.option'+Transform(mopc5,"9")+'.caption'
				mnurse = mnurse + "Roce y peligro de lesiones: "+ &mc1 + Chr(10)
				mc1 = '.pgescore.page6.opt1.option'+Transform(mopc6,"9")+'.caption'
				mnurse = mnurse + "Nutrición - Patrón usual de ingesta de alimentos: "+ &mc1 + Chr(10)
				mnurse = mnurse + "PUNTAJE: "+ Transform(.txtpuntos.Value,"99")+"/15" + Chr(10)
				mnursered = mnursered + " PUNTAJE: "+ Transform(.txtpuntos.Value,"99")+"/15"
				If !Empty(.TxteditEvol.Value)
					mnurse = mnurse + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
					mnursered = mnursered + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
				Else
					mnursered = mnursered + Chr(10)
				Endif
			Endif
		Endwith
		With .page10
			If  lmodifscore61
				mnurse = mnurse +Chr(10)+ "Escala de Maddox - Valoración de Flebitis "+Chr(10)
				mpto = Val(Transform(.txtpuntos.Value))
				mnurse = mnurse + "RIESGO: "+ Iif(mpto=0,"BAJO", Iif(mpto=2,"LEVE","GRAVE" ))+ Chr(10)
				If !Empty(.TxteditEvol.Value)
					mnurse = mnurse + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
				Endif
				mnursered = mnursered + mnurse
			Endif
		Endwith


	Endwith
**** PEDIATRIA
	If (mwkinterna.IH_secagrup $ mopage5.SCORES_PED_NUR1.sectores)
		With mopage5.SCORES_PED_NUR1.pgescalas
			With .page2
				If .opt1.Value>0
					mnurse = mnurse + "Escala de caídas - Humpty Dumpty"+Chr(10)
					mnursered = mnursered + "Escala de caídas - Humpty Dumpty "
					For fsn = 1 To 8
						mc1 = '.opt1.option'+Transform(.opt1.Value,"9")+'.caption'
						mvop = '.opt'+Transform(fsn,"9")+'.value'
						mc1p = '.label'+Transform(fsn,"9")+'.caption'
						If &mvop >0
							mnurse = mnurse + &mc1p +":"+ &mc1+ Chr(10)
						Endif
					Next fsn
					mnurse = mnurse + "PUNTAJE: "+ Transform(.txtpuntos.Value,"999") + Chr(10)
					mnursered = mnursered + "PUNTAJE: "+ Transform(.txtpuntos.Value,"999")
					If !Empty(.TxteditEvol.Value)
						mnurse = mnurse + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
						mnursered = mnursered + " - Observaciones: "+ Alltrim(.TxteditEvol.Value)
					Endif
				Endif
			Endwith
			With .page3
				If .txtpuntos.Value >2
					mnurse = mnurse + "Escala de Glasgow "+Chr(10)
					mnursered = mnursered + "Escala de Glasgow "
					mevolesc = ''
					For itu = 1 To 3
						mcl = ".label"+Transform(itu,"9")+".caption"
						micar = &mcl
						mop = ".opt"+Transform(itu,"9")
						With &mop
							mival = .Value
							If mival >0
								mevolesc = mevolesc +micar+ ": "
								mc1 = '.option'+Transform(mival,"9")+'.caption'
								mevolesc = mevolesc +&mc1+ Chr(10)
							Endif
						Endwith
					Next
					mnurse = mnurse +mevolesc + "PUNTAJE: "+ Transform(.txtpuntos.Value,"999") + Chr(10)
					mnursered = mnursered + "PUNTAJE: "+ Transform(.txtpuntos.Value,"999")
					If !Empty(.TxteditEvol.Value)
						mnurse = mnurse + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
						mnursered = mnursered + " - Observaciones: "+ Alltrim(.TxteditEvol.Value)
					Endif

*!*					if .txtpuntos.value >0
*!*						mnurse = mnurse + "Valoración respiratoria del RN - Test de Silverman"+chr(10)
*!*						mnursered = mnursered + "Valoración respiratoria del RN - Test de Silverman"
*!*						for fsn = 1 to 6
*!*							mc1 = '.opt1.option'+transform(.opt1.value,"9")+'.caption'
*!*							mvop = '.opt'+transform(fsn,"9")+'.value'
*!*							mc1p = '.label'+transform(fsn,"9")+'.caption'
*!*							if &mvop >0
*!*								mnurse = mnurse + &mc1p +":"+ &mc1+ chr(10)
*!*							endif
*!*						next fsn

*!*						mnurse = mnurse + "PUNTAJE: "+ transform(.txtpuntos.value,"999") + chr(10)
*!*						mnursered = mnursered + " - PUNTAJE: "+ transform(.txtpuntos.value,"999")
*!*						if !empty(.TxteditEvol.value)
*!*							mnurse = mnurse + "Observaciones: "+ .TxteditEvol.value+ chr(10)
*!*							mnursered = mnursered + "Observaciones: "+ .TxteditEvol.value+ chr(10)
*!*						else
*!*							mnursered = mnursered + chr(10)
*!*						endif

				Endif
			Endwith
			With .page5
				If  .opt1.Value >0
					mnurse = mnurse + "Escala de valoración de la piel: NSCS ( Neonatal Skin Condition Scale )"+Chr(10)
					mnursered = mnursered + "Escala de valoración de la piel: NSCS ( Neonatal Skin Condition Scale ) "
					For fsn = 1 To 3
						mc1 = '.opt1.option'+Transform(.opt1.Value,"9")+'.caption'
						mvop = '.opt'+Transform(fsn,"9")+'.value'
						mc1p = '.label'+Transform(fsn,"9")+'.caption'
						If &mvop >0
							mnurse = mnurse + &mc1p +":"+ &mc1+ Chr(10)
						Endif
					Next fsn

					mnurse = mnurse + "PUNTAJE: " + Transform(.txtpuntos.Value,"999") + Chr(10)
					mnursered = mnursered + " PUNTAJE: " +Transform(.txtpuntos.Value,"999") + Chr(10)
					If !Empty(.TxteditEvol.Value)
						mnurse = mnurse + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
						mnursered = mnursered + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
					Else
						mnursered = mnursered + Chr(10)
					Endif
				Endif
			Endwith
			With .page4
				If .txtpuntos.Value <11
					mnurse = mnurse + "Evaluacion del dolor"+Chr(10)
					mnursered = mnursered + "Evaluacion del dolor  "
					mnurse = mnurse + "PUNTAJE: "+ Transform(.txtpuntos.Value,"999") + Chr(10)
					mnursered = mnursered + "PUNTAJE: "+ Transform(.txtpuntos.Value,"999")
					If !Empty(.TxteditEvol.Value)
						mnurse = mnurse + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
						mnursered = mnursered + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
					Else
						mnursered = mnursered + Chr(10)
					Endif
				Endif
			Endwith
			With .page1
				If .opt1.Value >0
					mnurse = mnurse + "Escala de Maddox - Valoración de Flebitis "+Chr(10)
					mnursered = mnursered + "Escala de Maddox - Valoración de Flebitis   "
					mc1 = '.opt1.option'+Transform(.opt1.Value,"9")+'.caption'
					mc1p = '.lbl'+Transform(.opt1.Value,"9")+'.caption'
					If .opt1.Value>0
						mnurse = mnurse + "Valoración: "+ &mc1 + &mc1p + Chr(10)
					Endif

					mnurse = mnurse + "PUNTAJE: "+ Transform(.txtpuntos.Value,"999") + Chr(10)
					mnursered = mnursered + "PUNTAJE: "+ Transform(.txtpuntos.Value,"999")
					If !Empty(.TxteditEvol.Value)
						mnurse = mnurse + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
						mnursered = mnursered + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
					Else
						mnursered = mnursered + Chr(10)
					Endif
				Endif
			Endwith

		Endwith
	Endif
	If  mopage5.scores_neo1.Visible
		With mopage5.scores_neo1.pgescalas
			With .page2
				If .opt1.Value>0
					mnurse = mnurse + "Escala de caídas - Humpty Dumpty"+Chr(10)
					mnursered = mnursered + "Escala de caídas - Humpty Dumpty "
					For fsn = 1 To 8
						mc1 = '.opt1.option'+Transform(.opt1.Value,"9")+'.caption'
						mvop = '.opt'+Transform(fsn,"9")+'.value'
						mc1p = '.label'+Transform(fsn,"9")+'.caption'
						If &mvop >0
							mnurse = mnurse + &mc1p +":"+ &mc1+ Chr(10)
						Endif
					Next fsn
					mnurse = mnurse + "PUNTAJE: "+ Transform(.txtpuntos.Value,"999") + Chr(10)
					mnursered = mnursered + "PUNTAJE: "+ Transform(.txtpuntos.Value,"999")
					If !Empty(.TxteditEvol.Value)
						mnurse = mnurse + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
						mnursered = mnursered + " - Observaciones: "+ Alltrim(.TxteditEvol.Value)
					Endif
				Endif
			Endwith
			With .page3
				If .txtpuntos.Value >0
					mnurse = mnurse + "Valoración respiratoria del RN - Test de Silverman"+Chr(10)
					mnursered = mnursered + "Valoración respiratoria del RN - Test de Silverman"

					If .opt1.Value>0
						For fsn = 1 To 6
							mvop = '.opt'+Transform(fsn,"9")
							With &mvop
								mval = .Value
								mc1 = '.option'+Transform(mval,"9")+'.caption'
								If mval>0
									mcval = &mc1
								Endif
							Endwith
							mc1p = '.label'+Transform(fsn,"9")+'.caption'
							If mval  >0
								mnurse = mnurse + &mc1p +":"+ mcval + Chr(10)
							Endif
						Next fsn
					Endif
					mnurse = mnurse + "PUNTAJE: "+ Transform(.txtpuntos.Value,"999") + Chr(10)
					mnursered = mnursered + " - PUNTAJE: "+ Transform(.txtpuntos.Value,"999")
					If !Empty(.TxteditEvol.Value)
						mnurse = mnurse + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
						mnursered = mnursered + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
					Else
						mnursered = mnursered + Chr(10)
					Endif

				Endif
			Endwith
			With .page5
				If  .opt1.Value >0
					mnurse = mnurse + "Escala de valoración de la piel: NSCS ( Neonatal Skin Condition Scale )"+Chr(10)
					mnursered = mnursered + "Escala de valoración de la piel: NSCS ( Neonatal Skin Condition Scale ) "
					For fsn = 1 To 3
						mc1 = '.opt1.option'+Transform(.opt1.Value,"9")+'.caption'
						mvop = '.opt'+Transform(fsn,"9")+'.value'
						mc1p = '.label'+Transform(fsn,"9")+'.caption'
						If &mvop >0
							mnurse = mnurse + &mc1p +":"+ &mc1+ Chr(10)
						Endif
					Next fsn

					mnurse = mnurse + "PUNTAJE: " + Transform(.txtpuntos.Value,"999") + Chr(10)
					mnursered = mnursered + " PUNTAJE: " +Transform(.txtpuntos.Value,"999") + Chr(10)
					If !Empty(.TxteditEvol.Value)
						mnurse = mnurse + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
						mnursered = mnursered + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
					Else
						mnursered = mnursered + Chr(10)
					Endif
				Endif
			Endwith
			With .page4
				If .txtpuntos.Value >0 And  .opt1.Value >0 And  .opt2.Value >0 And  .opt3.Value >0
					mnurse = mnurse + "Escala del Dolor - Puntuación CRIES"+Chr(10)
					mnursered = mnursered + "Escala del Dolor - Puntuación CRIES "
					For fsn = 1 To 5
						mc1 = '.opt1.option'+Transform(.opt1.Value,"9")+'.caption'
						mvop = '.opt'+Transform(fsn,"9")+'.value'
						mc1p = '.label'+Transform(fsn,"9")+'.caption'
						If &mvop >0
							mnurse = mnurse + &mc1p +":"+ &mc1+ Chr(10)
						Endif
					Next fsn					mnurse = mnurse + "PUNTAJE: "+ Transform(.txtpuntos.Value,"99")+"/15" + Chr(10)
					mnursered = mnursered + " PUNTAJE: "+ Transform(.txtpuntos.Value,"99")+"/15"
					If !Empty(.TxteditEvol.Value)
						mnurse = mnurse + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
						mnursered = mnursered + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
					Else
						mnursered = mnursered + Chr(10)
					Endif
				Endif
			Endwith
			With .page1
				If .txtpuntos.Value <11
					mnurse = mnurse + "Escala de Maddox - Valoración de Flebitis "+Chr(10)
					mnursered = mnursered + "Escala de Maddox - Valoración de Flebitis   "
					mc1 = '.opt1.option'+Transform(.opt1.Value,"9")+'.caption'
					mc1p = '.lbl'+Transform(.opt1.Value,"9")+'.caption'
					If .opt1.Value>0
						mnurse = mnurse + "Valoración: "+ &mc1 + &mc1p + Chr(10)
					Endif

					mnurse = mnurse + "PUNTAJE: "+ Transform(.txtpuntos.Value,"999") + Chr(10)
					mnursered = mnursered + "PUNTAJE: "+ Transform(.txtpuntos.Value,"999")
					If !Empty(.TxteditEvol.Value)
						mnurse = mnurse + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
						mnursered = mnursered + "Observaciones: "+ .TxteditEvol.Value+ Chr(10)
					Else
						mnursered = mnursered + Chr(10)
					Endif
				Endif
			Endwith

		Endwith
	Endif
	If !Empty(mnursered)
		mobs = mnursered
		mret = SQLExec(mcon1, "insert into TabIntEvolParcial " + ;
			"(EIP_evol , EIP_fechaH , EIP_idevol , EIP_tipoEvol , EIP_tipoUsuario , EIP_usuario  )"+;
			" values "+;
			" (?mobs,?mfechahora,?midevol,'S', 2, ?midusuario )" )
		If mret < 0
			Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
				"AVISE A SISTEMAS",16, "ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Endif
	Endif
	If !Empty(mnurse)
		mobs = mnurse
		mret = SQLExec(mcon1, "insert into TabIntEvolParcial " + ;
			"(EIP_evol , EIP_fechaH , EIP_idevol , EIP_tipoEvol , EIP_tipoUsuario , EIP_usuario  )"+;
			" values "+;
			" (?mobs,?mfechahora,?midevol,'s', 2, ?midusuario )" )
		If mret < 0
			Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
				"AVISE A SISTEMAS",16, "ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Endif
	Endif
	mnurse = ''
	mnursered = ''

	If mlcambiocsv
		With mopage4
			mhoratoma 	= .txthora.Value
			mnurse = mnurse + ' Datos de las '+Transform(mhoratoma)+Chr(10)
			mpartenssis = .txttasist.Value
			mpartensdia = .txttadia.Value
			mnurse = mnurse + Iif(mpartenssis # 0, 'T.Art.Sistólica mmHg:' + Transf(mpartenssis ,'999');
				+ " T.Art.Diastólica mmHg:"+ Transf(mpartensdia ,'999') +Chr(10),'')
			mpartam	= .TxtTAM.Value
			mnurse = mnurse + Iif(mpartam# 0, 'TAM:'+ Transf(mpartam,'999') + Chr(10),'')
			mparfrecard	= .txtfcard.Value
			mnurse = mnurse + Iif(mparfrecard# 0, 'Frecuencia Cardíaca (latidos x min.):'+ Transf(mparfrecard,'999') + Chr(10),'')
			mparfreresp = .txtfresp.Value
			mnurse = mnurse + Iif(mparfreresp # 0, 'Frecuencia Respiratoria (respiración x min.):'+ Transf(mparfreresp ,'999') + Chr(10),'')
			mpartemaxl 	= .txttempax.Value
			mnurse = mnurse + Iif(mpartemaxl # 0, 'Tª Axilar (grado centigrado):'+ Transf(mpartemaxl ,'99.9') + Chr(10),'')
			mparsatur 	= .txtsat.Value
			mnurse = mnurse + Iif(mparsatur # 0, 'Saturación de O2 en sangre %'+ Transf(mparsatur ,'999') + Chr(10),'')
			mnO2Aux 	= .optO2suple.Value
			mnurse = mnurse + Iif(mnO2Aux # 0, Iif(mnO2Aux =1," SI",Iif(mnO2Aux =2," NO",' --'))+ ' Requiere Oxígeno suplementario' + Chr(10),'')
			mpargluc 	= .txtgluc.Value
			mnurse = mnurse + Iif(mpargluc # 0, ' Glucemia:'+ Transf(mpargluc ,'9999') + ' mg/dl '+ Chr(10),'')
			mparcorgluc 	= .txtCorrGl.Value
			mnurse = mnurse + Iif(mparcorgluc # 0, ' Correción:'+ Transf(mparcorgluc ,'9999') + ' UI '+ Chr(10),'')
			mparpeso 	= .txtpeso.Value
			mnurse = mnurse + Iif(mparpeso # 0 And mwkulvalp.valor #mparpeso , ' Peso:'+ Transf(mparpeso ,'999.9') +' Kgs '+ Chr(10),'')
			mparalt 	= .txtalt.Value
			mnurse = mnurse + Iif(mparalt # 0 And mwkulvala.valor #mparalt , ' Altura:'+ Transf(mparalt ,'999') +' Cm '+ Chr(10),'')
			mparimc 	= .txtimc.Value
			mnurse = mnurse + Iif(mparimc # 0, ' IMC:'+ Transf(mparimc ,'999.99') +' '+ Chr(10),'')
			mpartembuc 	= .txttempbc.Value
			mnurse = mnurse + Iif(mpartembuc # 0, ' Tª Bucal:'+ Transf(mpartembuc ,'99.9') + Chr(10),'')
			mpartemrct 	= .txttemprt.Value
			mnurse = mnurse + Iif(mpartemrct # 0, ' Tª Rectal:'+ Transf(mpartemrct ,'99.9') + Chr(10),'')
			mparpic 	= .TxtPic.Value
			mnurse = mnurse + Iif(mparpic # 0, ' Presión IC:'+ Transf(mparpic ,'999') + Chr(10),'')
			If .txtglas1.Value >0
				mnurse = mnurse + ' Glasgow:'+ Transf(.txtglas1.Value,'99')+ '/'+Transf(.txtglas2.Value,'99')+Chr(10)
			Endif
			mnconc 	= .OptConciencia.Value
			mnurse = mnurse + Iif(mnconc # 0, ' Nivel de conciencia:'+ Iif(mnconc =1," Alerta",Iif(mnconc =2," Voz",Iif(mnconc =1," Confuso",' Inconciente') ) ) + Chr(10),'')
			mcntEPOC = .cntEPOC.visible
		Endwith


		mnurse = Iif(!Empty(mnurse), 'C.S.V. ' + Chr(10) + mnurse,'')
		If !Empty(mnurse)
			mobs = mnurse
			mret = SQLExec(mcon1, "insert into TabIntEvolParcial " + ;
				"(EIP_evol , EIP_fechaH , EIP_idevol , EIP_tipoEvol , EIP_tipoUsuario , EIP_usuario  )"+;
				" values "+;
				" (?mobs,?mfechahora,?midevol,'V', 2, ?midusuario )" )
			If mret < 0
				Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
					"AVISE A SISTEMAS",16, "ERROR")
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif
		Endif
		mnurse = ''
		mnursered = ''


	Endif


	With mopage3
		If !Empty(.Txtedcuidados.Value)
			mnurse = mnurse + Alltrim(.Txtedcuidados.Value)+ Chr(10)
		Endif
		If !Empty(mnurse)
			mobs = mnurse
			mret = SQLExec(mcon1, "insert into TabIntEvolParcial " + ;
				"(EIP_evol , EIP_fechaH , EIP_idevol , EIP_tipoEvol , EIP_tipoUsuario , EIP_usuario  )"+;
				" values "+;
				" (?mobs,?mfechahora,?midevol,'C', 2, ?midusuario )" )
			If mret < 0
				Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
					"AVISE A SISTEMAS",16, "ERROR")
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif
		Endif
		mnurse = ''
		mnursered = ''
		If !Empty(.txtedmedica.Value)
			mnurse = mnurse + Alltrim(.txtedmedica.Value)+ Chr(10)
		Endif
		If !Empty(mnurse)
			mobs = mnurse
			mret = SQLExec(mcon1, "insert into TabIntEvolParcial " + ;
				"(EIP_evol , EIP_fechaH , EIP_idevol , EIP_tipoEvol , EIP_tipoUsuario , EIP_usuario  )"+;
				" values "+;
				" (?mobs,?mfechahora,?midevol,'M', 2, ?midusuario )" )
			If mret < 0
				Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
					"AVISE A SISTEMAS",16, "ERROR")
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif
		Endif
		mnurse = ''
		mnursered = ''

		Select mwknece.valorb ,mwknece.valorf,mwknece.valorc,mwknece.nnc_descrip As cuidado ,mwknece.nnc_padre,;
			mwkfrecuencia.Descrip,mwknecespacorig.nnc_descrip As necesidad ;
			from mwknece Left Join mwkfrecuencia On estado = mwknece.valorf ;
			INNER Join mwknecespacorig On mwknecespacorig.Id = mwknece.nnc_padre;
			where mwknece.valorb <> mwknece.valorbOrig Or mwknece.valorf <> mwknece.valorfOrig ;
			or Alltrim(mwknece.valorc) <> Alltrim(mwknece.valorcOrig);
			into Cursor mwknecepac
		Select mwknecepac
*!*			mnurse = mnurse + iif(reccount('mwknecepac')>0 ,'NECESIDADES Y CUIDADOS ' + chr(10) ,'')
*!*			mpadre = 0
*!*			scan
*!*				if mpadre #nnc_padre
*!*					mnurse = mnurse + '---- ' + mwknecepac.necesidad + chr(10)
*!*					mpadre = mwknecepac.nnc_padre
*!*				endif
*!*				mnurse = mnurse +alltrim(cuidado )+" - "+ iif(valorb , "SI","NO")+ ;
*!*					iif(!empty(descrip)," Frecuencia: "+alltrim(descrip),'')+ iif(!empty(valorc)," Observ.: "+ alltrim(valorc),'')+chr(10)
*!*			endscan
*!*			mnurse = mnurse + iif(reccount('mwknecepac')>0 ,'- - - - - ' + chr(10) ,'')
*!*				minurse = .TxteditEvol.value
*!*				mnurse = mnurse &&+ iif(!empty(minurse ), minurse + chr(10),'')
	Endwith

Endif
If musua > 0  && Planilla enfermeria
	msoloevol = Iif(!Empty(Alltrim(mopage3.TxteditEvol.Value )), ;
		alltrim(mopage3.TxteditEvol.Value ) +Chr(10),'') + Alltrim(mnurse)
	miedit = Iif(!Empty(Alltrim(mopage3.TxteditEvol.Value + mnurse )), Ttoc(mfechahora ) + ' ' +;
		iif(Used('mwkusuarios'),Alltrim(mwkusuarios.idusuario) ,Transf(musua))+ '->', '') + ;
		iif(!Empty(Alltrim(mopage3.TxteditEvol.Value )), ;
		alltrim(mopage3.TxteditEvol.Value) + Chr(10),'')+ Alltrim(mnurse)
	mevolnurse 	=  Iif(!Empty(Alltrim(mopage3.TxteditEvol.Value)),Chr(10),'') + miedit
Else
	miedit = Alltrim(mopage3.TxteditEvol.Value) + Alltrim(mindnurse )
	mevolnurse 	= Alltrim(mopage3.txtedtevol.Value)
Endif
If !Empty(msoloevol )
	mobs = msoloevol
	mret = SQLExec(mcon1, "insert into TabIntEvolParcial " + ;
		"(EIP_evol , EIP_fechaH , EIP_idevol , EIP_tipoEvol , EIP_tipoUsuario , EIP_usuario  )"+;
		" values "+;
		" (?mobs,?mfechahora,?midevol,'E', 2, ?midusuario )" )
	If mret < 0
		Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
			"AVISE A SISTEMAS",16, "ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif
Endif
mnurse = ''
mnursered = ''


mret = SQLExec(mcon1, "SELECT * FROM TabIntEvol " + ;
	" where  EI_idevol = ?midevol ", "mwkVerEvol")
If mret < 0
	=Aerr(eros)
	Messagebox(eros(3), 48, "Validacion")
Endif

midintevol = mwkVerEvol.Id
mevolnursea = Nvl(EI_evolnurse,'')
mevolnursett = mevolnurse + Iif(Empty(mevolnurse),'',Chr(10))+  Alltrim(mevolnursea)
*!*	mret = sqlexec(mcon1, "update tabintevol " + ;
*!*		" set  EI_evolnurse = ?mevolnursett "+;
*!*		" where id = ?midintevol " )
*!*	if mret < 0
*!*		messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
*!*			"AVISE A SISTEMAS",16, "ERROR")
*!*		do log_errores with error(), message(), message(1), program(), lineno()
*!*	endif


If mlmodifevoln
	If Used('mwkcuiconfcui')
		Select * From mwkcuiconfcui  Into Cursor mwkcuiconf
		If Reccount('mwkcuiconf')>0
			Do sp_grabo_evol_int_cuiconf With midevol,'',1
		Endif
	Endif
	If Used('mwkcuiconfmed')
		Select * From mwkcuiconfmed Into Cursor mwkcuiconf
		If Reccount('mwkcuiconf')>0
			Do sp_grabo_evol_int_cuimed With midevol,'',1
		Endif
	Endif
	If myip='172.16.1.7'
		Set Step On
	Endif
	If Used('mwkcuiconfmedHH')
		Select * From mwkcuiconfmedhh Into Cursor mwkcuiconf
		If Reccount('mwkcuiconf')>0
			Do sp_grabo_evol_int_cuimed_hora With midevol,'',1
		Endif
	Endif
	If Used('mwkcuiconfsue')
		Select * From mwkcuiconfsue Into Cursor mwkcuiconf
		If Reccount('mwkcuiconf')>0
			Do sp_grabo_evol_int_cuimed With midevol,'',1
		Endif
	Endif

*!*		mret = sqlexec(mcon1, "insert into tabintevolNurse " + ;
*!*			" (EIn_codcienanda , EIn_evolnurse , EIn_fechah , EIN_idevol , EIn_usuario ) values "+;
*!*			" (1, ?msoloevol,?mfechahora , ?midevol ,?midusuario   )" )
*!*		if mret < 0
*!*			messagebox("ERROR EN LA ACTUALIZACION"+chr(10)+;
*!*				"AVISE A SISTEMAS",16, "ERROR")
*!*			do log_errores with error(), message(), message(1), program(), lineno()
*!*		endif
	With mopage1
		If .opt1.Value>0
			mobs = .TxteditEvol.Value
			mvalor = .txtpuntos.Value
			mret = SQLExec(mcon1, "insert into TabIntScorNur " + ;
				"(EIS_fechaH ,EIS_idevol ,EIS_observacion , EIS_tiposcore ,EIS_usuario ,EIS_valor )"+;
				" values "+;
				" (?mfechahora,?midevol, ?mobs, 21, ?midusuario, ?mvalor )" )
			If mret < 0
				Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
					"AVISE A SISTEMAS",16, "ERROR")
				Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
			Endif
		Endif
	Endwith
	If mopage5.SCORES_PED_NUR1.Visible
		With mopage5.SCORES_PED_NUR1.pgescalas
			For npe = 1 To 5
				mpage = ".page"+Transform(npe)
				With &mpage
					mtipo = Val(.Comment)
					If .opt1.Value>0 And mtipo>0
						mobs = .TxteditEvol.Value
						mvalor = .txtpuntos.Value
						mret = SQLExec(mcon1, "insert into TabIntScorNur " + ;
							"(EIS_fechaH ,EIS_idevol ,EIS_observacion , EIS_tiposcore ,EIS_usuario ,EIS_valor )"+;
							" values "+;
							" (?mfechahora,?midevol, ?mobs, ?mtipo, ?midusuario, ?mvalor )" )
						If mret < 0
							Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
								"AVISE A SISTEMAS",16, "ERROR")
							Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
						Endif
					Endif
				Endwith
			Next npe
		Endwith
	Endif
	If mopage5.scores_neo1.Visible
		With mopage5.scores_neo1.pgescalas
			For npe = 1 To 5
				mpage = ".page"+Transform(npe)
				With &mpage
					mtipo = Val(.Comment)
					If .opt1.Value>0 And mtipo>0
						mobs = .TxteditEvol.Value
						mvalor = .txtpuntos.Value
						mret = SQLExec(mcon1, "insert into TabIntScorNur " + ;
							"(EIS_fechaH ,EIS_idevol ,EIS_observacion , EIS_tiposcore ,EIS_usuario ,EIS_valor )"+;
							" values "+;
							" (?mfechahora,?midevol, ?mobs, ?mtipo, ?midusuario, ?mvalor )" )
						If mret < 0
							Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
								"AVISE A SISTEMAS",16, "ERROR")
							Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
						Endif
					Endif
				Endwith
			Next npe
		Endwith
	Endif
	With mopage5.pgescalas
		For npe = 1 To 10

			mpage = ".page"+Transform(npe)
			With &mpage
				mtipo = Val(.Comment)
				If mtipo>0
					If .opt1.Value>0
						mobs = .TxteditEvol.Value
						mvalor = .txtpuntos.Value
						mret = SQLExec(mcon1, "insert into TabIntScorNur " + ;
							"(EIS_fechaH ,EIS_idevol ,EIS_observacion , EIS_tiposcore ,EIS_usuario ,EIS_valor )"+;
							" values "+;
							" (?mfechahora,?midevol, ?mobs, ?mtipo, ?midusuario, ?mvalor )" )
						If mret < 0
							Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
								"AVISE A SISTEMAS",16, "ERROR")
							Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
						Endif
					Endif
				Else
					If .txtpuntos.Value <11 And mtipo= 0
						mobs = .TxteditEvol.Value
						mvalor = .txtpuntos.Value
						mret = SQLExec(mcon1, "insert into TabIntScorNur " + ;
							"(EIS_fechaH ,EIS_idevol ,EIS_observacion , EIS_tiposcore ,EIS_usuario ,EIS_valor )"+;
							" values "+;
							" (?mfechahora,?midevol, ?mobs, 6, ?midusuario, ?mvalor )" )
						If mret < 0
							Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
								"AVISE A SISTEMAS",16, "ERROR")
							Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
						Endif
					Endif
				Endif
			Endwith
		Next npe
	Endwith

Endif
nSet=SQLSetprop(mcon1, "displogin", 3 )

If mlcambiocsv

	mret = SQLExec(mcon1, "insert into TabIntCSV" + ;
		" (ESV_fechah ,ESV_hora ,ESV_parfrecard , ESV_parfreresp , ESV_pargluc ,ESV_parpic ," + ;
		"ESV_parpeso , ESV_parsatur , ESV_partemaxl , ESV_partembuc , ESV_partemrct , " + ;
		"ESV_partensdia , ESV_partenssis , ESV_parTensAM, ESV_idevol, ESV_usuario,ESV_parAltura, ESV_parGlucCorr   "+;
		",ESV_parNivCon  ) values "+;
		" (?mfechahora , ?mhoratoma,?mparfrecard,?mparfreresp , ?mpargluc , " +;
		" ?mparpic  , ?mparpeso , ?mparsatur , ?mpartemaxl , ?mpartembuc , ?mpartemrct ,"+;
		" ?mpartensdia , ?mpartenssis , ?mpartam,?midevol,?midusuario ,?mparalt,?mparcorgluc ,?mnconc )" )

	If mret < 0
		Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
			"AVISE A SISTEMAS",16, "ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif
	miescore = prg_calcula_news(mparfreresp ,mparsatur ,mpartemaxl ,mpartenssis ,mparfrecard,mnconc,1,mnO2Aux,mcntEPOC  )
	mlobs = prg_calcula_news(mparfreresp ,mparsatur ,mpartemaxl ,mpartenssis ,mparfrecard,mnconc,2,mnO2Aux,mcntEPOC  )
	mlobs = Iif(miescore >=5,'',mlobs )
	 
	If miescore>=0
		mhora = Hour(mfechahora )*100+Minute(mfechahora )
		mfechahora = Ctot(Dtoc(mfechadia- Iif(mhoratoma>mhora,1,0) )+" "+ Transform(mhoratoma,"@L 99:99"))
		mvalor = miescore &&+ Iif(lnARM = 1, 2, 0)
		mret = SQLExec(mcon1, "insert into TabIntScorNur " + ;
			"(EIS_fechaH ,EIS_idevol ,EIS_observacion , EIS_tiposcore ,EIS_usuario ,EIS_valor )"+;
			" values "+;
			" (?mfechahora,?midevol, ?mlobs, 13, ?midusuario, ?mvalor )" )
		If mret < 0
			Messagebox("ERROR EN LA ACTUALIZACION"+Chr(10)+;
				"AVISE A SISTEMAS",16, "ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Endif
	Endif
Endif

Use In Select('mwkVerEvol')
Use In Select('mwknecepac')
