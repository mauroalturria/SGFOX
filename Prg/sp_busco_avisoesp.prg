*
* Busco especalidades otros ambitos
*
parameter mbuscaesp,mbcodprest
mfecha = sp_busco_fecha_serv("DD")
if !used("mwkconfamb")
	mret = sqlexec(mcon1, "SELECT TBC_centro,TBC_concepto,TBC_valor"+;
		" from Tabconfigura where TBC_concepto in ('TELEF_CENTRO')",'mwkconfamb')
endif
mret = -1
mret = sqlexec(mcon1, "select ambito, EA_codambito,EA_codprest,EA_fecvigend from Tabespambito,TabAmbito"+;
	" where Tabambito.ID = Tabespambito.EA_codambito and "+;
	" ?mfecha >EA_fecvigend and ?mfecha <EA_fecvigenh and "+ ;
	" EA_codesp = ?mbuscaesp and EA_codprest in (0,?mbcodprest) and "+;
	" EA_codambito<>?mxambito "+;
	" order by ambito,EA_codprest ", "mwkTabAvisoEsp")

if mret < 0
	mret = sqlexec(mcon1, "select ambito,cast(1 as integer) as EA_codambito,cast(0 as integer) as EA_codprest,"+;
		"{fn convert(currENT_timestamp,SQL_timestamp)} as EA_fecvigend "+;
		"from TabAmbito where 1=2 "+;
		" order by ambito ", "mwkTabAvisoEsp")
*!*		Messagebox("EN BUSQUEDA DE AVISOS PARA ENTIDADES",16,"ERROR")
*!*		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
*!*		Return .F.
endif
select *,iif(mwkTabAvisoEsp.EA_fecvigend>ctod("01/01/1900"),"HCE ","____") as hce from mwkTabAvisoEsp,mwkconfamb ;
	where TBC_centro = EA_codambito group by EA_codambito into cursor mwkTabAvisosEsp

return .t.
