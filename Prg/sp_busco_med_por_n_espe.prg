****
** Busco medicos dada n especialidades
****

parameter mbusca, mfecdes, mfechas

if type('mfecdes')#"D"
	mfecdes = sp_busco_fecha_serv('DD') - 30
endif

if type('mfechas')#"D"
	mfechas= sp_busco_fecha_serv('DD') + 4
endif

mfecnul = CTOD("01/01/1900")
mccpoamb = ''
if mxambito >1
	mccpoamb = "  and medpresta.codambito = ?mxambito "
endif

mret = Sqlexec(mcon1,"SELECT nombre, prestadores.id " + ;
	"FROM Prestadores, Medpresta " + ;
	"WHERE (fecpasivap = ?mfecnul or fecpasivap > ?mfecdes) and  " + ;
	"medpresta.codmed = prestadores.id and " + ;
	"(estado = 1 or fecpasiva > ?mfecdes) and " + ;
	"medpresta.fecvigend < ?mfechas and " + ;
	"medpresta.fecvigenh > ?mfecdes and " + ;
	"medpresta.fecvigend <> medpresta.fecvigenh " + mbusca + mccpoamb+;
	"group by nombre " + ;
	"Order by Nombre", "mwkmedicos")

if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_med_por_espe'
endif
