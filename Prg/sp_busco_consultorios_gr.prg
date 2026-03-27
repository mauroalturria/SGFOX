****
** Busqueda de Consultorios
****
lparameters mfechad, mfechah, mbusco, mbuscop, mbuscoT,cadservicio,mbuscons
if vartype( mbuscoT )#"C"
	mbuscoT = " 1 = 1 "
endif
*!* mfecha = date() + 2
mfecnul = ctod("01/01/1900")
fecini  = mfechad - 1
dias    = mfechah - mfechad + 1

if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
	mcjoin = 	" and medpresta.codambito = franjahoraria.codambito "
else
	mccpoamb = ''	
	mcjoin = ''
endif
mret    = sqlexec(mcon1,"Select id, (piso || descrip || numero) as lugar"+;
	",cast (0 as integer) as esta  from tabubicacion "+;
	" where  centromedico = ?mxcentromedico and &mccpoamb &mbuscons "+;
	" order by piso, numero ",'Mwkqcon')
if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_consultorios1'
endif
private mfecha
create cursor consul;
	(nombre c(50), espec c(50), consultorio c(20), dia d,cdia c(10);
	, h00 c(1), m00 c(1), h01 c(1), m01 c(1), h02 c(1), m02 c(1), h03 c(1), m03 c(1), ;
	h04 c(1), m04 c(1), h05 c(1), m05 c(1), h06 c(1),m06 c(1)  ;
	, h07 c(1),m07 c(1),h08 c(1),m08 c(1),h09 c(1),m09 c(1),h10 c(1),m10 c(1);
	,h11 c(1),m11 c(1),h12 c(1),m12 c(1),h13 c(1),m13 c(1);
	, h14 c(1),m14 c(1),h15 c(1),m15 c(1),h16 c(1),m16 c(1),h17 c(1),m17 c(1),;
	h18 c(1),m18 c(1),h19 c(1),m19 c(1),h20 c(1),m20 c(1);
	, h21 c(1), m21 c(1), h22 c(1),m22 c(1), h23 c(1),  m23 c(1), h24 c(1),m24 c(1), hdes n(4), ft n(1) ;
	, h0a6 c(1), h22a24 c(1), porc n(6,2),ft2 n(1),tp n(1), TipoTurno n(2) null  ,ccodesp c (4)  )
for xi = 1 to dias
	mfecha = fecini+xi
	mdia   = dow(mfecha)
	if mdia = 1
		loop
	endif
	wait windows 'Analizando día: ' + dtoc(mfecha) + '.... Aguarde...' nowait
	mret = sqlexec(mcon1,"select nombre,diasem,sala,hdesde1,hhasta1," +;
		"fecvigend,fecvigenh,generaagen," + ;
		"hhmmdes,hhmmhas,medpresta.codesp,prestadores.id, codmed " +;
		" from medpresta,prestadores" + ;
		" where &mccpoamb prestadores.fecpasivap = ?mfecnul and medpresta.codmed = prestadores.id and" + ;
		" medpresta.diasem = ?mdia and" + ;
		" medpresta.fecvigend <= ?mfecha and medpresta.fecvigenh > ?mfecha" + ;
		" and (prestadores.estado = 1 or prestadores.fecpasiva > ?mfecha)" +;
		" and medpresta.fecvigend <> medpresta.fecvigenh " + mbusco + ;
		' and medpresta.codserv in ('+cadservicio+')'+;
		" group by codmed,medpresta.codesp,diasem,sala,hhmmdes,hhmmhas,generaagen" + ;
		" order by sala,codmed,medpresta.codesp,hhmmdes,hhmmhas,fecvigend,fecvigenh","mwkaUX0_")
	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_busco_consultorios2'
	endif
