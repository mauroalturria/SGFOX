Lparameters mCodAdm

misql = "select   pp_admision, pp_frecuencia, pp_insumo,  ins_descriinsumo "+;
" from tabintpmplan  "+;
"  inner join insumos on pp_insumo = ins_codinsumo "+;
"  where pp_admision = ?mCodAdm  and  pp_fecpasiva ='1900-01-01'  "+;
"   and pp_frecuencia = 'Para Alta'  "


mret = SQLExec(mcon1,misql  ,"mwkmedpen")

If mret =< 0
	Messagebox("ERROR DE LECTURA DE OBS. VALE",48,"VALIDACION")
	Return .F.
Endif

Return Reccount("mwkmedpen")

