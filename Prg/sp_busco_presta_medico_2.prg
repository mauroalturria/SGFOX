****
** busco prestaciones por servicio y nemonico
****
Parameter mcodprest,mfecdiat
mfecha2 = Ctod('01/01/1900')
If Used ("mwkmedico2")
	Use In mwkmedico2
Endif

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and medpresta.codambito = ?mxambito "
Endif

mccentro = Iif(mxambito = 1,Iif(mxcentromedico =1," and (sala not like '%LIMA%' AND sala not like '%CP%' ) ",;
		Iif(mxcentromedico =2, " and sala like '%LIMA%' "," AND sala like '%CP%' "  )),' ')

If Type('mfecdiat') = "D"
	mdiasemana = Dow(mfecdiat)
	mret = SQLExec(mcon1, "select prestadores.id, prestadores.nombre ,TPF_filtro,sala " + ;
		"from medpresta, " + ;
		"prestadores " + ;
		" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
		"where medpresta.codmed = prestadores.id and " + ;
		' medpresta.fecvigend <> medpresta.fecvigenh and ' + ;
		' ?mfecdiat between medpresta.fecvigend and medpresta.fecvigenh and ' + ;
		"(prestadores.estado = 1 or fecpasiva > ?mfecturno) " + ;
		"and medpresta.codprest = ?mcodprest " + ;
		"and (medpresta.GeneraAgen = 1 or Medpresta.demanda = 1) " + ;
		"and medpresta.diasem = ?mdiasemana " + mccpoamb+mccentro +;
		"group by medpresta.codmed order by nombre", "mwkmedico2")
Else
	mret = SQLExec(mcon1, "select prestadores.id, prestadores.nombre ,TPF_filtro,sala  " + ;
		"from medpresta, " + ;
		"prestadores " + ;
		" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
		"where medpresta.codmed = prestadores.id and " + ;
		' medpresta.fecvigend <> medpresta.fecvigenh and ' + ;
		"and (medpresta.GeneraAgen = 1 or Medpresta.demanda = 1) " + ;
		"(prestadores.estado = 1 or fecpasiva > ?mfecturno) " + ;
		"and medpresta.codprest = ?mcodprest " + mccpoamb+mccentro +;
		"group by medpresta.codmed order by nombre", "mwkmedico2")
Endif
If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE", 48, "Validacion")
	Do prg_cancelo
Endif
