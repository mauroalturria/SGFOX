****
**  busco grupos
****

parameter msql_gru1, mcual, nf


if mcual = 0
	mret = sqlexec(mcon1, 'select descrip, tipoturno, nivel from tabnivel, tabgrupos ' + ;
		'where tabnivel.nivel = tabgrupos.id ' + ;
		'order by descrip, tipoturno ', 'mwkgru'+ nf )
	lcSql = 'SELECT tipoturno, Abreviatura,Descrip, grupo, ID FROM Tabtipoturno'+;
		' ORDER BY tipoturno '
	If !Prg_EjecutoSql(lcSql,"mwktipt")
		Return .F.
	Endif
	mccampo =''
	SELECT mwktipt
	SELECT *,IIF(!EMPTY(abreviatura),abreviatura,"NO") as ctt FROM mwktipt WHERE !INLIST(tipoturno,10,11,12,9) INTO CURSOR mwktiptu
	SELECT mwktiptu
	scan
		mccampo = mccampo + ',sum(iif(tipoturno = '+Transform(mwktiptu.tipoturno)+', 1, 0 )) as '+Alltrim(mwktiptu.ctt)
	endscan

	msql_gru1 = "select descrip as grupo  " +mccampo + ;
		", nivel, descrip  " + ;
		"from mwkgru" + nf + ;
		" group by descrip order by descrip into cursor mwkgru1"+ nf

else
	mret = sqlexec(mcon1, 'select * from tabgrupos ' + ;
		'order by descrip', 'mwkgru2'+ nf )


	msql_gru1 = 'select * from mwkgru2' + nf +' order by descrip into cursor mwkgru3'+ nf

	select * from ('mwkgru2' + nf ) order by descrip into cursor ('mwkgru3' + nf ) 
endif
