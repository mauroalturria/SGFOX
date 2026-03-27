***********
*  busca los componentes todos o los que correspondan al tipo indicado
*********
PARAMETERS mtipocomp  

lcWhere = IIF(EMPTY(mtipocomp),''," where tipocomp =?mtipocomp ")
mret =	sqlexec(mcon1,"select id,descr,stock,tipocomp->descr as tipocomp "+;
	"from tabStcomponente " +;
	+lcwhere +" order by descr  ","mwkcomponente")
if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif
