****
**
****
parameter mregistra, mptovta, msql_ncre, marmosql

if vartype(marmosql)<>"C"
	marmosql = "S"
endif
if vartype(mptovta)#"N"
	mptovta = 1
endif
mbus = ""

mblackptovta = mptovta+1000
mwhiteptovta = mptovta+15
*!*	IF myip='172.16.1.7'
*!*	mptovta = 22
*!*	endif
if val(transf(mptovta))> 0
	mbus = 	" and ptovta in (?mptovta,?mblackptovta,?mwhiteptovta  ) "
endif

mret = sqlexec(mcon1, "select fechacte, abrevio, apliletracte, apliptovta, aplinrocte, cuenta, " + ;
	"tpopac, importe, nrovale, aplitpocte, letracte, nrocte, ptovta, tpocte, nroregistracio,codent,codpun " + ;
	"from tabfacturas left join tabformularios on tabfacturas.tpocte = tabformularios.id " + ;
	"where  " + ;
	"nroregistracio = ?mregistra " + ;
	mbus  + ;
	"order by aplinrocte desc, aplitpocte, apliletracte", "mwkfactu")

if marmosql = "S"
	msql_ncre = "select fechacte, " + ;
		"(abrevio + letracte + ' ' + strtran(str(ptovta, 4), ' ', '0') + '-' + " + ;
		"strtran(str(nrocte, 8), ' ' ,'0')) as comprobante, " + ;
		"iif(tpocte >= 5, (iif(tpocte = 5,'FC ','CC ') + apliletracte + ' ' + " + ;
		"strtran(str(apliptovta, 4), ' ', '0') + '-' + " + ;
		"strtran(str(aplinrocte, 8), ' ' ,'0')), '                  ') as comprobante1, " + ;
		"iif(tpocte < 5, importe, 000.00) as debe, " + ;
		"iif(tpocte >= 5, importe * -1, 000.00) as haber, " + ;
		"letracte, ptovta, nrocte, tpocte, importe, cuenta, abrevio, nroregistracio,codent,codpun " + ;
		"from mwkfactu "
endif
