*
* Consulta de Insumos p/prescripcion medica
*
* mtipo : 1 && Soluciones Principales -> Volumen
*       : 2 && Agregados
*       : 3 && Isumos NO ENDONVENOSO.
*

Lparameters mcodins, mtipo

mretorno = .T.

mcodins = Alltrim(mcodins)

If Vartype(mcodins) <> "C"
	mretorno = .F.
Else

	Do Case
	Case mtipo = 1

		Use In Select("mwkValVol")
		mret = SQLExec(mcon1,"select TM_Volumen from TabMedicamentos"+;
			" join insumos on Insumos.INS_codinsumo = ?mcodins and Insumos.INS_codpuntero = TabMedicamentos.TM_Insumo","mwkValVol")

	Case mtipo = 2

		Use In Select("mwkValPot")
		mret = SQLExec(mcon1,"select a.TMD_Potencia,b.TM_presentacion,b.TM_tipo,NVL(b.TM_FecDiasAdul,0) as TM_FecDiasAdul,NVL(TM_FecDiasPed,0) as TM_FecDiasPed, " +;
		"NVL(C.INS_fechapasivo,'1900-01-01') as INS_fechapasivo, c.Ins_descriinsumo" +;
			" from TabMediDrogas as a "+;
			" left join TabMedicamentos as b on a.TMD_insumo = b.TM_insumo " +;
			" join insumos as c on c.INS_codinsumo = ?mcodins and c.INS_codpuntero = a.TMD_Insumo","mwkValPot")

	Case mtipo = 3

		Use In Select("mwkValPot")
		mret = SQLExec(mcon1,"select a.TMD_Potencia,b.TM_presentacion,b.TM_tipo,NVL(b.TM_FecDiasAdul,0) as TM_FecDiasAdul,NVL(TM_FecDiasPed,0) as TM_FecDiasPed"+;
			" from TabMediDrogas as a "+;
			" left join TabMedicamentos as b on a.TMD_insumo = b.TM_insumo " +;
			" where b.TM_insumo = ?mCodIns","mwkValPot")

	Endcase

	If mret < 0
		mltabla = "CONSULTA MEDICAMENTOS FARMACIA"
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
		Return .F.
	Endif

Endif

Return mretorno