*!* Agrego
	mbuscop = iif(vartype(mbuscop)="C",mbuscop,"")
	mret = sqlexec(mcon1, "select codmed,diasem,hhmmdes,hhmmhas,fecvigend,fecvigenh,"+;
		" tipoturno,estructura" +;
		" from franjahoraria"   +;
		" where &mccpoamb diasem > 0" + mbuscop +;
		" and fecvigenh > ?mfechad and fecvigend <= ?mfechah" +;
		" and fecvigenh <> fecvigend and centromed = ?mxcentromedico " +;
		" and " + mbuscoT +;
		" group by codmed,diasem,fecvigenh,hhmmdes,hhmmhas,tipoturno","Mwkfran0")
	if mret < 0
		= aerr(eros)
		messagebox(eros(3),16,'VALIDACION')
	endif
	select mwkaux0_.nombre, mwkaux0_.diasem, mwkaux0_.sala, mwkaux0_.hdesde1, mwkaux0_.hhasta1, ;
		mwkaux0_.fecvigend, mwkaux0_.fecvigenh, mwkaux0_.generaagen, ;
		mwkaux0_.hhmmdes, mwkaux0_.hhmmhas, mwkaux0_.codesp, mwkaux0_.id, estructura  ;
		from mwkaux0_, mwkfran0,Mwkqcon ;
		where mwkaux0_.sala = Mwkqcon.lugar AND mwkaux0_.codmed 	= mwkfran0.codmed and  ;
		mwkaux0_.diasem 	= mwkfran0.diasem and ;
		mwkfran0.hhmmdes 	= mwkaux0_.hhmmdes and ;
		mwkfran0.hhmmhas 	= mwkaux0_.hhmmhas and ;
		mwkfran0.fecvigend 	<= mwkaux0_.fecvigend and ;
		mwkfran0.fecvigenh 	>= mwkaux0_.fecvigenh ;
		group by mwkfran0.codmed,codesp,mwkfran0.diasem,sala,mwkfran0.hhmmdes,mwkfran0.fecvigenh;
		into cursor mwkaux0
	mret = sqlexec(mcon1,"select ESP_codesp,ESP_descripcion From Especialid","mwkespecial")
	
	select mwkaux0.*,esp_descripcion from mwkaux0 left join mwkespecial on esp_codesp = mwkaux0.codesp;
		into cursor mwkaux0
