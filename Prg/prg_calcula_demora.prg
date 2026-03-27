****prg_calcula_demora
Lparameters tnRegistra,mId,lesvip,lesferiado
Do sp_busco_guadom With tnRegistra," and id = "+Transform(mid),"mwkGDid"
Do sp_busco_estados With 35,' and tipo = 4 ','mwkpacvip'&&
Do sp_busco_estados With 35,' and tipo = 5 ','mwkprestagua'&&
mbusent = ' in ('+Alltrim(mwkpacvip.Descrip)+') '
mpresta = ' and guardia.codprest in ('+Alltrim(mwkprestagua.Descrip)+') '

mprest = mwkGDid.codprest
mbusenti = ''
If !lesferiado
	mbusenti = " and guardia.codent "+Iif(lesvip," not ","")+mbusent
Endif
menti = mwkGDid.codent
mhoraingh = mwkGDid.fechahoraing
mhoraingd = mhoraingh -5*3600
mret = SQLExec(mcon1, "select  fechahoraing , fechahoraate, codestado , " + ;
	" guardia.codent, nroregistrac,guardia.codmed,FecHorDbAdd    " + ;
	" from guardia   " + ;
	" where codestado <>17 and codprest = ?mprest and fechahoraing between ?mhoraingd  and ?mhoraingh " + mbusenti +;
	" and fechahoraate>'1900-01-01' order by fechahoraing desc " , "mwkguaratend")

Select mwkguaratend
Return (fechahoraate-fechahoraing )
