*
* Busqueda de prestaciones Criterios AC +VALE
*
*
Lparameters nOpcion,nxcodinsprest
If Vartype(nxcodinsprest )<>"N"
	nxcodinsprest = 0
Endif
Use In Select("mwkautinsprest")

If Vartype(nOpcion) <> 'N'
	nOpcion = 1
Endif
mbusco = ''
Do Case
Case  nOpcion = 1
	If nxcodinsprest  >0
		mbusco = ' and insumos.INS_codinsumo = ?nxcodinsprest '
	Endif
	mret = SQLExec(mcon1,"select CAST(29 as integer) as  Agru,CAST(99 as integer) as Criterio,INS_CodPuntero, insumos.INS_descriinsumo " +;
		" from Zabautinsprest "+;
		" join insumos on insumos.INS_codpuntero = Zabautinsprest.AIP_CodInsu "+;
		" where AIP_fecpasiva='1900-01-01' and AIP_PresInsu = 'I'  "+ mbusco ,"mwkautinsprest")

Case nOpcion = 2             && prestaciones
If nxcodinsprest  >0
		mbusco = ' and Prestacions.PRE_codprest = ?nxcodinsprest '
	Endif
	mret = SQLExec(mcon1,"select CAST(29 as integer) as  Agru,CAST(99 as integer) as Criterio,PRE_codprest, Prestacions.PRE_descriprest " +;
		" from Zabautinsprest "+;
		" join Prestacions on  Zabautinsprest.AIP_CodPrest = Prestacions.PRE_codprest "+;
		" where AIP_fecpasiva='1900-01-01' and AIP_PresInsu= 'P' "+ mbusco ,"mwkautinsprest")
Endcase

If mret < 0
	mltabla = "autoriza INSUMOS prestaciones "
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
