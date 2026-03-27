****
**
****
Lparameters mfechad,mfechah,mbusco

*mfecha = date() + 2

mfecnul = CTOD("01/01/1900")
fecini  = mfechad - 1
dias    = mfechah - mfechad + 1

mret = sqlexec(mcon1,"Select id, (piso || descrip || numero) as lugar"+;
	",cast (0 as integer) as esta  From Tabubicacion "+;
	" where habilitado = 1 Order by piso, numero ",'Mwkqcon')

If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_busco_consultorios1'
Endif

Private mCursor_Porc, mcSalas, mcTemp, mFecha

mCursor_Porc = Sys(2015)
mcSalas      = Sys(2015)
mcTemp       = Sys(2015)


Create Cursor consul;
	(nombre c(50), espec c(50), consultorio c(20), dia D,cdia c(10);
	, h00 c(1), h01 c(1), h02 c(1), h03 c(1), h04 c(1), h05 c(1), h06 c(1) ;
	, h07 c(1),h08 c(1),h09 c(1),h10 c(1),h11 c(1),h12 c(1),h13 c(1);
	, h14 c(1),h15 c(1),h16 c(1),h17 c(1),h18 c(1),h19 c(1),h20 c(1);
	, h21 c(1), h22 c(1), h23 c(1), h24 c(1) ;
	, hdes n(4), ft n(1) ;
	, h0a6 c(1), h22a24 c(1), porc n(6,2) ;
	)

For xi = 1 To dias

	mFecha = fecini+xi
	mdia   = Dow(mFecha)
	If mdia = 1
		Loop
	Endif
	Wait windows 'Analizando día: ' + dtoc(mFecha) + '.... Aguarde...' Nowait

	mret = sqlexec(mcon1,"select nombre, diasem, sala, hdesde1, hhasta1,"+;
		" fecvigend, fecvigenh, generaagen " + ;
		" ,hhmmdes,hhmmhas,medpresta.codesp,ESP_descripcion,prestadores.id " +;
		"from medpresta, prestadores,especialid " + ;
		"where fecpasivap = ?mfecnul and medpresta.codmed = prestadores.id and " + ;
		"medpresta.diasem = ?mdia and medpresta.codesp = ESP_codesp and " + ;
		"medpresta.fecvigend <= ?mfecha  and medpresta.fecvigenh>?mfecha   " + ;
		" and (estado = 1 or fecpasiva > ?mfecha) and medpresta.fecvigend <> medpresta.fecvigenh " + mbusco +;
		"group by codmed,medpresta.codesp, diasem, sala, hhmmdes, hhmmhas,generaagen " + ;
		"order by sala, codmed,medpresta.codesp, hhmmdes, hhmmhas , fecvigend, fecvigenh", "mwkaUX0")

	If mret < 0
		=aerr(eros)
		Do prg_error with eros,'sp_busco_consultorios2'
	Endif

	mret = sqlexec(mcon1,"select codmed, fechatur " + ;
		" from turnos where fechatur = ?mfecha  and tipoturno < 8 "+;
		" group by codmed,fechatur " , "auxturnos")
	If mret < 0
		=aerr(eros)
		Do prg_error with eros,'sp_busco_consultorios3'
	Endif

	Select 	* from mwkaUX0 ;
		left join auxturnos on id=codmed ;
		into cursor mwkaUX

	Select mwkaUX
	Go Top
	Do while !eof()  && Todos los medicos o Uno

		mnombre = nombre
		msala = sala
		mdiasem = mFecha
		mft = iif(isnull(fechatur) and generaagen=1,0,1)
		mdia = iif(diasem=2,"Lunes",iif(diasem=3,"Martes",iif(diasem=4,"Mierc.",;
			iif(diasem=5,"Jueves",iif(diasem=6,"Viernes",iif(diasem=7,"Sabado","Doming"))))) )
		mdia = mdia + " "+str(day(mFecha),2,0)
		mespec = ESP_descripcion
		mhdes = hhmmdes

&& Genera varialbles para el insert
		For i = 0 to 24
			Mvar  = "mh" + transf(i,"@L 99")
			&mvar = ' '
		Next

&& Recorre todo el rango

		Do while !eof() and mnombre = nombre and msala = sala
			For i =floor(hhmmdes/100) to floor(hhmmhas/100)
				Mvar="mh"+transf(i,"@L 99")
				If i = floor(hhmmdes/100)
					&mvar=iif(mod(hhmmdes,100)=0,'X','/')
				Else
					&mvar='X'
				Endif
			Next
			&mvar=iif(mod(hhmmhas,100)=0,'X','/')
			Skip
		Enddo

