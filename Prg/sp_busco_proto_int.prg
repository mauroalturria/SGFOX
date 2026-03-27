****
** Busqueda de Protocolo de internacion, datos basicos
****
parameter mnroadm,mfec
if vartype(mfec)#"D"
	mfec= sp_busco_fecha_serv("DT")
endif
mret = sqlexec(mcon1, "select IH_codcie,IH_fechaHoraIng, IH_horaCierre,IH_motIngreso,Tabcie10.descrip,ih_secagrup "+;
	" from TabintHCE left join tabcie10 on Tabinthce.IH_motIngreso = Tabcie10.ID "+;
	" where IH_admision = ?mnroadm order by IH_fechaHoraIng" , "mwkinterbas")
if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif

select * from mwkinterbas;
	where between(mfec,IH_fechaHoraIng, iif(IH_horaCierre=ctot("01/01/1900"),mfec,IH_horaCierre));
	order by IH_fechaHoraIng into cursor mwkinterbasico

