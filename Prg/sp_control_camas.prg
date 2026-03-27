****
** Controlo que la cama haya sido procesada correctamente
****

parameter mcodsec, mhabitsala, mcama, mpaci, mque

select mwkusuario
go top
midusua     = mwkusuario.idusuario
mret = sqlexec(mcon1, "select hab_sectores, hab_codhabitacion, hab_codcama" + ;
	", hab_codpaciente , hab_codbloqueo, hab_habilitada " +;
	"from habitacions " +;
	"where hab_sectores = ?mcodsec " + ;
	" and hab_codhabitacion = ?mhabitsala" + ;
	" and hab_codcama = ?mcama" , "mwkctrcama")
do case
	case mque = "R"
		if alltrim( mwkctrcama.hab_codpaciente ) # 'RESERV'
			do sp_insert_tabctrlerr with "Sector: " + mcodsec + " Habit: " + mhabitsala +;
				" cama: " + mcama + " Pac:" + mpaci + " Registro:" + mwkctrcama.hab_codpaciente ;
				, "", midusua, "Reserva"

		endif
	case mque = "L"
		if val(mwkctrcama.hab_codpaciente ) # 0
			do sp_insert_tabctrlerr with "Sector: " + mcodsec + " Habit: " + mhabitsala +;
				" cama: " + mcama + " Pac:" + mpaci + " Registro:" + mwkctrcama.hab_codpaciente ;
				, "" , midusua, "Libera"
		endif
	case mque = "I"
		if alltrim( mwkctrcama.hab_codpaciente ) # alltrim(mpaci)
			do sp_insert_tabctrlerr with "Sector: " + mcodsec + " Habit: " + mhabitsala +;
				" cama: " + mcama + " Pac:" + mpaci + " Registro:" + mwkctrcama.hab_codpaciente ;
				, "", midusua, "Interna"
		endif

endcase
if used('mwkctrcama')
	select mwkctrcama
	use
endif