*----------------------------------------------------------
		Insert into consul ;
			(nombre, espec ,consultorio, dia,cdia, h07, h08, h09, h10;
			, h11, h12, h13, h14, h15, h16, h17, h18, h19, h20, h21, hdes, ft, ;
			h01, h02, h03, h04, h05, h06, h22, h23, h24, h00) ;
			values ;
			(mnombre, mespec ,msala, mdiasem,mdia, mh07, mh08, mh09, mh10;
			, mh11, mh12, mh13, mh14, mh15, mh16, mh17, mh18, mh19, mh20, mh21,mhdes,mft, ;
			mh01, mh02, mh03, mh04, mh05, mh06, mh22, mh23, mh24, mh00)

		Update Mwkqcon set esta = 1 where lugar = msala

		Select mwkaUX
	Enddo

	Use In mwkaUX

	Select Mwkqcon
	Scan All

		If esta = 0

			mnombre = "         "
			msala = lugar
			mft = 1
			mespec = "          "
			mhdes = 700

			For i = 7 to 21
				Mvar  = "mh" + transf(i,"@L 99")
				&mvar = ' '
			Next

			mdiasem = mFecha
			mdias = dow(mFecha)
			mdia = iif(mdias=2,"Lunes",iif(mdias=3,"Martes",iif(mdias=4,"Mierc.",;
				iif(mdias=5,"Jueves",iif(mdias=6,"Viernes",iif(mdias=7,"Sabado","Doming"))))) )
			mdia = mdia + " " + str(day(mFecha),2,0)

*!*			*----------------------------------------------------------
			mh0a6 = ' '
			mh22a24 = ' '
*!*			*----------------------------------------------------------

			Insert into consul (nombre, espec ,consultorio, dia,cdia, h07, h08, h09, h10;
				, h11, h12, h13, h14, h15, h16, h17, h18, h19, h20, h21,hdes,ft, h0a6, h22a24) values ;
				(mnombre, mespec ,msala, mdiasem,mdia, mh07, mh08, mh09, mh10;
				, mh11, mh12, mh13, mh14, mh15, mh16, mh17, mh18, mh19, mh20, mh21,mhdes,mft, mh0a6, mh22a24)

		Endif

		Select Mwkqcon
	Endscan
Next

Do Busco_Porc_Consul With "Consul"

*!* Agrupamiento
Do sp_armo_consul_agrp
mCursor_Porc = Sys(2015)
mcSalas      = Sys(2015)
mcTemp       = Sys(2015)
Do Busco_Porc_Consul With "mwkconsag"
If used('consul')
	Select * from consul into cursor consulA
Endif
If used('mwkconsag')
	Select * from mwkconsag into cursor consulB
Endif
*!*



*!*	El cursor maestro contiene solo una fecha
*!*	el resultado esta en el cursor mCursor_Porc

Procedure Busco_Porc_Consul
Lparameters mMaestro

Create Cursor &mcSalas (consultorio c(Len(&mMaestro->consultorio)), porc n(5,2), dia D(8) ;
	, h00 c(1), h01 c(1), h02 c(1), h03 c(1), h04 c(1), h05 c(1), h06 c(1) ;
	, h07 c(1),h08 c(1),h09 c(1),h10 c(1),h11 c(1),h12 c(1),h13 c(1);
	, h14 c(1),h15 c(1),h16 c(1),h17 c(1),h18 c(1),h19 c(1),h20 c(1);
	, h21 c(1), h22 c(1), h23 c(1), h24 c(1) )


Select Distinct consultorio, dia, 000.00 AS porc ;
	From &mMaestro ;
	Into Cursor &mcTemp

Select &mcSalas
Append From Dbf(mcTemp)

Select &mcTemp
Use

Select &mcSalas
Scan All

	Select * ;
		From &mMaestro ;
		Where consultorio  = &mcSalas->consultorio And dia = &mcSalas->dia;
		Into Cursor &mcTemp

	mnPorc = 0

	For i = 8 To 21

		mcCampo = "h" + Padl(Alltrim(Str(i)),2,"0")
		mcValor = ""

		Select &mcTemp
		Scan All

			mcValor = &mcCampo

			If !Empty(mcValor)
				mnPorc = mnPorc + 1
				Exit
			Endif

			Select &mcTemp
		Endscan

		Select &mcSalas
		Replace &mcCampo With mcValor
	Next

	Select &mcTemp
	Use

	Select &mcSalas
	Replace porc With mnPorc * 100 / 14

	Select &mMaestro &&Consul
	Replace porc With 100 - (mnPorc * 100 / 14) For consultorio  = &mcSalas->consultorio And dia = &mcSalas->dia;

	Select &mcSalas
Endscan

Select &mcSalas
Use

Select &mMaestro &&Consul
Scan All

	Select &mMaestro &&Consul
	If !Empty(h00 + h01 + h02 + h03 + h04 + h05 + h06)
		Select &mMaestro &&Consul
		Replace h0a6 With "|"
	Endif
	If !Empty(h22 + h23)
		Select &mMaestro &&Consul
		Replace h22a24 With "|"
	Endif

	Select &mMaestro &&Consul
Endscan

Endproc





