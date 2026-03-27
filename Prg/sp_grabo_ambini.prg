*!* -------------------------------------------------------------------
*!*	Grabo el ambini de la entidad (Tabambinis)
*!* -------------------------------------------------------------------
parameter mambito, medtambini
jj = int(len(alltrim(medtambini))/250)
for i = 0 to jj
	clin = "linea" + padl(i,3,"0")
	public &clin
next
if vartype(linserto)="U"
	linserto = .f.
endif
mambini = prg_concat(alltrim(medtambini))


mret = sqlexec(mcon1, "select * from TabAmbitoIni" + ;
	" where codambito = ?mambito", "mwkTabambitoini")

if mret < 0
	=aerror(merror)
	messagebox("EN CONSULTA AMBULATORIO, PROTOCOLOS PREVIOS"+chr(10)+;
		alltrim(merror(3)),16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif


if reccount("mwkTabambitoini") = 0
	mret = sqlexec(mcon1, "insert into Tabambitoini (codambito ,ini )" + ;
		" values ( ?mambito, " + mambini + " ) " )
else
	nid = mwkTabambitoini.id
	mret = sqlexec(mcon1, "update Tabambitoini set ini = " + mambini +;
		" where id = ?nid ")
endif

if mret < 0
	=aerror(merror)
	messagebox("EN CONSULTA AMBULATORIO, PROTOCOLOS PREVIOS"+chr(10)+;
		alltrim(merror(3)),16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif

for i = 0 to jj
	clin = "linea" + padl(i,3,"0")
	release &clin
next
