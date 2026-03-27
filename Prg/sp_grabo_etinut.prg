****
** Grabo etiquetas de Nutricion
****
lparameters mabm

mfecha = sp_busco_fecha_serv('DD')
mfecnul = ctod("01/01/1900")
select mwketi
scan
	madap = upper(tnp_observaciones)
	mfec = tnp_fecha
	mserv = tnp_codserv
	mcodfact = tnp_codfact
	musu = mwkusuario.codigovax
	madm = pac_codadmision
	msector = sec_codsector

	if mabm = 1
		mret = sqlexec(mcon1, "update Tabnuteti  set TNE_Fechapasiva = ?mfecha " + ;
			"  where TNE_CodServ =?mserv  and TNE_Codadmision =?madm  and TNE_Fecha= ?mfec " )

		mret = sqlexec(mcon1, "insert into Tabnuteti (TNE_Adaptacion, TNE_CodFact, TNE_CodServ, TNE_Codadmision, TNE_Fecha,"+;
			"TNE_Fechapasiva, TNE_Usuario,TNE_CodSector) " + ;
			" values ( ?madap , ?mcodfact ,?mserv ,?madm ,?mfec ,?mfecnul ,?musu,?msector  ) " )
	else
	endif

	if mret<1
		=aerr(eros)
		messagebox (eros(2))
	endif
endscan
