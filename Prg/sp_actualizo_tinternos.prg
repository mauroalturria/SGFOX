Lparameters mfehas,midleg,minter
mret = sqlexec(mcon3,"update TTInternos set FechaHasta=?mfehas where "+;
	"IdLegajo=?midleg and Interno=?minter")
If mret<=0
	Messagebox("EN BAJA DEL INTERNO, AVISE A SISTEMAS",16,"ERROR")
	mrespup = .f.
Endif
Return mrespup
