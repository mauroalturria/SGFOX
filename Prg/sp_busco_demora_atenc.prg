Parameters mfechad,mfechah,mbusco,mcodmed,mhorad,mhorah,mEspera,mopcion,momite,demmax

*	do sp_busco_fechahoraesp with .txtFecdes.value,.txtFechas.value,mbusco,mcodmed;
*		,mhorad,mhorah,mDemora,.Optopt.value

mfiltro = Iif(mcodmed = 0,''," and codmed = ?mcodmed ") + mbusco
mgroup  = Iif(mcodmed = 0,''," ,codmed ")

mfd  = prg_dtoc(mfechad )
mfh  = prg_dtoc(mfechah + 1)
mfd1 = prg_dtoc(mfechad - 1)

If momite = 1
	mfiltro = mfiltro + " and guardia.codestado <> 17 "
Endif

If mhorad = "00:00" And mhorah = "00:00"
	mbushora = ''
Else
	mbushora = ' and ttoc(fechahoraate,2) >= mhoraD and ttoc(fechahoraate,2) <= mhoraH '
Endif

If Used('mwkMedicoExterno')
	Select mwkMedicoExterno
	Use
Endif
*------------------------------------------------------------------------
mret = SQLExec(mcon1,"SELECT ID as CodMedT , nombre FROM TabMedExterno where gerenciadora = 0 ", "mwkMedicoExterno" )

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	Return .F.
Endif

If Used('mwkMedicoPrest')
	Select mwkMedicoPrest
	Use
Endif
*------------------------------------------------------------------------
mret = SQLExec(mcon1,"select ID as CodMedT , nombre from prestadores ", "mwkMedicoPrest" )

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	Return .F.
Endif

Select CodMedT,nombre From mwkMedicoExterno;
	union All ;
	select CodMedT,nombre From mwkMedicoPrest;
	into Cursor mwkMedicTodos

*!*	mret = sqlexec(mcon1, "select fechahoraing,REG_nombrepac,codprest," + ;
*!*		" fechahoraate,PRE_descriprest,PRE_especialidad," + ;
*!*		" REG_nrohclinica,ESP_descripcion,entidades.ENT_descrient,"+;
*!*		" guardia.codmed,datediff('mi',fechahoraing, fechahoraate) as minuDem," + ;
*!*		" TabTipoAltas.Tipoest,TabTipoAltas.sector,guardia.codestado,guardia.codCIE9 "+;
*!*		" from prestacions,entidades,especialid,registracio," + ;
*!*		" guardia,tabtipoaltas" + ;
*!*		" where guardia.nroregistrac = registracio.REG_nroregistrac and" + ;
*!*		" guardia.codprest = prestacions.PRE_codprest and" + ;
*!*		" prestacions.PRE_especialidad = ESP_codesp and" + ;
*!*		" guardia.codent = entidades.ENT_codent and" + ;
*!*		" (guardia.fechahoraing >= ?mfd and guardia.fechahoraing <= ?mfh"+;
*!*		" and guardia.codestado = TabTipoAltas.id"+;
*!*		" and pre_codservicio = 8000) " + mfiltro, "mwkguardia_ant")

mret = SqlExec(mcon1, "select fechahoraing,REG_nombrepac,codprest," + ;
	" fechahoraate,PRE_descriprest,PRE_especialidad," + ;
	" REG_nrohclinica,ESP_descripcion,entidades.ENT_descrient,"+;
	" guardia.codmed,datediff('mi',fechahoraing, fechahoraate) as minuDem," + ;
	" TabTipoAltas.Tipoest,TabTipoAltas.sector,guardia.codestado,guardia.codCIE9, "+;
	" TabGuaEvol.EG_parOtros, TabGuaEvol.EG_horaCierre " + ;
	" from prestacions,entidades,especialid,registracio," + ;
	" guardia,tabtipoaltas" + ;
	" left join TabGuaEvol on TabGuaEvol.EG_protocolo = Guardia.protocolo " + ;
	" where guardia.nroregistrac = registracio.REG_nroregistrac and" + ;
	" guardia.codprest = prestacions.PRE_codprest and" + ;
	" prestacions.PRE_especialidad = ESP_codesp and" + ;
	" guardia.codent = entidades.ENT_codent and" + ;
	" (guardia.fechahoraing >= ?mfd and guardia.fechahoraing <= ?mfh"+;
	" and guardia.codestado = TabTipoAltas.id"+;
	" and pre_codservicio = 8000) " + mfiltro, "mwkguardia")

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
	Return .F.
Endif
*------------------------------------------------------------------------
Select *,Iif(mwkguardia.tipoest=0 And mwkguardia.sector='1',;
	'Internación         ',;
	iif(mwkguardia.tipoest=0 And mwkguardia.sector='0',;
	iif(codestado=17,'Alta Técnica        ','Alta                ');
	,'Protocolo sin cerrar')) As descrip2 ;
	from mwkguardia ;
	Into Cursor mwkguardia

mfecnul = Ctot("01/01/1900")

Select nombre,fechahoraate ,REG_nombrepac,ESP_descripcion,fechahoraing ,;
	substr(Ttoc(fechahoraate,2),1,5) As hora,Hour(fechahoraate) As horaate,ENT_descrient,;
	ttod(fechahoraate) As fechaate,minuDem As TiempoEspera ,codmed, descrip2,codCIE9, ;
	EG_parOtros, EG_horaCierre ;
	from mwkguardia ;
	left Join mwkMedicTodos On mwkMedicTodos.CodMedT = codmed ;
	where fechahoraate > mfecnul &mbushora;
	order By nombre Into Cursor mwkEspera

If mopcion = 2
	Select * ;
		from mwkEspera ;
		where TiempoEspera > mEspera And  TiempoEspera < demmax ;
		order By fechahoraing ;
		into  Cursor mwkProduccFinal
Else
	Select *,Min(TiempoEspera) As espMin,Max(TiempoEspera) As espMax,;
		avg(TiempoEspera) As espProm,Count(nombre) As cantpac;
		from mwkEspera ;
		where TiempoEspera > mEspera And  TiempoEspera < demmax  ;
		group By ESP_descripcion &mgroup ,fechaate,horaate ;
		order By fechaate,horaate;
		into  Cursor mwkProduccFinal
Endif
