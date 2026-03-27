****
** graba vale farmacia
****

parameter mvale1, mcmed, mmedefe, mdiagno,mfecha,mhora

mprotocolo  = mwkveoproto.protocolo
mcser		= 5410
if type('mfecha') = "D"
	mfate	= ctot(dtoc(mfecha) + " " + alltrim(mhora))
else
	mfate	= sp_busco_fecha_serv('DT')
endif

mret = sqlexec(mcon1, "select * from guardiavale where protocolo = ?mprotocolo " + ;
	"order by nrosec desc", "mwksec")
msecu = mwksec.nrosec + 1

mret = sqlexec(mcon1, "insert into guardiavale(aprobado, codmed, codserv, diagnostico, medefector, " + ;
	"fechahora, nrosec, nrovale, protocolo) values(0, ?mcmed, ?mcser, " + ;
	"?mdiagno, ?mmedefe, ?mfate, ?msecu, ?mvale1, ?mprotocolo)")
