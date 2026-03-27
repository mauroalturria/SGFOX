*
* Actualizacion
*
lparameters mleg,mape,mnom,mcod,mfee,mfei,midleg,mbaja,mpin,mrep,msec

mret = sqlexec(mcon3,"update TTLegajos set "+;
	"Apellido=?mape,"+;
	"FechaIngreso=?mfei,"+;
	"Nombre=?mnom,"+;
	"pin=?mpin,"+;
	"responsable=?mrep,"+;
	"sector=?msec"+;
	" where Legajo=?mleg and FechaEgreso=?mfee")
if mret<1
	messagebox("EN ACTUALIZACION DEL LEGAJO, AVISE A SISTEMAS",16,"ERROR")
	mrespup = .t.
endif
mfecnul = ctod("01/01/1900")
mret = sqlexec(mcon3,"select id,Codigo from TTCodigos "+;
	"where IdLegajo=?midleg and FechaBaja=?mfecnul","mwkctrl")
if mbaja = 1 or mwkctrl.codigo # mcod
	mpasiva = sp_busco_fecha_serv("DD")
	mret = sqlexec(mcon3,"update TTCodigos set FechaBaja=?mpasiva "+;
		"where IdLegajo=?midleg and FechaBaja=?mfecnul")
	if mret<=0
		messagebox("EN ACTUALIZACION DEL CODIGO DE LLAMADA"+chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
		mrespup = .t.
	endif
	if mbaja # 1
		mret = sqlexec(mcon3,"insert into TTCodigos (Codigo,FechaAlta,FechaBaja,IdLegajo) "+;
			"values (?mcod,?mfei,?mfee,?midleg)")
	endif
	if mret<=0
		messagebox("EN INGRESO DEL CODIGO DE LLAMADA"+chr(10)+;
			"AVISE A SISTEMAS",16,"ERROR")
		mrespup = .t.
	endif
endif
return mrespup
