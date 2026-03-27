select * from medpresta where diasem = 2 and hhmmdes>=1400 and codprest not in ;
(select codprest from esquemas_agenda where lunes="NO")
copy to faltalunestarde type xl5
select * from medpresta where hhmmdes>=1400 and codprest in ;
(select codprest from esquemas_agenda where mania="NO")
select * from medpresta group by codmed,diasem,hhmmdes,fecvigend into cursor quemed
BROWSE LAST
select * from medpresta group by codmed,diasem,hhmmdes,fecvigenh into cursor quemed

select quemed
set step on
scan
	mmed = codmed
	mdia = diasem
	cdia = iif(mdia = 2,'Lun_', iif(mdia =3,'Mar_',;
		iif(mdia =4,'Mie_', iif(mdia =5,'Jue_',+;
		iif(mdia =6,'Vie_', iif(mdia =7,'Sab_','Dom_'))))))
	mhhdes = hhmmdes
	mfec = fecvigenh 
	cnom = cdia+left(nombre,at(' ',nombre))+padl(hhmmdes,4,"0")
	select * from esquemas_agenda where codprest not in ;
	(select codprest from medpresta where codmed=mmed and diasem=mdia ;
	and fecvigenh=mfec and hhmmdes>=1400) into cursor faltas
	select faltas 
	if reccount('faltas')>0
		copy to &cnom type xls
	endif
	select quemed
endscan