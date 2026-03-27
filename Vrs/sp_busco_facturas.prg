****
****
public mcon1
do sp_conexion
mfecdes = ctod("01/03/2006")

mfechas = ctod("31/03/2006")

mret = sqlexec(mcon1, "select nrocte,nroregistracio,nrovale,ptovta,tpocte,tpopac,usuario " + ;
	" ,VAL_CODSERVVALE " +;
	" from tabfacturas,VALESASIsT " + ;
	" where fechacte >= ?mfecdes and fechacte<= ?mfechas "+;
	" and ptovta=1 and codpun = VAL_codpun " , "mwkfactPV1")
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	
endif

mret = sqlexec(mcon1, "select nrocte,nroregistracio,nrovale,ptovta,tpocte,tpopac,usuario " + ;
	" from tabfacturas " + ;
	" where fechacte >= ?mfecdes and fechacte<= ?mfechas "+;
	" and ptovta = 2 " , "mwkfactpv2")
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
endif
select count(nrocte) as cantidad ,VAL_CODSERVVALE from mwkfactpv1 group by VAL_CODSERVVALE into cursor facturas
select facturasselect count(nrocte) as cantidad ,VAL_CODSERVVALE from mwkfactpv1 group by VAL_CODSERVVALE into cursor facturas
select facturas.*,ser_descripserv from facturas,mwkserv where VAL_CODSERVVALE =se_codserv into cursor facturasPV1
select facturas.*,ser_descripserv from facturas,mwkserv where VAL_CODSERVVALE = ser_codserv into cursor facturasPV1
BROWSE LAST
copy to ptovta1 type xls
