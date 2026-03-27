** Modulo para grabar la Reeprogramacion de turno.

LPARAMETERS mFecha,mHora,mFechaAnte,mHoraAnte,mObserva

mId = mwkHoraCitaSelec.id
mLegajo = mwkHoraCitaSelec.Legajo
mRegistracion = mwkHoraCitaSelec.Registracion
mUsuario = mwkusuario.idusuario
mFechaHoy = sp_busco_fecha_serv('DD')

mRet = SQLEXEC(mCon1,"update tabmlcita set CitaFecha = ?mFecha,CitaHora = ?mHora where ID = ?mId")

If mret < 0
   Messagebox("ERROR EN ACTUALIZACION CITA",26,"ERROR")
   Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
   Return .F.
Endif


**Grabamos el log de la modificacion.
**Campos:
**ID
**Legajo (Identidad del empleado)
**Registracion (nro. de registracion del preocupacional)
**Fecha (Dia de hoy)
**Fecha cita anterior
**Hora cita anterior
**Fecha cita nueva
**Hora cita nueva
**observacion
**Usuario

mRet = SQLEXEC(mCon1,"insert into tabmllog (tbclegajo,tbcregistracion,tbcfecha,tbcfecante," + ;
                      "tbchoraante,tbcfecnueva,tbchoranueva,tbcobservacion,tbcusuario) " + ;
                      "values(?mLegajo,?mRegistracion,?mFechaHoy,?mFechaAnte,?mHoraAnte,?mFecha,?mHora,?mObserva,?mUsuario)" )
                      
If mRet<=0
	Messagebox("ERROR AL GRABAR LOG",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif                      

RETURN .T.
