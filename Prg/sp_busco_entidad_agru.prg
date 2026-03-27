******************
*  Busca TODAS las entidades
******************
Lparameters mOpcion,mbusca,mcursor
If Vartype(mcursor)<>"C"
	mcursor = "mwkfentid"
Endif
Do Case
	Case  mOpcion = 1
		mret = SQLExec(mcon1,"Select ENT_codent, ENT_descrient,ENT_tipo,ENT_nroprestadorexterno,"+;
			" CAST(case when entidades.Ent_CodAgrup is null "+;
			" then entidades.ENT_codent else entidades.Ent_CodAgrup "+;
			" end as integer) as Ent_CodAgrup  , Ent_Fecpas,Ent_CodAgrup as entagrup "+;
			" from entidades " + ;
			" Order by ENT_descrient", "mwkentid")
	Case  mOpcion = 2
		mbusca = Iif(Vartype(mbusca)#"C","1=1",mbusca)
		mret = SQLExec(mcon1,"Select ENT_codent, ENT_descrient,ENT_tipo,ENT_nroprestadorexterno,"+;
			" CAST(case when entidades.Ent_CodAgrup is null "+;
			" then entidades.ENT_codent else entidades.Ent_CodAgrup end as integer)"+;
			" as Ent_CodAgrup  , Ent_Fecpas ,ent_capita,Ent_CodAgrup as entagrup  "+;
			" from entidades where " + mbusca +;
			" Order by ENT_descrient", mcursor )
Endcase

If mret < 0
	Messagebox('ERROR EN LA GENERACION DEL CURSOR, REINTENTE', 16,'Validacion')
	Aerror(err)
	Do prg_cancelo
Endif
