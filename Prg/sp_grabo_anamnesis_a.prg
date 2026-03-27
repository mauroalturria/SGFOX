****
** Grabo anamnesis del paciente
****

parameter mnroreg,ctexto

mfecha = sp_busco_fecha_srv2('DT')
mret = sqlexec(mcon1, "insert into TabNutHpac (TNH_registracio,TNH_fecha,TNH_anamnesis) " + ;
	" values ( ?mnroreg, ?mfecha ,?ctexto) " )

if mret<1
	=aerr(eros)
	messagebox (eros(2))
endif