*
* Consulta HDO Dispensas
*
Lparameters mdes, mhas

mf1 = Dtot(mdes)
mf2 = Dtot(mhas+1)

Use In Select("mwkhdodis")

mret = SQLExec(mcon1,"select TLD_nropof,TLD_fecinid,TLD_fecfind,TEC_nombrepac,TEC_pactivo,TLD_enfer,TLD_observa,TLD_transcod"+;
	" from TabTraLogdis"+;
	" join TabFarmEtqCitos on TabFarmEtqCitos.TEC_nropof = TabTraLogdis.TLD_nropof"+;
	" where TLD_fecinid between ?mf1 and ?mf2 order by TLD_fecinid","mwkhdodis")

If mret < 0
	MTABLA = "LOG INFORME DISPENSA HDO"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.

