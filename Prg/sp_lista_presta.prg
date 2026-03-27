****
** busco dieta entre fechas
****

parameter mfecha,nserv ,mbusco,mfechah
dimension cf(100)
store '' to cf
if type('mbusco')#"C"
	mbusco=''
endif

mfecdia = sp_busco_fecha_serv('DD')
mret =	sqlexec(mcon1, "select pre_codprest,PRE_descriprest" + ;
	" from prestacions " + ;
	" where pre_codservicio = 9400 and PRE_fechapasiva is null " , "mwkpres")
if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif

mret = sqlexec(mcon1, "select PAC_habitacion, PAC_cama,PAC_nombrepaciente " + ;
	", PAC_descripdiagn, PAC_fechaadmision, PAC_edad, PAC_codadmision,PAC_fecnacimiento "+;
	", VAL_codadmision, VAL_fechasolicitud" + ;
	", pia_cantsolicitada,pia_codprest,PIA_cantsolicitada "+;
	", VAL_fechacargasoli,VAL_horacargasolic , VAL_codvaleasist " + ;
	", VAL_observaciones ,sec_descripsec,pia_codprest,VAL_medicosolicit,VAL_OperadorCarga,tabusuario.nomape "+;
	" from pacientes,valesasist " + ;
	" left join presinsuvas on valesasist.valesasist = presinsuvas.pia_valesasist "+;
	" left outer join sectores on sectores.sec_codsector = pacientes.PAC_sectorinternac " + ;
	" left outer join tabusuario on codigovax =  VAL_OperadorCarga " + ;
	" where  PAC_codadmision = VAL_codadmision "+;
	" and VAL_fechacargasoli >= ?mfecha and  VAL_fechacargasoli <= ?mfechah" + ;
	" and VAL_codsector <> 'AMB' and VAL_codsector<> 'GUA' "+;
	" and VAL_codservvale = 9400 "+ mbusco, "mwknutdieta")
if mret<1
	=aerr(eros)
	messagebox (eros(2))
endif
*!*		select mwknutdieta1.*,TNP_Observaciones as indicacion,TNP_CodFact as CodFact from mwknutdieta1 ;
*!*			where  tnd_fecbaja = ctot("01/01/1900") or isnull(tnd_fecbaja ) ;
*!*			into cursor mwknutdieta

select PAC_habitacion+'-'+PAC_cama as habitac,PAC_nombrepaciente  ;
	, proper(PAC_descripdiagn) as PAC_descripdiagn ;
	, PAC_fechaadmision, pac_edad,PAC_codadmision ;
	, prg_edad(PAC_fecnacimiento,mfecha,"AM") as anios ;
	, ctot(dtoc(VAL_fechacargasoli)+" "+ttoc(VAL_horacargasolic,2)) as VAL_fechacargasoli ,VAL_Observaciones;
	, pre_descriprest,pia_codprest,PIA_cantsolicitada  ;
	,sec_descripsec, "  " as pe,  VAL_Observaciones as indicacion,'' as codfact,VAL_medicosolicit,nomape;
	from mwknutdieta ;
	left join mwkpres on pia_codPrest = pre_codprest ;
	order by pre_descriprest,VAL_fechacargasoli , habitac, PAC_codadmision ;
	into cursor mwkdieta
if used("mwkpres")
	use in mwkpres
endif
if used("mwknutdieta")
	use in mwknutdieta
endif
if used("mwknutcdact1")
	use in mwknutcdact1
endif
