*!*	Gustavo Fittipaldi
*!*	10/05/2012

Lparameters lcEA_evolNurse 
 
*!*	Clear

*!*	TEXT TO sqlvar TEXTMERGE NOSHOW PRETEXT 7
*!*	SELECT EA_evolNurse FROM TabAmbEvol  where id = 223 order by id desc
*!*	Endtext
*!*	Sqlexec(mcon1,sqlvar,"mwkResu")
*!*	lcEA_evolNurse  = mwkResu.EA_evolNurse 

lcTextOrig = lcEA_evolNurse 
lnPosIni = At("C.S.V.",lcTextOrig,1)+ 8
lnPosFin = At("C.S.V.",lcTextOrig,2)
If lnPosFin = 0
	lcEvolTot = Substr(lcTextOrig, lnPosIni)
Else
	lcEvolTot = Substr(lcTextOrig, lnPosIni, lnPosFin)
Endif 	

Create Cursor cBusqAux (Des c(80), tama n(2), Result c(40), ObjName c(40) )

Insert Into cBusqAux (Des, tama, ObjName ) Values (' T.Art.Sistólica mmHg:', 3, 'TxtTaSist' )
Insert Into cBusqAux (Des, tama, ObjName ) Values (' T.Art.Diastólica mmHg:', 3, 'TxtTaDia' )
Insert Into cBusqAux (Des, tama, ObjName ) Values (' Frecuencia Cardíaca (latidos x min.):', 3, 'TxtFcard' )
Insert Into cBusqAux (Des, tama, ObjName ) Values (' Frecuencia Respiratoria (respiración x min.):', 3, 'TxtFresp')
Insert Into cBusqAux (Des, tama, ObjName ) Values (' Tª Axilar (grado centigrado):', 4, 'TxtTempAx')
Insert Into cBusqAux (Des, tama, ObjName ) Values (' Tª Bucal:', 4, 'TxtTempBc')
Insert Into cBusqAux (Des, tama, ObjName ) Values (' Glucemia:', 4, 'TxtGluc')
Insert Into cBusqAux (Des, tama, ObjName ) Values (' Peso_:', 5, 'TxtPeso')
Insert Into cBusqAux (Des, tama, ObjName ) Values (' Talla:', 5, 'TxtTalla')
Insert Into cBusqAux (Des, tama, ObjName ) Values (' IMC_:', 6, 'TxtIMC')

lnPosBus = 1
lnCantCond = 0

Select cBusqAux 
Scan All For Alltrim(Des) $ lcEvolTot
	lnCantCond = lnCantCond + 1 
	
	lcTxtBIni = Trim(Des)
	lnLenIni = Len(lcTxtBIni)
	lnPosIni = At(lcTxtBIni,lcEvolTot,1) + lnLenIni
	Skip 
	If Eof()
		lcTxtBFin = Chr(10)
		lnPosBus = lnCantCond
	Else
	lcTxtBFin = Trim(Des)
	Endif 
	lnPosFin = At(lcTxtBFin, lcEvolTot,lnPosBus)
	Skip - 1

	lcResu = Substr(lcEvolTot,lnPosIni, cBusqAux.Tama)
	?lcTxtBIni + lcResu

	Select cBusqAux 
	Replace Result With lcResu
	
	Select cBusqAux 
Endscan 

Return .t.
