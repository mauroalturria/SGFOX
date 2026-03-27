Lparameters mcod,mfei,mfee,midl
mret = sqlexec(mcon3,"insert into TTCodigos (Codigo,FechaAlta,FechaBaja,IdLegajo) "+;
	"values (?mcod,?mfei,?mfee,?midl)")
If mret <= 0
	mrespup = .t.
Endif
Return mrespup
