****
** Actualizo datos de pacientes en seguimiento
****
parameter mabm, mreg
miusu = mwkusuario.codigovax
mfecha = sp_busco_fecha_serv("DD")
mfecpas = ctod("01/01/1900")

mret = sqlexec(mcon1, "select * from Tabregadvmed "+;
	"where TRAM_registracio = ?mreg and TRAM_tipo = 0 and TRAM_fechapasiva = ?mfecpas ","mwkctrl")
do case
	case mabm = 1  &&& ingreso
		if reccount("mwkctrl")= 0
			mret = sqlexec(mcon1, "insert into Tabregadvmed "+;
				"(TRAM_codesp, TRAM_fechapasiva,TRAM_registracio,TRAM_tipo)"+;
				" values ( '',?mfecpas,?mreg, 0)")
		else
			Messagebox("ESTE PACIENTE YA ESTABA CALIFICADO COMO PAC.en SEGUIMIENTO",48,"Error, no actualiza")
		endif
	case mabm = 2    &&saca señal de auditoria
		if reccount("mwkctrl")> 0
			mret = sqlexec(mcon1, "update Tabregadvmed set TRAM_fechapasiva = ?mfecha  "+;
				" where TRAM_registracio = ?mreg AND TRAM_tipo = 0 and TRAM_fechapasiva = ?mfecpas")
		else
			Messagebox("ESTE PACIENTE YA ESTABA DADO DE BAJA",48,"Error, no actualiza")
		endif
endcase
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
endif