*!*
*!* 22-12-2009
*!*
*!*		mret = sqlexec(mcon1,"select codmed, fechatur, hhmmtur, diasem as ldiasem, TipoTurno " + ;
*!*			" from turnos where fechatur = ?mfecha  and tipoturno < 8 " +;
*!*			" order by codmed,fechatur", "auxturnos")
	mret = sqlexec(mcon1,"select codmed, fechatur, hhmmtur, diasem as ldiasem, TipoTurno " + ;
		" from turnos where &mccpoamb fechatur = ?mfecha" +;
		" and " + iif(mbuscoT = " 1 = 1 ", "(tipoturno < 8 or tipoturno>=11)", mbuscoT)+;
		" order by codmed,fechatur", "auxturnos")

	if mret < 0
		=aerr(eros)
		do prg_error with eros,'sp_busco_consultorios3'
	endif

	select id as esp_codmed,diasem,sala,hhmmdes,codesp   from mwkaux0 ;
		group by esp_codmed,diasem,sala,hhmmdes,codesp ;
		into cursor mwkaux_esp	
	select mwkaux0.id as lcodmed,* from mwkaux0 ;
		left join auxturnos on (mwkaux0.id=auxturnos.codmed and ;
		auxturnos.fechatur >= mwkaux0.fecvigend and ;
		auxturnos.fechatur <  mwkaux0.fecvigenh and ;
		hhmmtur >= mwkaux0.hhmmdes and hhmmtur<mwkaux0.hhmmhas and ;
		auxturnos.ldiasem = mwkaux0.diasem );
		group by lcodmed,diasem,sala,hhmmdes,fecvigenh;
		into cursor mwkaux
	select nombre,diasem,sala,hdesde1,hhasta1,fecvigend,fecvigenh,generaagen,;
		hhmmdes,hhmmhas,codesp,id,estructura,esp_descripcion,lcodmed as codmed,;
		fechatur,hhmmtur,ldiasem,TipoTurno, ;
		iif(generaagen = 1 and !isnull(fechatur), 1, 0) as mca, ;
		iif(generaagen # 1, 1, 0) as mde;
		from mwkaux order by lcodmed,diasem,sala,mca,mde,hhmmdes into cursor mwkaux
	select mwkaux
	go top
	do while !eof()  && Todos los medicos o Uno
		mnombre = nombre
		msala   = sala
		mdiasem = mfecha
		mcodesp = codesp
		mft  = mca &&iif(generaagen = 1 and !isnull(fechatur),1,0)
		mft2 = mde &&iif(generaagen # 1,1,0)
		mdia = iif(diasem=2,"Lunes",iif(diasem=3,"Martes",iif(diasem=4,"Mierc.",;
			iif(diasem=5,"Jueves",iif(diasem=6,"Viernes",iif(diasem=7,"Sabado","Doming"))))) )
		mdia   = mdia + " "+str(day(mfecha),2,0)
		mespec = esp_descripcion
		mhdes  = hhmmdes
&&      Genera variables para el insert
		for i = 0 to 24
			mvar  = "mh" + transf(i,"@L 99")
			mmvar  = "mm" + transf(i,"@L 99")
			&mvar = ' '
			&mmvar = ' '
		next
&&      Recorre todo el rango
		mTipoTurno = TipoTurno
		do while !eof() and mnombre = nombre and msala = sala and mft = mca
			do while !eof() and mnombre = nombre and msala = sala and mft = mca  and mft2 = mde
				for i =floor(hhmmdes/100) to floor(hhmmhas/100)
				
					mvar="mh"+transf(i,"@L 99")
					mmvar="mm"+transf(i,"@L 99")
					if i = floor(hhmmdes/100)
						if mod(hhmmdes,100)=0
							&mvar='X'
							&mmvar='X'
						else
							&mmvar='X'
						endif	
					else
						&mmvar='X'
						&mvar='X'
					endif
				next
				if mod(hhmmhas,100)=0
					&mvar=''
					&mmvar=''
				else
					&mmvar='X'
				endif	
				select mwkaux
				skip
			enddo
*----------------------------------------------------------
		insert into consul ;
				(nombre, espec ,consultorio, dia,cdia, h07, h08, h09, h10;
				, h11, h12, h13, h14, h15, h16, h17, h18, h19, h20, h21, hdes, ft, ;
				h01, h02, h03, h04, h05, h06, h22, h23, h24, h00, ft2, TipoTurno;
				,m00,m01, m02, m03, m04, m05, m06, m07, m08, m09, m10, m11, m12, m13, m14, m15, m16, m17, m18, ;
				m19, m20, m21,m22, m23, m24,ccodesp) ;
				values ;
				(mnombre, mespec ,msala, mdiasem,mdia, mh07, mh08, mh09, mh10;
				, mh11, mh12, mh13, mh14, mh15, mh16, mh17, mh18, mh19, mh20, mh21,mhdes,mft, ;
				mh01, mh02, mh03, mh04, mh05, mh06, mh22, mh23, mh24, mh00, mft2, mTipoTurno;
				,mm00,mm01, mm02, mm03, mm04, mm05, mm06, mm07, mm08, mm09, mm10, mm11, mm12, mm13, mm14, mm15, mm16, mm17, mm18, ;
				mm19, mm20, mm21,mm22, mm23, mm24,mcodesp)
			update mwkqcon set esta = 1 where lugar = msala
			select mwkaux
			mft2 = mde
		enddo
		select mwkaux
		mft  = mca &&iif(generaagen = 1 and !isnull(fechatur),1,0)
		mft2 = mde
	enddo
	use in mwkaux
	select mwkqcon
	scan all
		if esta = 0
			mnombre = "         "
			msala = lugar
			mft = 1
			mespec = "          "
			mhdes = 700
			for i = 0 to 24
				mvar  = "mh" + transf(i,"@L 99")
				mmvar  = "mm" + transf(i,"@L 99")
				&mvar = ' '
				&mmvar = ' '
			next
			mdiasem = mfecha
			mcodesp = '    '
			mdias = dow(mfecha)
			mdia = iif(mdias=2,"Lunes",iif(mdias=3,"Martes",iif(mdias=4,"Mierc.",;
				iif(mdias=5,"Jueves",iif(mdias=6,"Viernes",iif(mdias=7,"Sabado","Doming"))))) )
			mdia = mdia + " " + str(day(mfecha),2,0)
*!*			*----------------------------------------------------------
			mh0a6 = ' '
			mh22a24 = ' '
*!*			*----------------------------------------------------------
		insert into consul ;
				(nombre, espec ,consultorio, dia,cdia, h07, h08, h09, h10;
				, h11, h12, h13, h14, h15, h16, h17, h18, h19, h20, h21, hdes, ft, ;
				h01, h02, h03, h04, h05, h06, h22, h23, h24, h00, ft2, TipoTurno;
				,m00,m01, m02, m03, m04, m05, m06, m07, m08, m09, m10, m11, m12, m13, m14, m15, m16, m17, m18, ;
				m19, m20, m21,m22, m23, m24,ccodesp) ;
				values ;
				(mnombre, mespec ,msala, mdiasem,mdia, mh07, mh08, mh09, mh10;
				, mh11, mh12, mh13, mh14, mh15, mh16, mh17, mh18, mh19, mh20, mh21,mhdes,mft, ;
				mh01, mh02, mh03, mh04, mh05, mh06, mh22, mh23, mh24, mh00, mft2, mTipoTurno;
				,mm00,mm01, mm02, mm03, mm04, mm05, mm06, mm07, mm08, mm09, mm10, mm11, mm12, mm13, mm14, mm15, mm16, mm17, mm18, ;
				mm19, mm20, mm21,mm22, mm23, mm24,mcodesp)
		endif
		select mwkqcon
	endscan
next
do busco_porc_consul with "Consul"
*!* Agrupamiento
do sp_armo_consul_agrp_gr
do busco_porc_consul with "mwkconsag"
if used('consul')
	select * from consul into cursor consula
endif
if used('mwkconsag')
	select * from mwkconsag into cursor consulb
endif
*!*
*!*	El cursor maestro contiene solo una fecha
*!*	el resultado esta en el cursor mCursor_Porc
*!*
procedure busco_porc_consul
	lparameters mmaestro
	create cursor mwksalas (consultorio c(len(&mmaestro->consultorio)), porc n(5,2), dia d(8) ;
		, h00 c(1), h01 c(1), h02 c(1), h03 c(1), h04 c(1), h05 c(1), h06 c(1) ;
		, h07 c(1),h08 c(1),h09 c(1),h10 c(1),h11 c(1),h12 c(1),h13 c(1);
		, h14 c(1),h15 c(1),h16 c(1),h17 c(1),h18 c(1),h19 c(1),h20 c(1);
		, h21 c(1), h22 c(1), h23 c(1), h24 c(1) )
	select distinct consultorio, dia, 000.00 as porc ;
		from &mmaestro ;
		into cursor mwktempcur
	select mwksalas
	append from dbf('mwktempcur')
	select mwktempcur
	use
	select mwksalas
	scan all
		select * ;
			from &mmaestro ;
			where consultorio  = mwksalas->consultorio and dia = mwksalas->dia;
			into cursor mwktempcur
		mnporc = 0
		for i = 8 to 21
			mccampo = "h" + padl(alltrim(str(i)),2,"0")
			mcvalor = ""
			select mwktempcur
			scan all
				mcvalor = &mccampo
				if !empty(mcvalor)
					mnporc = mnporc + 1
					exit
				endif
				select mwktempcur
			endscan
			select mwksalas
			replace &mccampo with mcvalor
		next
		select mwktempcur
		use
		select mwksalas
		replace porc with mnporc * 100 / 14
		select &mmaestro &&Consul
		replace porc with 100 - (mnporc * 100 / 14) for consultorio = mwksalas->consultorio and dia = mwksalas->dia
		select mwksalas
	endscan
	select mwksalas
	use
	select &mmaestro &&Consul
	scan all
		select &mmaestro &&Consul
		if !empty(h00 + h01 + h02 + h03 + h04 + h05 + h06)
			select &mmaestro &&Consul
			replace h0a6 with "|"
		endif
		if !empty(h22 + h23)
			select &mmaestro &&Consul
			replace h22a24 with "|"
		endif
		select &mmaestro &&Consul
	endscan
endproc
