*****************
* grabar datos de la llamada al paciente por cambio de turno
***************

lparameters mfecha,mcmed,mesta,mobserv,mproto,mcusu,mestact

if  vartype(mestact)#"N"
	mestact= 0 &&& Inserto nuevo
endif

mfecha = sp_busco_fecha_serv("DT")
if mestact = 0
	mret = SQLEXEC(mcon1," insert into TabGuaMsg (TGM_Fechah, TGM_codmed, "+;
		"TGM_estado, TGM_mensaje, TGM_protocolo , TGM_usuario ) "+;
		" values(?mfecha,?mcmed,?mesta,?mobserv,?mproto,?mcusu ) ")
else
	mret = SQLEXEC(mcon1," update TabGuaMsg set TGM_estado = ?mesta "+;
		" where TGM_codmed = ?mcmed and TGM_protocolo = ?mproto and TGM_estado = ?mestact ")
endif
if mret < 0
*	messagebox("ERROR AL CREAR EL CURSOR, AVISAR A SISTEMAS", 16, "Validación")
endif

