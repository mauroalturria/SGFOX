***
** Grabo presupuesto
****
lparameters mpaciente, msectorsol, mcondPago, mNroAfiliado, mEntidad,mobservaciones,mEstadoActual,midmodulo,;
	mValorMod,mvalorTotal,mfechaAutoPres,mUsuario,mid,mpapel,mfechaAcep
mobserv1 = LEFT(mobservaciones,250)
mobserv2 = substr(mobservaciones,251,250)

mfecHoraDia  = ttoc(sp_busco_fecha_serv('DT'))
mplantilla  = alltrim(sys(0)) + alltrim(mfecHoraDia)
mfechaAutoPres = sp_busco_fecha_serv('DT')
mfechasolic =  sp_busco_fecha_serv('DD')

mret = sqlexec(mcon1, "UPDATE tabpresupuestos SET EstadoActual = ?mEstadoActual,"+;
	"estado = ?mpapel,fechaAutopres = ?mfechaAutoPres where id = ?mid ")
mret = sqlexec(mcon1, "insert into TabpAuditoria (paciente, sectorsol, condPago, NroAfiliado, Entidad,"+;
	"observaciones, plantilla,fechasolic,fechaAutoPres,EstadoActual,idmodulo,ValorMod,valorTotal,Usuario,IdPres)"+;
	" values( ?mpaciente, ?msectorsol, ?mcondPago, ?mNroAfiliado, ?mEntidad,?mobserv1 , ?mplantilla "+;
	",?mfechasolic,?mfechaAutoPres,?mEstadoActual,?midmodulo,?mValorMod,?mvalorTotal,?mUsuario,?mId)")

if mret <1
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif


