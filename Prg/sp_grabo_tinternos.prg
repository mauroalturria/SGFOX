Lparameters mfecde,mfehas,midleg,minter

mret = sqlexec(mcon3,"insert into TTInternos (FechaDesde,FechaHasta,IdLegajo,Interno) "+;
	"values (?mfecde,?mfehas,?midleg,?minter)")
If mret<=0
	Messagebox("EN INGRESO DEL INTERNO, AVISE A SISTEMAS",16,"ERROR")
	mrespup = .t.
Endif
