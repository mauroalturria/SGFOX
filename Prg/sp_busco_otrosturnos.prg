***
*** Busco otros Turnos para el mismo paciente
***
parameters mnroregistrac, mfecturno, mcodmed
cbmed = ''
if !used('mwkdatos')
	do sp_busco_datos
endif
mfechafiltro = ctod(trans(mwkdatos.valorfloat2,"99/99/9999"))
mfiltraesp = ''
if !empty(mcodmed)
	cbmed = "codmed <> ?mcodmed  and " 
endif
mret = sqlexec(mcon1, "select afiliado, horatur, codmed, codesp " + ;
	" from turnos "+;
	"where afiliado = ?mnroregistrac and "+ cbmed+;
	"codesp not in("+mfiltraesp +" 'CLIN','DERI','DERM','CARD','CARI','PEDI','CIRG', 'TRAU','NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOC', 'ECOO', 'ECOG', "+;
	"'ECOI', 'ERGO', 'KINE', 'LABO', 'RADI', 'RESO', 'TOMO') and " + ;
	" CODprest not in (78010600,78010601,67010201,22020300) and "+;
	"(not (CODprest like '28010%') or CODprest = 28010602 ) and " + ;
	" not (CODprest like '20012%') and codserv <> 1130 and " + ;
	"fechatur = ?mfecturno " + ;
	"order by horatur " , "mwkotrostur")
if mret<1
	=aerr(eros)
	messagebox(eros(2))
	
endif
