parameters tnidobito,tnuser,tnestado,tdfecha,tcobserv,tNumSector,tCodAdmision,tCama,tHabitacion,tCategoria
if vartype(tcobserv) # 'C'
	tcobserv = ''
endif

** 20/08/2015
** Agregue tnestado=4 para liberar la cama, en el caso que la enfermera/administracion/admision asi lo hagan.
**If tnestado = 3 Or tnestado = 4 OR tnestado = 12  &&Cama Desocupada. Liberamos la cama para que Admision la pueda usar.

** If INLIST(tnEstado,4,11)
*!*	if .t. = .f.

*!*	**D ACTCAMA^RTN005(1,Sec,HAB,CAMA,CATEG,"L",NROADM, OPERADOR)

*!*	** Primero verificamos si efectivamente esta desocupada esta cama.
*!*		mret = sqlexec(mcon1,"select * from habitacions where hab_codhabitacion = ?tHabitacion and hab_codcama = ?tCama","mwkHabCama")

*!*		if mret < 1
*!*			messagebox("ERROR AL CONSULTAR HABITACIONS.",64,"SISTEMAS")
*!*			do Log_errores with error(), message(), message(1)
*!*			return .f.
*!*		endif

*!*		select mwkHabCama
*!*		go top

*!*		if mwkHabCama.hab_codpaciente = tCodAdmision

*!*	* SEC C(3) := Código del Sector
*!*	* HAB VARCHAR(4) := Habitación
*!*	* CAMA C(2) := Cama
*!*	* CATEG C(1) := Categoría de ubicación del paciente en la habitación:
*!*	* "C" -> Compartida
*!*	* "I" -> Individual
*!*	* "E" -> Especial
*!*	* "A" -> Aislación
*!*	* NROADM C(8) := DDDDDD-D    nro.admisión del paciente
*!*	* OPERADOR N(6,0) := Operador de la Actualizacion (Opcional)

*!*	* devuelve :
*!*	* P0 := Status: "" -> Ok ó String Codigos Error
*!*			.olevism.mserver 	= allt(mwktabcfg.oleserver)
*!*	*	.olevism.namespace	= "DESA_RUTINAS"
*!*			.olevism.namespace	= allt(mwktabcfg.olespaces)		&&"TABLAS"

*!*			mgraba	= '1'
*!*			msector	= allt(tNumSector)
*!*			mhabita = allt(tHabitacion)
*!*			mcama	= alltrim(tCama)
*!*			mcate	= alltrim(tCategoria)
*!*			maccion = 'L'
*!*			mnroad  = alltrim(tCodAdmision)
*!*			mcodvax = allt(str(mwkusuario.codigovax))
*!*	**mcodblq = Allt(Str(.CboBloqueo.Value))

*!*			.olevism.code = "D ACTCAMA^RTN005(" + mgraba  + ',"'  + msector + '","' + ;
*!*				mhabita + '","'  + mcama  + '","' + mcate   + '","' + ;
*!*				maccion + '","'  + mnroad + '","'  + mcodvax + '")'

*!*			.olevism.execflag = 1

*!*			mmsgerr = .olevism.errorname

*!*			if !empty(mmsgerr)

*!*				select mwkusuario
*!*				go top
*!*				midusua     = mwkusuario.idusuario
*!*				do sp_insert_tabctrlerr with .olevism.code, mmsgerr , midusua, .name
*!*				messagebox ("ERROR EN LA GRABACION. AVISAR A SISTEMAS  U R G E N T E  !!!", 48, 'Validacion')

*!*			else

*!*				mok	= .olevism.p0	&& Codigo de error
*!*				if .olevism.p0 <> ''
*!*					mcoderr = round(val(.olevism.p0), 0)
*!*					do sp_busco_texto_error with mcoderr
*!*					mcoderr = mcoderr + 4000
*!*					messagebox(alltrim(mwktaberror.textoerror), 48, 'Validacion')
*!*					mfecha  = sp_busco_fecha_serv('DT')
*!*					mret = sqlexec(mcon1, "insert into TabVerC (codadmision,control,fecha,prg, usuario, habcama) values "+;
*!*						" ( ?mcodadmision,2,?mfecha,?mcoderr, ?midusua, ?mhabcama )	")
*!*					.olevism.mserver = ""
*!*					return

