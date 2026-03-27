Lparameters tnTipo, tnCodServ, tnCodPrest 

*!*	mwkPrestAdi
*!*	tnTipo = 406 
*!*	tnTipo = 0
*!*	tnCodServ = 7700
*Set Step On 
Do Case 
	Case tnTipo > 0 And tnCodServ > 0
	
		mret = Sqlexec(mcon1,"SELECT PRESTACIONS.Pre_CodPrest, PRESTACIONS.PRE_DESCRIPREST, " + ;
			"TabPrestAdi.*, " + ;
			" TabPrestAdi.Pra_Texto as Pra_Texto_Enc, " + ;
			" '' as Pra_Texto_Nor " + ;
			"FROM TabPrestAdi " + ;
			"INNER JOIN PRESTACIONS ON TabPrestAdi.PRA_CODPREST = PRESTACIONS.PRE_CODPREST " + ;
			"Where Pra_Tipo = ?tnTipo And " + ;
				"PRE_codservicio = ?tnCodServ and Pra_CodAmbito = ?mxambito AND pre_fechapasiva is null " + ;
			"Order by Pre_Descriprest asc ","mwkPrestAdi")

	Case tnTipo = 0 && todo en una misma linea
		
		If !sp_busco_estados(125, " and Tipo = 1 ","mwkEstAux")
			Return .f.
		Endif 
		lnTipoEnc = mwkEstAux.Id && 423

		If !sp_busco_estados(125, " and Tipo = 2 ","mwkEstAux")
			Return .f.
		Endif 
		lnTipoNor = mwkEstAux.Id && 424
		Use In Select("mwkEstAux")

		mret = Sqlexec(mcon1,"SELECT PRESTACIONS.Pre_CodPrest, PRESTACIONS.PRE_DESCRIPREST, " + ;
			" a.Pra_Texto as Pra_Texto_Enc, " + ;
			" b.Pra_Texto as Pra_Texto_Nor, " + ;
			"a.Id as Ida, b.Id as Idb, b.Id " + ;
			"FROM PRESTACIONS " + ;
			"Left JOIN TabPrestAdi as a ON a.PRA_CODPREST = PRESTACIONS.PRE_CODPREST and a.Pra_Tipo = ?lnTipoEnc " + ;
						" and a.Pra_CodAmbito = ?mxambito " + ;
			"Left JOIN TabPrestAdi as b ON b.PRA_CODPREST = PRESTACIONS.PRE_CODPREST and b.Pra_Tipo = ?lnTipoNor " + ;
						" and b.Pra_CodAmbito = ?mxambito " + ;			
			"Where PRE_codservicio = ?tnCodServ AND pre_fechapasiva is null " + ;
			"Having (a.Id > 0 Or b.Id > 0) " + ;
			"Order by Pre_Descriprest asc ","mwkPrestAdi")

	Case tnTipo > 0 And tnCodServ = 0  And tnCodPrest > 0  
		mret = Sqlexec(mcon1,"SELECT TabPrestAdi.* " + ;
			"FROM TabPrestAdi " + ;
			" inner join PRESTACIONS on PRA_CODPREST = PRESTACIONS.PRE_CODPREST"+;
			" Where Pra_Tipo = ?tnTipo And " + ;
				"Pra_CodPrest  = ?tnCodPrest  " + ;
				" and Pra_CodAmbito = ?mxambito AND pre_fechapasiva is null " + ;
				" ","mwkPrestAdi")


	Otherwise 
		Messagebox("LECTURA NO CONTEMPLADA",48,"VALIDACION")
		Return .F.
EndCase


If mret <= 0
=Aerror(eros)
Messagebox(eros(3))
Cancel 
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
 	Return .f.
Endif