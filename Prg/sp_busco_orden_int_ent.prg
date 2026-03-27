***
** busco ordenes de internaciones de entidades
***

parameter mordint, msql_ord

mret = sqlexec(mcon1, "select * from ordeninternac " + ;
	"where oricodadmision = ?mordint", "mwkordintent")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 18, "Validacion")
	do sp_desconexion with "error orden inte"
	cancel
endif
msql_ord = "select orinroorden, oricodautoriz, oritipoorden, orivigdesde"+;
	",orivigdesde+oridiasvigencia,ORIObservac,ORIDiasVigencia  from mwkordintent " + ;
	"order by orivigdesde into cursor mwkordintpac"
