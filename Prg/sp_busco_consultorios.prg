*
* Busqueda de Consultorios
*
Lparameters mfechad, mfechah, mbusco, mbuscop, mbuscoT

If Vartype( mbuscoT )#"C"
	mbuscoT = " 1 = 1 "
Endif

*!*	mccpoamb = ''
*!*	If mxambito > 1
*!*		mccpoamb = "  and medpresta.codambito = ?mxambito "
*!*	Endif

mfecnul = Ctod("01/01/1900")
fecini  = mfechad - 1
dias    = mfechah - mfechad + 1

Private mfecha

Create Cursor consul;
	(nombre c(50), espec c(50), consultorio c(20), dia d,cdia c(10);
	, h00 c(1), h01 c(1), h02 c(1), h03 c(1), h04 c(1), h05 c(1), h06 c(1) ;
	, h07 c(1),h08 c(1),h09 c(1),h10 c(1),h11 c(1),h12 c(1),h13 c(1);
	, h14 c(1),h15 c(1),h16 c(1),h17 c(1),h18 c(1),h19 c(1),h20 c(1);
	, h21 c(1), h22 c(1), h23 c(1), h24 c(1) ;
	, hdes N(4), ft N(1) ;
	, h0a6 c(1), h22a24 c(1), porc N(6,2),ft2 N(1),tp N(1), TipoTurno N(2) Null ,ccodesp c (4) ;
	)

For xi = 1 To dias

	mccpoamb = ''
	If mxambito > 1
		mccpoamb = "  and medpresta.codambito = ?mxambito "
	Endif

	Use In Select("Mwkqcon")

	mret    = SQLExec(mcon1,"Select id, (piso || descrip || numero) as lugar"+;
		",cast (0 as integer) as esta  from tabubicacion "+;
		" where  centromedico  = ?mxcentromedico and habilitado >0 and codambito = ?mxambito order by piso, numero ",'Mwkqcon')

	If mret < 0
		=Aerr(eros)
		Do prg_error With eros,'sp_busco_consultorios1'
		Return
	Endif

	mfecha = fecini+xi
	mdia   = Dow(mfecha)

	If mdia = 1
		Loop
	Endif

	Wait Windows 'Analizando día: ' + Dtoc(mfecha) + '.... Aguarde...' Nowait

	mret = SQLExec(mcon1,"select nombre,diasem,sala,hdesde1,hhasta1," +;
		"fecvigend,fecvigenh,generaagen," + ;
		"hhmmdes,hhmmhas,medpresta.codesp,prestadores.id,codmed " +;
		" from medpresta,prestadores" + ;
		" where prestadores.fecpasivap = ?mfecnul and medpresta.codmed = prestadores.id and" + ;
		" medpresta.diasem = ?mdia &mccpoamb and " + ;
		" medpresta.fecvigend <= ?mfecha and medpresta.fecvigenh > ?mfecha" + ;
		" and (prestadores.estado = 1 or prestadores.fecpasiva > ?mfecha)" +;
		" and medpresta.fecvigend <> medpresta.fecvigenh " + mbusco +;
		" group by codmed,medpresta.codesp,diasem,sala,hhmmdes,hhmmhas,generaagen" + ;
		" order by sala,codmed,medpresta.codesp,hhmmdes,hhmmhas,fecvigend,fecvigenh","mwkaUX0_")

	If mret < 0
		=Aerr(eros)
		Do prg_error With eros,'sp_busco_consultorios2'
	Endif

