*
* Localiza Vale VP Finalizado / Conformado
*
Lparameters mvale

Use In Select("mwkvalent")

mret = SQLExec(mcon1,"select TVE_IdPre,TVE_Vale, TVE_insumocodigo,insumos.INS_descriinsumo,"+;
	"TVE_Soli ,TVE_Entrega,TVE_TipoEnt,TVE_Sector,TVE_ObsItem,TVC_Estado"+;
	" from TabFarmVPDetEnt "+;
	" join insumos on INS_codinsumo = TVE_insumocodigo"+;
	" join TabFarmVPCabe on TabFarmVPCabe.Id = TVE_IdPre"+;
	" where TVE_Vale = ?mvale","mwkvalent")

If mret < 0
	mltabla = "TABLA VP DETALLE CANTIDADES ENTREGADAS"
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.






