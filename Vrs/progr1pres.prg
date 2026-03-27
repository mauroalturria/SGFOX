	mtipope = " and tipoturno<>7 "
	mret = sqlexec(mcon1, "select codmed ,diasem, hhmmdes,hhmmhas, fecvigend, fecvigenh, tipoturno "+;
		" from franjahoraria "+;
		" where diasem > 0 "+;
		" and fecvigenh >= ?mfecdes and fecvigend <= ?mfechas "+;
		" and fecvigenh <> fecvigend "+ mtipope +;
		" group by codmed, diasem, fecvigenh, hhmmdes,tipoturno ","Mwkfrannp")

	select Mwkmedpresf.* from Mwkmedpresf,Mwkfrannp as Mwkfran0;
		where Mwkfran0.codmed 	= Mwkmedpresf.codmed and  ;
		Mwkfran0.diasem 	= Mwkmedpresf.diasem and ;
		Mwkfran0.hhmmDes 	= Mwkmedpresf.hhmmDes and ;
		Mwkfran0.hhmmHas 	= Mwkmedpresf.hhmmHas and ;
		Mwkfran0.fecvigend 	<= Mwkmedpresf.fecvigend and ;
		Mwkfran0.fecvigenh 	>= Mwkmedpresf.fecvigenh ;
		group by Mwkmedpresf.codmed, Mwkmedpresf.codesp, Mwkmedpresf.codserv, Mwkmedpresf.diasem, Mwkmedpresf.fecvigenh, Mwkmedpresf.hdes1 ;
		order by Mwkmedpresf.codmed, Mwkmedpresf.codserv, Mwkmedpresf.diasem, Mwkmedpresf.fecvigenh, Mwkmedpresf.hdes1 ;
		into cursor Mwkmedprenp
select mwktodosc.*, ESP_descripcion,ESP_cantsinturno;
	from mwktodosc,mwkpress;
	where codesp = trim(ESP_codesp) and afiliado > 1 ;
	and codserv<>7000 group by afiliado,horatur,codmed into cursor mwktodos

select mwktodos.*,porc,hdesde1, hhasta1,right(ttoc(hdesde1),8) as hdes1,right(ttoc(hhasta1), 8) as hhas1     ;
	from mwktodos, Mwkmedprenp as Mwkmedpre;
	where mwktodos.fechatur > Mwkmedpre.fecvigend and ;
	mwktodos.fechatur <=  Mwkmedpre.fecvigenh and ;
	hhmmtur >= Mwkmedpre.hhmmdes and hhmmtur<Mwkmedpre.hhmmhas and ;
	mwktodos.codmed = Mwkmedpre.codmed and ;
	mwktodos.codserv = Mwkmedpre.codserv and ;
	mwktodos.codesp = Mwkmedpre.codesp and ;
	mwktodos.diasem = Mwkmedpre.diasem  ;
	group by afi,mwktodos.codmed, mwktodos.codesp, mwktodos.codserv, fechatur, horatur, tipoturno ;
	into cursor mwktodostpe
