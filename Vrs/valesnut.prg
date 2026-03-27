miti = seconds()
mret =sqlexec(mcon1, "select VAL_codadmision, VAL_fechasolicitud" + ;
	", pia_cantsolicitada,pia_codprest,pia_secuen_carga,nombre "+;
	", VAL_fechacargasoli,VAL_horacargasolic , VAL_codvaleasist " + ;
	", VAL_operadorcarga,VAL_medicosolicit,VAL_observaciones,VAL_codsector " + ;
	" from pacientes,valesasist " + ;
	" left join presinsuvas on valesasist.valesasist = presinsuvas.pia_valesasist "+;
	" left outer join prestadores on valesasist.VAL_prestador = prestadores . id "+;
	" where  PAC_codadmision = VAL_codadmision and "+;
	" VAL_fechacargasoli >= ?fechalimite and " + ;
	" VAL_codsector <> 'AMB' and VAL_codsector<> 'GUA' "+;
	" and VAL_codservvale = 9400 ", "mwktotval01")
miti2 = seconds()
tipo = miti2-miti1
miti = seconds()
mret =sqlexec(mcon1, "select VAL_codadmision, VAL_fechasolicitud" + ;
	", pia_cantsolicitada,pia_codprest,pia_secuen_carga,nombre "+;
	", VAL_fechacargasoli,VAL_horacargasolic , VAL_codvaleasist " + ;
	", VAL_operadorcarga,VAL_medicosolicit,VAL_observaciones,VAL_codsector " + ;
	" from pacientes,valesasist " + ;
	" left join presinsuvas on valesasist.valesasist = presinsuvas.pia_valesasist "+;
	" left outer join prestadores on valesasist.VAL_prestador = prestadores . id "+;
	" where  PAC_codadmision = VAL_codadmision and "+;
	" VAL_fechasolicitud>= ?fechalimite and " + ;
	" VAL_codsector <> 'AMB' and VAL_codsector<> 'GUA' "+;
	" and VAL_codservvale = 9400 ", "mwktotval01")
miti2 = seconds()
tipos = miti2-miti1
messagebox(transform(tipo)+"---"+ transform(tipos)