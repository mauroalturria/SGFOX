*
* Actualizacion de Presupuesto ( campos EstadoActual, Observaciones )
*

Lparameters mbuscid, mnestad, mobserv 
mobserv1 = LEFT(mobserv,250)
mobserv2 = substr(mobserv,251,250)
mret = sqlexec(mcon1,"update TabPresupuestos set EstadoActual=?mnestad,"+;
	"Observaciones=?mobserv1 ,Observa2=?mobserv2 where id=?mbuscid")

If mret < 0
	Messagebox("EN ACTUALIZACION DE PRESUPUESTOS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
