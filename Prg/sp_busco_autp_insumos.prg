********
* busca los insumos ya cargados en autorizaciones
********

mret = sqlexec(mcon1, "SELECT APV_CodInsuSolic->INS_descriinsumo,APV_CodInsuSolic,"+;
	"APV_PresInsu  FROM autprevias where  APV_CodInsuSolic is not null  "+;
	"group by APV_CodInsuSolic ","mwkInsumos")

if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
