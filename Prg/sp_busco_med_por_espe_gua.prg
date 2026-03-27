****
** Busco medicos dada una especialidad
****

parameter mcodesp, mfecdes, mfechas
if type('mfecdes')#"D"
	mfecdes = sp_busco_fecha_serv('DD')-30
endif
if type('mfechas')#"D"
	mfechas= sp_busco_fecha_serv('DD')+ 4
endif
mfecnul = CTOD("01/01/1900")
mret = Sqlexec(mcon1,"SELECT nombre, prestadores.id,TPF_filtro " + ;
	" FROM Prestadores " + ;
	" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
	"WHERE (fecpasivap = ?mfecnul or fecpasivap > ?mfecdes) "+;
	"and fecpasivag > ?mfecdes and " + ;
	" codesp = ?mcodesp " + ;
	"group by nombre " + ;
	"ORDER BY Nombre", "mwkmedicos")

if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_med_por_espe'
endif