*!* Agrego
	mbuscop = Iif(Vartype(mbuscop)="C",mbuscop,"")
	If mxambito > 1
		mccpoamb = "  and franjahoraria.codambito = ?mxambito "
	Endif
		mccpocmed = " and centromed = ?mxcentromedico "
	
	mret = SQLExec(mcon1, "select codmed,diasem,hhmmdes,hhmmhas,fecvigend,fecvigenh,"+;
		" franjahoraria.tipoturno,estructura,TabTipoTurno.grupo" +;
		" from franjahoraria,TabTipoturno  "   +;
		" where TabTipoTurno.tipoturno =franjahoraria.tipoturno and  diasem > 0" + mbuscop +;
		" and fecvigenh > ?mfechad and fecvigend <= ?mfechah" +;
		" and fecvigenh <> fecvigend and  centromed = ?mxcentromedico"   +;
		" &mccpoamb and " + Strtran(mbuscoT,"alfa","franjahoraria") +;
		" group by codmed,diasem,fecvigenh,hhmmdes,hhmmhas,franjahoraria.tipoturno","Mwkfran0")

	If mret < 0
		= Aerr(eros)
		Messagebox(eros(3),16,'VALIDACION')
	Endif

	Select mwkaUX0_.nombre, mwkaUX0_.diasem, mwkaUX0_.sala, mwkaUX0_.hdesde1, mwkaUX0_.hhasta1, ;
		mwkaUX0_.fecvigend, mwkaUX0_.fecvigenh, mwkaUX0_.generaagen, ;
		mwkaUX0_.hhmmdes, mwkaUX0_.hhmmhas, mwkaUX0_.codesp, mwkaUX0_.Id, estructura ;
		from mwkaUX0_, mwkfran0,Mwkqcon;
		WHERE  mwkaUX0_.sala= Mwkqcon.lugar AND mwkaUX0_.codmed 	= mwkfran0.codmed And  ;
		mwkaUX0_.diasem 	= mwkfran0.diasem And ;
		mwkfran0.hhmmdes 	= mwkaUX0_.hhmmdes And ;
		mwkfran0.hhmmhas 	= mwkaUX0_.hhmmhas And ;
		mwkfran0.fecvigend 	<= mwkaUX0_.fecvigend And ;
		mwkfran0.fecvigenh 	>= mwkaUX0_.fecvigenh ;
		group By mwkfran0.codmed,codesp,mwkfran0.diasem,sala,mwkfran0.hhmmdes,mwkfran0.fecvigenh;
		into Cursor mwkaux0

	mccpoamb = ''
	If mxambito >1
		mccpoamb = "  and codambito = ?mxambito "
	Endif
	Use In Select("MWKespecial")
	mret=SQLExec(mcon1," SELECT ESP_codesp, ESP_descripcion FROM especialid " + ;
		" WHERE ESP_descripcion is not Null and ESP_genagendaturno <>'N' " +;
		" and trim(ESP_codesp) in (select codesp from medpresta "+;
		" where diasem is not Null &mccpoamb ) "+;
		" ORDER BY ESP_descripcion","MWKespecial")

	Select mwkaux0.*,esp_descripcion From mwkaux0 Left Join mwkespecial On esp_codesp = mwkaux0.codesp;
		into Cursor mwkaux0

	mret = SQLExec(mcon1,"select codmed, fechatur, hhmmtur, diasem as ldiasem, turnos.TipoTurno,TabTipoTurno.grupo " + ;
		" from turnos,TabTipoTurno where TabTipoTurno.tipoturno = turnos.tipoturno and  fechatur = ?mfecha" +;
		" and " +  Strtran(mbuscoT,"alfa","turnos") , "auxturnos")

	If mret < 0
		=Aerr(eros)
		Do prg_error With eros,'sp_busco_consultorios3'
	Endif

	Select Id As esp_codmed,diasem,sala,hhmmdes,codesp   From mwkaux0 ;
		group By esp_codmed,diasem,sala,hhmmdes,codesp ;
		into Cursor mwkaux_esp

	Select mwkaux0.Id As lcodmed,* From mwkaux0 ;
		left Join auxturnos On (mwkaux0.Id=auxturnos.codmed And ;
		auxturnos.fechatur >= mwkaux0.fecvigend And ;
		auxturnos.fechatur <  mwkaux0.fecvigenh And ;
		hhmmtur >= mwkaux0.hhmmdes And hhmmtur<mwkaux0.hhmmhas And ;
		auxturnos.ldiasem = mwkaux0.diasem );
		group By lcodmed,diasem,sala,hhmmdes,fecvigenh ;
		into Cursor mwkaux_a

	Select nombre,diasem,sala,hdesde1,hhasta1,fecvigend,fecvigenh,generaagen,;
		hhmmdes,hhmmhas,codesp,Id,estructura,esp_descripcion,lcodmed As codmed,;
		fechatur,hhmmtur,ldiasem,TipoTurno, ;
		iif(generaagen = 1 And !Isnull(fechatur), 1, 0) As mca, ;
		iif(generaagen # 1, 1, 0) As mde ;
		from mwkaux_a Order By lcodmed,diasem,sala,mca,mde,hhmmdes Into Cursor mwkaux

	Select mwkaux
	Go Top

	Do While !Eof()  && Todos los medicos o Uno

		mnombre = nombre
		msala   = sala
		mdiasem = mfecha
		mcodesp = codesp
		mft  = mca &&iif(generaagen = 1 and !isnull(fechatur),1,0)
		mft2 = mde &&iif(generaagen # 1,1,0)
		mdia = Iif(diasem=2,"Lunes",Iif(diasem=3,"Martes",Iif(diasem=4,"Mierc.",;
			iif(diasem=5,"Jueves",Iif(diasem=6,"Viernes",Iif(diasem=7,"Sabado","Doming"))))) )

		mdia   = mdia + " "+Str(Day(mfecha),2,0)
		mespec = esp_descripcion
		mhdes  = hhmmdes

&&      Genera variables para el insert
		For i = 0 To 24
			Mvar  = "mh" + Transf(i,"@L 99")
			&Mvar = ' '
		Next

&&      Recorre todo el rango
		mTipoTurno = TipoTurno
		Do While !Eof() And mnombre = nombre And msala = sala And mft = mca

			Do While !Eof() And mnombre = nombre And msala = sala And mft = mca And mft2 = mde
				For i =Floor(hhmmdes/100) To Floor(hhmmhas/100)
					Mvar="mh"+Transf(i,"@L 99")
					If i = Floor(hhmmdes/100)
						&Mvar=Iif(Mod(hhmmdes,100)=0,'X','/')
					Else
						&Mvar='X'
					Endif
				Next
				&Mvar=Iif(Mod(hhmmhas,100)=0,' ','/')
				Select mwkaux
				Skip
			Enddo

			Insert Into consul ;
				(nombre, espec ,consultorio, dia,cdia, h07, h08, h09, h10;
				, h11, h12, h13, h14, h15, h16, h17, h18, h19, h20, h21, hdes, ft, ;
				h01, h02, h03, h04, h05, h06, h22, h23, h24, h00, ft2, TipoTurno,ccodesp) ;
				values ;
				(mnombre, mespec ,msala, mdiasem,mdia, mh07, mh08, mh09, mh10;
				, mh11, mh12, mh13, mh14, mh15, mh16, mh17, mh18, mh19, mh20, mh21,mhdes,mft, ;
				mh01, mh02, mh03, mh04, mh05, mh06, mh22, mh23, mh24, mh00, mft2, mTipoTurno,mcodesp)

			Update mwkqcon Set esta = 1 Where lugar = msala

			Select mwkaux
			mft2 = mde

		Enddo

		Select mwkaux
		mft  = mca &&iif(generaagen = 1 and !isnull(fechatur),1,0)
		mft2 = mde

	Enddo
	Use In mwkaux

	Select mwkqcon
	Scan All

		If esta = 0
			mnombre = "         "
			msala = lugar
			mft = 1
			mespec = "          "
			mhdes = IIF(mxcentromedico = 1,700,800)
			mhhas = IIF(mxcentromedico = 1,21,20)
			For i = mhdes/100 To mhhas 
				Mvar  = "mh" + Transf(i,"@L 99")
				&Mvar = ' '
			Next
			mcodesp = '    '
			mdiasem = mfecha
			mdias = Dow(mfecha)
			mdia = Iif(mdias=2,"Lunes",Iif(mdias=3,"Martes",Iif(mdias=4,"Mierc.",;
				iif(mdias=5,"Jueves",Iif(mdias=6,"Viernes",Iif(mdias=7,"Sabado","Doming"))))) )
			mdia = mdia + " " + Str(Day(mfecha),2,0)
*!*			*----------------------------------------------------------
			mh0a6   = ' '
			mh22a24 = ' '
*!*			*----------------------------------------------------------
			Insert Into consul (nombre, espec ,consultorio, dia,cdia, h07, h08, h09, h10;
				, h11, h12, h13, h14, h15, h16, h17, h18, h19, h20, h21,hdes,ft, h0a6, h22a24, ft2,ccodesp) Values ;
				(mnombre, mespec ,msala, mdiasem,mdia, mh07, mh08, mh09, mh10;
				, mh11, mh12, mh13, mh14, mh15, mh16, mh17, mh18, mh19, mh20, mh21,mhdes,mft, mh0a6, mh22a24,;
				mft,mcodesp)
		Endif
		Select mwkqcon

	Endscan

Next

Do busco_porc_consul With "Consul"

*!*	Agrupamiento
Do sp_armo_consul_agrp

Do busco_porc_consul With "mwkconsag"

If Used('consul')
	Select * From consul Into Cursor consula
Endif

If Used('mwkconsag')
	Select * From mwkconsag Into Cursor consulb
Endif

*!*
*!*	El cursor maestro contiene solo una fecha
*!*	el resultado esta en el cursor mCursor_Porc
*!*

Procedure busco_porc_consul
Lparameters mmaestro
Create Cursor mwksalas (consultorio c(Len(&mmaestro->consultorio)), porc N(5,2), dia d(8) ;
	, h00 c(1), h01 c(1), h02 c(1), h03 c(1), h04 c(1), h05 c(1), h06 c(1) ;
	, h07 c(1),h08 c(1),h09 c(1),h10 c(1),h11 c(1),h12 c(1),h13 c(1);
	, h14 c(1),h15 c(1),h16 c(1),h17 c(1),h18 c(1),h19 c(1),h20 c(1);
	, h21 c(1), h22 c(1), h23 c(1), h24 c(1) )

Select Distinct consultorio, dia, 000.00 As porc ;
	from &mmaestro ;
	into Cursor mwktempcur

Select mwksalas

If Used('mwktempcur')
	Append From Dbf('mwktempcur')

	Select mwktempcur
	Use

	Select mwksalas
	Scan All
		Select * ;
			from &mmaestro ;
			where consultorio  = mwksalas->consultorio And dia = mwksalas->dia;
			into Cursor mwktempcur
		mnporc = 0
		For i = 8 To mhhas 
			mccampo = "h" + Padl(Alltrim(Str(i)),2,"0")
			mcvalor = ""
			Select mwktempcur
			Scan All
				mcvalor = &mccampo
				If !Empty(mcvalor)
					mnporc = mnporc + 1
					Exit
				Endif
				Select mwktempcur
			Endscan
			Select mwksalas
			Replace &mccampo With mcvalor
		Next
		Select mwktempcur
		Use
		Select mwksalas
		mthoras = IIF(mxcentromedico = 1,14,12)
		Replace porc With mnporc * 100 / mthoras 
		Select &mmaestro &&Consul
		Replace porc With 100 - (mnporc * 100 / mthoras ) For consultorio = mwksalas->consultorio And dia = mwksalas->dia
		Select mwksalas
	Endscan

	Select mwksalas
	Use

	Select &mmaestro &&Consul
	Scan All
		Select &mmaestro &&Consul
		If !Empty(h00 + h01 + h02 + h03 + h04 + h05 + h06)
			Select &mmaestro &&Consul
			Replace h0a6 With "|"
		Endif
		If !Empty(h22 + h23)
			Select &mmaestro &&Consul
			Replace h22a24 With "|"
		Endif
		Select &mmaestro &&Consul
	Endscan

Endif
Endproc
** Eof() **
