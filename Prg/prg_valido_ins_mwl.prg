*!*	clear
*!*	*!*	prg_valido_ins_mwl
*!*	Set Date FRENCH
*!*	Public mcon1
*!*	mcon1 = Sqlconnect("172.16.1.246")

Lparameters lnFunc, ltDia, lbValFer, lbValNoMach, lnservicio

*!*	*!*	--------------------------------------------------------

*!*	*!*	th_tipodia = 1 && dias L-V 
*!*	*!*	th_tipodia = 2 && dia Sabado
*!*	*!*	th_tipodia = 3 && 1/2 feriado
*!*	*!*	th_tipodia = 4 && todos
*!*	*!*	th_tipodia = 5 && domingos

*!*	*!*	&& valores para prueba
*!*	lbValFer = .t.
*!*	lbValNoMach = .f.
*!*	lnFunc = 1

*!*	*!*	mdmasx = Datetime()
*!*	mdmasx = Ctot("14/09/2011 21:00:00") && MIERCOLES FIN DE HORA
*!*	mdmasx = Ctot("14/09/2011 22:00:00") && MIERCOLES DESPUES DE HORA
*!*	mdmasx = Ctot("18/09/2011 17:00:00") && DOMINGO
*!*	mdmasx = Ctot("10/10/2011 12:00:00") && FERIADO
*!*	mdmasx = Ctot("24/12/2009 12:00:00") && 1/2 FERIADO
*!*	*!*	--------------------------------------------------------

lcCentury = Set("Century")
lcHours = Set("Hours")
Set Century on
Set Hours To 24

Private mdmasx
Local lbResu, lndow, lcTime, lnTime, mdmasx_aux 
lbResu = .f.

mdmasx = ltDia
lndow  = dow(Ttod(mdmasx))
lcTime = Substr(Ttoc(mdmasx),12,5)
lnTime = Val(Strtran(lcTime,":",""))
mdmasx_aux = mdmasx

Do While .t.

*!*	----------------------------------------------------------------
	Do sp_busco_feriado  && MWKFeriados

	If Reccount("MWKFeriados") > 0 && FERIADO
*!*			?"Feriado"
		lbResu = lbValFer
		Exit 
	Endif 
*!*	----------------------------------------------------------------
	mdmasx = Ttod(mdmasx) + 1
	Do sp_busco_feriado With " AND MOTIVO IN (1,8,10)" && MWKFeriados

	lbMedioFeriado = .f.
	If Reccount("MWKFeriados") > 0
		lbMedioFeriado = .t.
	Endif
	Use In Select("MWKFeriados") 
	mdmasx = mdmasx_aux
*!*	----------------------------------------------------------------
	If vartype(lnservicio)="N"
		lcWhere = " Where th_codserv = " + Transform(lnservicio)
	Else
		lcWhere = " Where Th_funcion = " + Transform(lnFunc) 
	Endif 	
*	lcWhere = " Where Th_funcion = " + Transform(lnFunc) + iif(vartype(lnservicio)="N", " and th_codserv="+transf(lnservicio),"")
*	lcWhere = " Where Th_funcion = " + Transform(lnFunc) + iif(vartype(lnservicio)="N", " and th_codserv="+transf(lnservicio),"")

*---	lcWhere = " Where Th_funcion = " + Transform(lnFunc) + iif(vartype(lnservicio)="N", " and th_codserv="+transf(lnservicio),"")
	*lcWhere = " Where Th_funcion = " + Transform(lnFunc) + iif(vartype(lnservicio)="N", " and th_codserv="+transf(lnservicio),"")
	Do sp_busco_horarios_run With lcWhere, "mwkHorario"
	
	&& seteo default para el acumulativo
	lbSel = .f.
	If Reccount("mwkHorario")> 0
		lbResu = .T. && ES SOLO PARA HACER EL AND
	Else 	
		lbResu = lbValNoMach
		Exit 
	Endif 	
	
	Select mwkHorario
	Scan All
	
		lnValDesde = Val(Strtran(Substr(ttoc(mwkHorario.Th_HoraDesde),12,5),":",""))
		lnValHasta = Val(Strtran(Substr(ttoc(mwkHorario.Th_HoraHasta),12,5),":",""))
		
		Do Case 
			Case th_tipodia = 0
			&& TODOS LOS DIAS CON HORARIO
				If lnTime >= lnValDesde And lnTime <= lnValHasta 
					lbResu = lbResu and mwkHorario.Th_Ejecuta
					lbSel = .t.
				Endif 
			Case th_tipodia = 1 And Inlist(lndow,2,3,4,5,6) And Not lbMedioFeriado  && Lun a Vier
				&& CONTROLO LA HORA 
				If lnTime >= lnValDesde And lnTime <= lnValHasta 
					lbResu = lbResu and mwkHorario.Th_Ejecuta
					lbSel = .t.
				Endif 
				
			Case th_tipodia = 2 And Inlist(lndow,7) And Not lbMedioFeriado  && Sabados
				&& CONTROLO LA HORA 
				If lnTime >= lnValDesde  And lnTime <= lnValHasta 
					lbResu = lbResu and mwkHorario.Th_Ejecuta
					lbSel = .t.
				Endif 
			
			Case th_tipodia = 3 And lbMedioFeriado && 1/2 feriados
			&& SI ES EL DIA CONTROLO LA HORA
				If lnTime >= lnValDesde  And lnTime <= lnValHasta 
					lbResu = lbResu and mwkHorario.Th_Ejecuta
					lbSel = .t.
				Endif 

			Case th_tipodia = 4  
			&& EJECUTA O NO ....... NO CONTROLO NADA
				lbResu = lbResu and mwkHorario.Th_Ejecuta
				lbSel = .t.

			Case th_tipodia = 5 And Inlist(lndow,1) && domingo
					lbResu = lbResu and mwkHorario.Th_Ejecuta
					lbSel = .t.

			Endcase 		
		Select mwkHorario
	Endscan 	

	If Not lbSel
		lbResu = lbValNoMach
	Endif 
	
	Exit
Enddo

Use In Select("mwkHorario")
Use In Select("MWKFeriados") 

Set Century &lcCentury
Set Hours To &lcHours 
*!*	?mdmasx 
*!*	?lbResu
Return (lbResu)
*!*	--------------------------------------------------------
*!*	Sqldisconnect(mcon1)



