****
** busco prestaciones incluidas en un vector
****

parameter mbusca1
use in select("mwkespecag")
mret = sqlexec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
	" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")
mret = sqlexec(mcon1,"select pre_descriprest, pre_codprest,ESP_codesp,ESP_descripcion,PRE_TipoMuestra " + ;
	" FROM prestacions "+;
	" left join especialid on PRE_especialidad = ESP_codesp "+;
	" where &mbusca1 " , "mwkprestapp")

if mret<1
	=aerror(eros)
	messagebox("ERROR " + eros(3) + " EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "VALIDACION")
endif
