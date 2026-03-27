****
** busco prestaciones para indicaciones
****

mfecnul = ctod("01/01/1900")

mfecdia = sp_busco_fecha_serv('DD')
mfechanull  = "1900-01-01 00:00:00"

mret = sqlexec(mcon1, "select TND_codPrest,TNP_codadmision " + ;
	" from TabNutPaciente "+;
	" inner join pacinternad on TabNutPaciente.TNP_codadmision = pacinternad.pin_codadmision " + ;
	" inner join TabNutDetalle on TabNutDetalle .TND_idPaciente = TabNutPaciente.id" + ;
	" where TNP_Fecha = ?mfecdia and TNP_CodServ = 0 and TND_fecBaja= ?mfechanull  "+;
	" ", "mwknutped")

mret = sqlexec(mcon1,"select PRE_descriprest, PRE_codprest,pre_alimenticio,Tabnutprest.TNP_Dieta " + ;
	" FROM prestacions "+;
	" left join TabNutPrest on prestacions.PRE_codprest = TabNutPrest.TNP_codPrest " + ;
	" where TNP_dieta < 6 and PRE_codservicio=9400  and PRE_fechapasiva is null "+;
	" order by PRE_descriprest " , "mwkpresta")

if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif

