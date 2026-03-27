Clear
Public mcon1 ,cprov(30)
Dimension cprov(30)
mcon1 = SQLConnect("conec01")
lcDir = "c:\SAP\IS-H\"
lcArc = "01_FORMATO_MCARGUE_DICCIONARIO_Pacientes.txt"
lbProcesar = .T.
mnarch = fcreate(lcArc)
	K = 0
*!*		mret = SQLExec(mcon1,"SELECT REGISTRACIO.* FROM REGISTRACIO "+;
*!*			" inner join pacientes on pacientes.PAC_codhci = REGISTRACIO.registracio "+;
*!*			" inner join pacinternad  on pin_codadmision  = pacientes.pac_codadmision  ","MWKREGI")
*!*			
*!*		If mret <=0
*!*			Set Step On
*!*		Endif
 
*SELECT  * FROM PACIENTES2 INTO CURsor MWKREGI
SELECT  * FROM datos2  INTO CURsor MWKREGI
*USE c:\desaguemes\provincia.dbf IN 0 SHARED
SELECT MWKREGI
Go Top
Scan
	m1 = MWKREGI.registraci
*!*		Select HC_PI_ISH
*!*		replace nroreg WITH m1

	m1 = Alltrim(MWKREGI.reg_nrohclinica)
	m2 = Substr(MWKREGI.reg_nombrepac,1,At(",",MWKREGI.reg_nombrepac,1)-1) && VER
	m2 = strtran(M2, ',', " ")

	m3 = Substr(MWKREGI.reg_nombrepac,At(",",MWKREGI.reg_nombrepac,1)+1)
	m3 = strtran(M3, ',', " ")
	m4 = ""
	m5 = Strtran(Dtoc(MWKREGI.reg_fecnacimiento),"/",".")
	m6 = Alltrim(Nvl(MWKREGI.reg_sexo,'I'))
	m7 = tratamiento(m6, Int(prg_edad(MWKREGI.reg_fecnacimiento,MWKREGI.REG_FECHAALTA,"N" )) )
	m8 = Nacionalidad()
	m9 = Alltrim(NVL(MWKREGI.reg_domicilio,"."))
	m9 = strtran(M9, ',', " ")

	m10 = Nacionalidad() && ESTA ES DE LA DIRECCION ?
	m11 = Nvl(MWKREGI.reg_cpostal,1000)
	m12 = NVL(MWKREGI.reg_localidad,'')
	m12 = strtran(M12, ',', " ")

	m13 = Provincia(MWKREGI.reg_provincia)
	m14 = NVL(MWKREGI.reg_telefonos,'')
&& Nro celular
	mret = SQLExec(mcon1,"SELECT * FROM TabRegTel WHERE trt_Registracio = ?m1 and trt_TipoLinea = 'M' and Trt_pasiva = '1900-01-01' ","MWKREGTEL")
	If mret <=0
		Set Step On
	Endif
	m15 = MWKREGTEL.trt_numero
	m16 = "0" && telefono de la empresa
	m17 = Iif(Alltrim(NVL(MWKREGI.reg_email,''))=="NO TIENE","",Alltrim(NVL(MWKREGI.reg_email,'')))
	m18 = EstadoCivil()
	m19 = Religion()
	m20 = 'ES' && Idioma ?
	m21 = "X" && Lista de Religiones ?
	m22 = "" && VIP
	m23 = "" && Donante de Organos
	m24 = "" && Inactivo
	m25 = Iif("DISCA" $ Nvl(MWKREGI.REG_bloq_comen,' '), "X","" )&& Discapacidad
	m26 = TipoDocumento(Val(MWKREGI.reg_tipodocumento))
	m27 = MWKREGI.reg_numdocumento
	m28 = "" && Apellido ????
	m29 = "" && Nombre de Referencia ???
	m30 = "" && Direccion ???????
	m31 = "" && Pais ????
	m32 = "" && CP ?
	m33 = "" && Localidad
	m34 = "" && Telefono
	m35 = "" && Email
	m36 = Parentesco()
	m37 = "" && Representante legal ????
	m38 = "" && Apellido ????
	m39 = "" && Nombre de Referencia ???
	m40 = "" && Direccion ???????
	m41 = "" && Pais ????
	m42 = "" && CP ?
	m43 = "" && Localidad
	m44 = "" && Telefono
	m45 = "" && Email
	m46 = Parentesco()
	m47 = "" && Representante legal ????
mccad =''
	For I = 1 To 47

		MVAR = "m" + Alltrim(Transform(I))
		mccad = mccad  + TRANSFORM(&MVAR)+ IIF(I<29,chr(9),'')
	Next
	fputs(mnarch, mccad)

	K = K + 1
Endscan

fclose(mnarch)

SQLDisconnect(mcon1)
*--------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------
Function Parentesco

*!*	P 	Txt.tp.parent	P
*!*	A	Abuelo (a)
*!*	B	Cónyuge
*!*	C	Tutor(a)
*!*	D	Hijo (a)
*!*	E	Amigo(a)
*!*	F	Otro
*!*	G	Madre
*!*	H	Nieto(a)
*!*	I	Compañero(a)
*!*	J	Padre
*!*	K	Hermano(a)
*!*	L	Suegro(a)
*!*	M	Tío(a)
*!*	N	Novio(a)
*!*	O	Primo(a)
*!*	P	Yerno/Nuera
*!*	Q	Sobrino(a)
*!*	R	Conviviente
*!*	S	Vecino
*!*	T	Cuñado(a)

Return ""

*--------------------------------------------------------------------------------------
Function TipoDocumento(lnTipo)
Do Case
Case lnTipo = 1
	lcResu = 'LE' &&	Libreta de Enrolamiento
Case lnTipo = 2
	lcResu = 'LC' && 	Libreta cívica
Case lnTipo = 3
	lcResu = 'CI' &&	Cédula de identidad
Case lnTipo = 4
	lcResu = 'DI' && 	Documento Nacional de Identificación
Case lnTipo = 5
	lcResu = 'PA' &&	Pasaporte
Case lnTipo = 6
	lcResu = 'LM' &&	Libreta de Matrimonio
Case lnTipo = 7
	lcResu = 'LF' &&	Libreta Familiar
Case lnTipo = 9
	lcResu = 'OT' &&	Otros

Otherwise
	lcResu = ""

Endcase
*!*	TD	Tipo Documento
*!*	DI	Documento Nacional de Identificación
*!*	CI	Cédula de identidad
*!*	LE	Libreta de Enrolamiento
*!*	LC	Libreta cívica
*!*	LF	Libreta Familiar
*!*	OT	Otros
*!*	PA	Pasaporte
*!*	LM	Libreta de Matrimonio
*!*	CT	Clave Único de Ident. Tributaria
*!*	CL	Clave Única de Ident. Laboral

Return lcResu
*--------------------------------------------------------------------------------------

Function Religion()

*!*	Clv. 	Abr.	Texto religión
*!*	0	--	Sin oblig.impto.religioso
*!*	1	EV	Evangélico
*!*	2	CR	Católico Apost.Romano
*!*	3	RF	Reformado (evangélico)
*!*	4	FR	Reformado francés
*!*	5	CA	Católico rito antiguo
*!*	6	IS	Judío
*!*	7	RLB	Relig.libre región Baden
*!*	8	NAP	Neoapostólico
*!*	9	TJH	Testigos de Jehová
*!*	10	ISL	Islámico
*!*	11	MORM	Mormón
*!*	12	SC	Sin confesión
*!*	13	RLM	Com.rel.libre Maguncia
*!*	14	RLO	Com.rel.libre Offenbach
*!*	15	RLP	Com.rel.libre Palatinado
*!*	16	RPL	Religión protestante lib.
*!*	17	RIBW	Rel.israelita Bd.Würtgb.
*!*	18	IS	Israel
*!*	19	RIB	Región israelita Baden
*!*	20	LU	luterano
*!*	21	ORT	Ortodoxo
*!*	22	HND	Hindú
*!*	23	APOS	Apostólicos
*!*	24	BUD	Budistas
*!*	25	CR	Christelijk Gereformeerd
*!*	26	DG	Doopsgezind
*!*	27	EBG	Evang. Broeder Gemeensch.
*!*	28	TEL	Evang. Lutherse Gemeensch
*!*	29	ISL	Islámicos
*!*	30	JDS	Judíos
*!*	31	MUS	Musulmán
*!*	32	NH	Nederlands Hervormd
*!*	33	PG	Pinstergemeente
*!*	34	ECU	Ecuménicos
*!*	35	VEG	Volle Evang. Gemeente
*!*	36	PROT	Protestantes
*!*	37	BAPT	Baptista
*!*	38	JD	Judío, impuesto religión
*!*	39	JH	Judío, impuesto religión
*!*	40	IH	Judío, impuesto religión
*!*	41	MUSU	Musulmán sunita
*!*	42	MUSH	Musulmán chiita

Return ''

*--------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------
Function EstadoCivil()

*!*	Est.civil	Estado Civil
*!*	1	Solter
*!*	2	Casado
*!*	3	U.libr
*!*	4	Divors
*!*	5	Conviv
*!*	6	Separa
*!*	7	Viudo

Return ''



Function Provincia(lcProv)

cprov(1)="CABA"
cprov(2)="Buenos Aires"
cprov(3	)="Catamarca"
cprov(4	)="Cordoba"
cprov(5	)="Corrientes"
cprov(6	)="Entre Rios"
cprov(7	)="Jujuy"
cprov(8	)="Mendoza"
cprov(9	)="La Rioja"
cprov(10)="Salta"
cprov(11)="San Juan"
cprov(12)="San Luis"
cprov(13)="Santa Fe"
cprov(14)="Santiago del Estero"
cprov(15)="Tucuman"
cprov(16)="Chaco"
cprov(17)="Chubut"
cprov(18)="Formosa"
cprov(19)="Misiones"
cprov(20)="Neuquen"
cprov(21)="La Pampa"
cprov(22)="Rio Negro"
cprov(23)="Santa Cruz"
cprov(24)="Tierra de Fuego"
cprov(25)=" "
For I =1 To 25
	If Upper(cprov(I))=Alltrim(lcProv)
		Exit
	Endif
Next I
nprov = Iif(I>=25,0,I-1)
Return nprov
*--------------------------------------------------------------------------------
Function tratamiento(lcSexo, lnEdad)
*!*	?lcSexo
*!*	?lcEdad
lnEdadTope = 18

Do Case
Case lnEdad = 0
	lcResu = "0005" && Recien Nacido

Case lcSexo = "F"
	If lnEdad > lnEdadTope
		lcResu = "0002" && 	Señora
	Else
		lcResu = "0004" && 	Niña
	Endif

Case lcSexo = "M"

	If lnEdad > lnEdadTope
		lcResu = "0001" && 	Señor
	Else
		lcResu = "0003" && 	Niño
	Endif

Otherwise
	lcResu  = ""

*!*		0006	Empresa

Endcase

Return lcResu

*--------------------------------------------------------------------------------------
Function Nacionalidad