*!*				else

*!*	*!*	** -------Inserto el nuevo estado ------
*!*	*!*				mret = SQLExec(mcon1,"INSERT INTO tabpacobitoalta (POA_Idpacob,POA_Usuario,POA_Observacion,POA_Estado,POA_Vigente,POA_FechaModi) " +;
*!*	*!*					" VALUES (?tnidobito,?tnuser,?tcobserv,?tnestado,1,?tdfecha)")

*!*	*!*				If mret < 1
*!*	*!*	*=Aerror(eros)
*!*	*!*	*Messagebox(eros(3))
*!*	*!*					Messagebox("ERROR AL GRABAR DATOS, INTENTE NUEVAMENTE",64,"SISTEMAS")
*!*	*!*					Do Log_errores With Error(), Message(), Message(1)
*!*	*!*					Return .F.
*!*	*!*				Endif

*!*				endif

*!*			endif

*!*		endif

*!*	endif

** Marcelo Torres, 20/08/2019
** Verificamos si existe un estado similar, con otro
mret = SQLExec(mcon1,"select * from TabAltaPac " +;
	"where POA_habitacion = ?tHabitacion and POA_CAMA = ?tCama and POA_estado = 11 and poa_vigente = 1 ","mwkAltaPac")

If mret < 1
	Messagebox("ERROR AL CONSULTAR DATOS DE TABLA TABALTAPAC.",64,"SISTEMAS")
	Do Log_errores With Error(), Message(), Message(1)
	Return .F.
Endif

Select mwkAltaPac
Go Top

If Reccount() > 0

** Primero cancelamos el estado encontrado. Estado similar al que vamos a grabar.
	mId = mwkAltaPac.Id
	mret = SQLExec(mcon1,"update TabAltaPac set POA_estado = 99, POA_vigente = 0 " +;
		"where id = ?mId")

	If mret < 1
		Messagebox("ERROR AL GRABAR NUEVO ESTADO EN TABLA TABALTAPAC.",64,"SISTEMAS")
		Do Log_errores With Error(), Message(), Message(1)
		Return .F.
	Endif

ENDIF

** -------Inserto el nuevo estado ------
mret = sqlexec(mcon1,"INSERT INTO TabAltaPac (POA_Idpacob,POA_Usuario,POA_Observacion,POA_Estado,POA_Vigente,POA_FechaModi, POA_sector, POA_cama, POA_habitacion, POA_categoria) " +;
	" VALUES (?tnidobito,?tnuser,?tcobserv,?tnestado,1,?tdfecha,?tNumSector,?tCama,?tHabitacion,?tCategoria)")

if mret < 1
	messagebox("ERROR AL GRABAR EL NUEVO ESTADO, INTENTE NUEVAMENTE",64,"SISTEMAS")
	do Log_errores with error(), message(), message(1)
	return .f.
endif

use in select("mwkHabCama")

*!*	Parameters tnidobito,tnuser,tnestado,tdfecha,tcobserv
*!*	IF VARTYPE(tcobserv) # 'C'
*!*	tcobserv = ''
*!*	ENDIF
*!*	mret = SQLExec(mcon1,"INSERT INTO tabpacobitoalta (POA_Idpacob,POA_Usuario,POA_Observacion,POA_Estado,POA_Vigente,POA_FechaModi) " +;
*!*		" VALUES (?tnidobito,?tnuser,?tcobserv,?tnestado,1,?tdfecha)")

*!*	If mret < 1
*!*		*=Aerror(eros)
*!*		*Messagebox(eros(3))
*!*		Messagebox("ERROR AL GRABAR DATOS, INTENTE NUEVAMENTE",64,"SISTEMAS")
*!*		Do Log_errores With Error(), Message(), Message(1)
*!*		Return .F.
*!*	Endif
