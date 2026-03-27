********
*		Busco Justificaciones de una autorizacion
********
parameters Pmid,mcursor
if vartype(mcursor)#"C"
	mcursor = "mwkprevobs"
endif
mret = sqlexec(mcon1," select * from  autprevobs "+;
	"where apo_idAutPrevias = ?Pmid and apo_Idobserva <>0 "+;
	" order by APO_IdObserva ",mcursor)

if mret<1
	=aerr(eros)
	messagebox(eros(3))

endif