*!*	País	Denominacion
*!*	AD	Andorra
*!*	AE	E.A.U.
*!*	AF	Afganistán
*!*	AG	Antigua/Barbuda
*!*	AI	Anguilla
*!*	AL	Albania
*!*	AM	Armenia
*!*	AN	Antillas Neerl.
*!*	AO	Angola
*!*	AQ	Antártida
*!*	AR	Argentina
*!*	AS	Samoa americana
*!*	AT	Austria
*!*	AU	Australia
*!*	AW	Aruba
*!*	AZ	Azerbaiyán
*!*	BA	Bosnia-Herz.
*!*	BB	Barbados
*!*	BD	Bangladesh
*!*	BE	Bélgica
*!*	BF	Burkina Faso
*!*	BG	Bulgaria
*!*	BH	Bahráin
*!*	BI	Burundi
*!*	BJ	Benín
*!*	BL	Azul
*!*	BM	Bermudas
*!*	BN	Brunéi
*!*	BO	Bolivia
*!*	BR	Brasil
*!*	BS	Bahamas
*!*	BT	Bután
*!*	BV	Islas Bouvet
*!*	BW	Botsuana
*!*	BY	Bielorrusia
*!*	BZ	Belice
*!*	CA	Canadá
*!*	CC	Islas Cocos
*!*	CD	República Congo
*!*	CF	Rep.Centroafr.
*!*	CG	República Congo
*!*	CH	Suiza
*!*	CI	Costa de Marfil
*!*	CK	Islas Cook
*!*	CL	Chile
*!*	CM	Camerún
*!*	CN	China
*!*	CO	Colombia
*!*	CR	Costa Rica
*!*	CS	Serbia/Monten.
*!*	CU	Cuba
*!*	CV	Cabo Verde
*!*	CX	Isla Christmas
*!*	CY	Chipre
*!*	CZ	República Checa
*!*	DE	Alemania
*!*	DJ	Yibuti
*!*	DK	Dinamarca
*!*	DM	Dominica
*!*	DO	Rep.Dominicana
*!*	DZ	Argelia
*!*	EC	Ecuador
*!*	EE	Estonia
*!*	EG	Egipto
*!*	EH	Sáhara occid.
*!*	ER	Eritrea
*!*	ES	España
*!*	ET	Etiopía
*!*	EU	Unión Europea
*!*	FI	Finlandia
*!*	FJ	Fiyi
*!*	FK	Islas Malvinas
*!*	FM	Micronesia
*!*	FO	Islas Feroe
*!*	FR	Francia
*!*	GA	Gabón
*!*	GB	Reino Unido
*!*	GD	Granada
*!*	GE	Georgia
*!*	GF	Guayana Franc.
*!*	GH	Ghana
*!*	GI	Gibraltar
*!*	GL	Groenlandia
*!*	GM	Gambia
*!*	GN	Guinea
*!*	GP	Guadalupe
*!*	GQ	Guinea Ecuator.
*!*	GR	Grecia
*!*	GS	Isl.S.Sandwich
*!*	GT	Guatemala
*!*	GU	Guam
*!*	GW	Guinea-Bissau
*!*	GY	Guyana
*!*	HK	Hong Kong
*!*	HM	Is.Heard/Mcdon.
*!*	HN	Honduras
*!*	HR	Croacia
*!*	HT	Haití
*!*	HU	Hungría
*!*	ID	Indonesia
*!*	IE	Irlanda
*!*	IL	Israel
*!*	IN	India
*!*	IO	Terr.br.Oc.Ind.
*!*	IQ	Iraq
*!*	IR	Irán
*!*	IS	Islandia
*!*	IT	Italia
*!*	JM	Jamaica
*!*	JO	Jordania
*!*	JP	Japón
*!*	KE	Kenia
*!*	KG	Kirguizistán
*!*	KH	Camboya
*!*	KI	Kiribati
*!*	KM	Comoras
*!*	KN	S.Cris.& Nieves
*!*	KP	Corea del Norte
*!*	KR	Corea del Sur
*!*	KW	Kuwait
*!*	KY	Islas Caimán
*!*	KZ	Kazajistán
*!*	LA	Laos
*!*	LB	Líbano
*!*	LC	Santa Lucía
*!*	LI	Liechtenstein
*!*	LK	Sri Lanka
*!*	LR	Liberia
*!*	LS	Lesoto
*!*	LT	Lituania
*!*	LU	Luxemburgo
*!*	LV	Letonia
*!*	LY	Libia
*!*	MA	Marruecos
*!*	MC	Mónaco
*!*	MD	Moldavia
*!*	MG	Madagascar
*!*	MH	de Isl.Marshall
*!*	MK	Macedonia
*!*	ML	Malí
*!*	MM	Myanmar
*!*	MN	Mongolia
*!*	MO	Macao
*!*	MP	Isl.Marianas N.
*!*	MQ	Martinica
*!*	MR	Mauritania
*!*	MS	Montserrat
*!*	MT	Malta
*!*	MU	Mauricio (Isl.)
*!*	MV	Maldivas
*!*	MW	Malaui
*!*	MX	México
*!*	MY	Malasia
*!*	MZ	Mozambique
*!*	NA	Namibia
*!*	NC	Nueva Caledonia
*!*	NE	Níger
*!*	NF	Islas Norfolk
*!*	NG	Nigeria
*!*	NI	Nicaragua
*!*	NL	Países Bajos
*!*	NO	Noruega
*!*	NP	Nepal
*!*	NR	Nauru
*!*	NT	OTAN
*!*	NU	Islas Niue
*!*	NZ	Nueva Zelanda
*!*	OM	Omán
*!*	OR	Naranja
*!*	PA	Panamá
*!*	PE	Perú
*!*	PF	Polinesia fran.
*!*	PG	PapuaNvaGuinea
*!*	PH	Filipinas
*!*	PK	Pakistán
*!*	PL	Polonia
*!*	PM	S.Pedr.,Miquel.
*!*	PN	Islas Pitcairn
*!*	PR	Puerto Rico
*!*	PS	Palestina
*!*	PT	Portugal
*!*	PW	Palaos
*!*	PY	Paraguay
*!*	QA	Qatar
*!*	RE	Reunión
*!*	RO	Rumanía
*!*	RU	Federación Rusa
*!*	RW	Ruanda
*!*	SA	Arabia Saudí
*!*	SB	Islas Salomón
*!*	SC	Seychelles
*!*	SD	Sudán
*!*	SE	Suecia
*!*	SG	Singapur
*!*	SH	Santa Helena
*!*	SI	Eslovenia
*!*	SJ	Svalbard
*!*	SK	Eslovaquia
*!*	SL	Sierra Leona
*!*	SM	San Marino
*!*	SN	Senegal
*!*	SO	Somalia
*!*	SR	Surinam
*!*	ST	S.Tomé,Príncipe
*!*	SV	El Salvador
*!*	SY	Siria
*!*	SZ	Suazilandia
*!*	TC	Isl.Turcas y C.
*!*	TD	Chad
*!*	TF	French S.Territ
*!*	TG	Togo
*!*	TH	Tailandia
*!*	TJ	Tayikistán
*!*	TK	Islas Tokelau
*!*	TL	Timor Oriental
*!*	TM	Turkmenistán
*!*	TN	Túnez
*!*	TO	Tonga
*!*	TP	Timor oriental
*!*	TR	Turquía
*!*	TT	TrinidadyTobago
*!*	TV	Tuvalu
*!*	TW	Taiwan
*!*	TZ	Tanzania
*!*	UA	Ucrania
*!*	UG	Uganda
*!*	UM	IslMenAlejEEUU
*!*	UN	Naciones Unidas
*!*	US	EE.UU.
*!*	UY	Uruguay
*!*	UZ	Uzbekistán
*!*	VA	Ciudad Vaticano
*!*	VC	San Vicente
*!*	VE	Venezuela
*!*	VG	Isl.Vírgenes GB
*!*	VI	Is.Vírgenes USA
*!*	VN	Vietnam
*!*	VU	Vanuatu
*!*	WF	Wallis,Futuna
*!*	WS	Samoa Occident.
*!*	YE	Yemen
*!*	YT	Mayotte
*!*	ZA	Sudáfrica
*!*	ZM	Zambia
*!*	ZW	Zimbabue

Return "AR"
