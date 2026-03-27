*
* Busqueda de Insumos Criterios AC
* Busqueda de Insumos Criterios REQUIERE RECETA.
*
Lparameters minsumo,nOpcion

Use In Select("mwkinsumoac")
Use In Select("mwkinsumonoac")

If Vartype(nOpcion) <> 'N'
	nOpcion = 1
Endif

Do Case
Case  nOpcion = 1    &&Requieren AC
	mret = SQLExec(mcon1,"select Agru, Criterio,INSCodPuntero, insumos.INS_descriinsumo" +;
		" from Inscriteriosolic "+;
		" join insumos on insumos.INS_codpuntero = Inscriteriosolic.INSCodPuntero and insumos.INS_codinsumo = ?minsumo"+;
		" where Agru = 29 and criterio in (9,12,13,14,16,17) group by INSCodPuntero","mwkinsumoac")
	
		mret = SQLExec(mcon1,"select 29 as  Agru,99 as Criterio,INS_CodPuntero, insumos.INS_descriinsumo " +;
			" from Zabautinsprest "+;
			" join insumos on insumos.INS_codpuntero = Zabautinsprest.AIP_CodInsu "+;
			" where AIP_fecpasiva='1900-01-01' and insumos.INS_codinsumo = ?minsumo ","mwkinsumonoac")
		If Reccount("mwkinsumonoac")>0
			Select * From mwkinsumoac Where 1=2 Into Cursor mwkinsumoac
		Endif

	
Case nOpcion = 2             &&Requieren Receta
	mret = SQLExec(mcon1,"select Agru, Criterio,INSCodPuntero, insumos.INS_descriinsumo" +;
		" from Inscriteriosolic "+;
		" join insumos on insumos.INS_codpuntero = Inscriteriosolic.INSCodPuntero and insumos.INS_codinsumo = ?minsumo"+;
		" where Agru = 29 and criterio in (10,13) group by INSCodPuntero","mwkinsumore")
Endcase

If mret < 0
	mltabla = "MAESTRO INSUMOS CRITERIOS"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
