****
** Busco medicos dada una especialidad
****

Parameter mcodesp, mfecdes, mfechas,lxcentro
If Vartype(lxcentro)<>"N"
	lxcentro=0
Endif
If Vartype(mcodesp)="C"
	mbuscodesp =  " and medpresta.codesp = ?mcodesp " 
Else
	mbuscodesp =  " and medpresta.codserv = ?mcodesp " 
Endif
If Type('mfecdes')#"D"
	mfecdes = sp_busco_fecha_serv('DD')-30
Endif
If Type('mfechas')#"D"
	mfechas= sp_busco_fecha_serv('DD')+ 4
Endif
mfecnul = Ctod("01/01/1900")
mccpoamb = ''
mccpocmed = ''
mccentro =''
If lxcentro=1
	mccentro = Iif(mxambito = 1,Iif(mxcentromedico =1," and (sala not like '%LIMA%' AND sala not like '%CP%' ) ",;
		Iif(mxcentromedico =2, " and sala like '%LIMA%' "," AND sala like '%CP%' "  )),' ')
Endif
mccpoamb = mccentro
If mxambito >1
	mccpoamb = "  and medpresta.codambito = ?mxambito "
Endif
mret = SQLExec(mcon1,"SELECT nombre, prestadores.id,TPF_filtro " + ;
	"FROM Medpresta,Prestadores " + ;
	" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
	"WHERE (fecpasivap = ?mfecnul or fecpasivap > ?mfecdes) "+;
	"and  medpresta.codmed = prestadores.id and " + ;
	"(estado = 1 or fecpasiva > ?mfecdes) and " + ;
	' medpresta.fecvigend < ?mfechas and ' + ;
	' medpresta.fecvigenh > ?mfecdes and ' + ;
	' medpresta.fecvigend <> medpresta.fecvigenh ' + ;
	mbuscodesp  + mccpoamb +mccpocmed +;
	"group by nombre " + ;
	"ORDER BY Nombre", "mwkmedicos")

If mret < 0
	=Aerr(eros)
	Do prg_error With eros,'sp_busco_med_por_espe'
Endif
