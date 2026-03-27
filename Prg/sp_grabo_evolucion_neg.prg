****
** Grabo evolucion del paciente COVID NEGATIVO
****
Parameters mnroreg, mprot, mmedico, musua
Dimension admfar(11),pract(13)
fechor = sp_busco_fecha_serv("DT")
miprotquir = ''
mcodmedpq  = 0
mprotq     = 0
calta 	 = ''
caltanur = ''
mmotc 	 = "Sospecha COVID-19"
mantec 	 = "."
mevolf	 = "."
mevola	 = ''
mevol	 = "Hisopado COVID-19 no detectable. Se envía resultado por mail "+;
	"con pautas de alarma y medios de contacto a dirección registrada en Historia Clínica."
mindic	 = ''
mtipocons = 2
mfechahora  = Ctot("01/01/1900")
megparalerg	= 0
mnurse = ''
miedit = ''
mevolnurse 	= ''
mcodcienanda = 0
mret = SQLExec(mcon1, "SELECT id,EG_horacierre FROM TabGuaEvol " + ;
	" where eg_nroregistrac = ?mnroreg and eg_protocolo = ?mprot ", "mwkVerEvol")
If mret < 0
	=Aerr(eros)
	Messagebox(eros(3), 48, "Validacion")
Endif

If Reccount('mwkVerEvol')= 0
	mret = SQLExec(mcon1, "insert into TabGuaEvol " + ;
		" (eg_nroregistrac , eg_protocolo , eg_usuario , eg_fechahora , "+;
		" eg_motconsulta , eg_anteceden , eg_exfisico , eg_evolhist , eg_indicnurse, "+;
		" eg_evolnurse,eg_codcienanda,eg_codmed, eg_evolucion, eg_paralerg,"+;
		" eg_horacierre,eg_parotros ,eg_paradmf,eg_parFreCard )"+;
		" values "+;
		" (?mnroreg, ?mprot,?musua,?mfechahora, ?mmotc, ?mantec, ?mevolf,"+;
		" '', ?mindic,?mevolnurse,?mcodcienanda,?mcodmedpq ,?miprotquir,?megparalerg,"+;
		"?fechor,?mfechahora  ,?mfechahora  ,?mtipocons  )" )
	If mret < 0
		mret=Aerr(eros)
		Messagebox(eros(3), 48, "Validacion")
	Endif
	mret = SQLExec(mcon1, "insert into TabGuaEvolMed " + ;
		" (egm_proto , egm_codmed , egm_fechah , egm_evol ) values "+;
		" (?mprot, ?mmedico, ?fechor, ?mevol )" )

Else

	If !Empty(mevol)  And musua = 0
		mret = SQLExec(mcon1, "insert into TabGuaEvolMed " + ;
			" (egm_proto , egm_codmed , egm_fechah , egm_evol ) values "+;
			" (?mprot, ?mmedico, ?fechor, ?mevol )" )
	Endif

Endif

If mret < 0
	=Aerr(eros)
	Messagebox(eros(3), 48, "Validacion")
Endif
