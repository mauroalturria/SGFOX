****
** busca las  entidades y especialidades
****
	mret = sqlexec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
				" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")

	mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient from entidades " + ;
					"where ENT_fecpas is null order by ENT_descrient", "mwkentid")
					
	mret=sqlexec(mcon1,"select ESP_codesp, ESP_descripcion FROM especialid " + ;
				   "where ESP_descripcion is not Null and ESP_genagendaturno <> 'N' " +;
				   "order by ESP_descripcion","mwkespe")


	if mret < 0
		messagebox('ERROR EN LA GENERACION DEL CURSOR, REINTENTE', 16,'Validacion')
		do prg_cancelo
	endif