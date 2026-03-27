*
* Legales busqueda en maestro Gral, según tipo
*

mret = sqlexec(mcon1,"select TabLGDema.Id as TLG_idema,TLD_freclamo,TLD_nroregistrac,TLD_idHecho,TLD_idAsegura,TLD_idEstado,"+;
	" REG_nombrepac,REG_numdocumento, TLD_actor"+;
	" from TabLGDEma,registracio"+;
	" where TLD_nroregistrac=REG_nroregistrac","mwklegales")	
If mret > 0
	msql = "Select mwklegales.TLG_idema as orden,transform(left(dtoc(TLD_freclamo),7),'9999/99') as reclamo,"+;
		"REG_nombrepac as nombre,REG_numdocumento as documento,"+;
		"mwkHechosg.TLH_descrip as hecho,mwkAsegura.descrip as seguro,mwkEstado.descrip as lestado,TLD_actor as lactor,"+;
		"TLD_nroregistrac,TLD_idHecho,TLD_idAsegura,TLD_idEstado "+;
		"from mwklegales,mwkEstado,mwkAsegura,mwkHechosg "+;
		"where "+;
		"mwklegales.TLD_idHecho = mwkHechosg.TLH_idcod and "+;
		"mwklegales.TLD_idAsegura = mwkAsegura.Subestado and "+;
		"mwklegales.TLD_idEstado = mwkEstado.Subestado"+;
		" order by mwklegales.TLG_idema into cursor mwklegales"
	&msql
Else
	Messagebox("EN BUSQUEDA DE NOMBRE DEL PACIENTE",16,"ERROR")
Endif
