********
* busca las prestaciones ya cargadas en autorizaciones
********
mret = sqlexec(mcon1, "SELECT APV_CodPrestSolic->PRE_descriprest,APV_CodPrestSolic,"+;
	"APV_PresInsu FROM autprevias where  APV_CodPrestSolic is not null  "+;
	"group by APV_CodPrestSolic ","mwkPrestaciones")

if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
