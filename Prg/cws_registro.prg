**** registro pacientes sap
Lparameters nrohclinica
hist_clinica,primer_apellido,primer_nombre, fecha_nac, genero, nacionalidad, calle_nro, pais, cp, localidad, provincia, tel_fijo ;
	, tel_movil, tel_empresa, email, discapacitado, tipo_doc, nro_doc

Private mresultado, merror,provincia(25)
Dimension provincia(25)
If !Used('mwkbuspacie')
	mbusco1 = "where reg_nrohclinica = ?nrohclinica and "
	Do sp_busco_nombre_paciente_1 With mbusco1, 1, ''
Endif
mifec = sp_busco_fechaserv("DD")
m1 = Alltrim(mwkbuspacie.reg_nrohclinica)
m2 = Substr(mwkbuspacie.reg_nombrepac,1,At(",",mwkbuspacie.reg_nombrepac,1)-1) && VER
m3 = Substr(mwkbuspacie.reg_nombrepac,At(",",mwkbuspacie.reg_nombrepac,1)+1)
m4 = ""
m5 = Strtran(Dtoc(mwkbuspacie.reg_fecnacimiento),"/",".")
m6 = Alltrim(Nvl(mwkbuspacie.reg_sexo,'I'))
m7 = tratamiento(m6, Int(prg_edad(mwkbuspacie.reg_fecnacimiento,mifec ,"N" )) )
m8 = "AR" &&Nacionalidad()
m9 = Alltrim(mwkbuspacie.reg_domicilio)
m10 = "AR" && Nacionalidad() && ESTA ES DE LA DIRECCION ?
m11 = Nvl(mwkbuspacie.reg_cpostal,1000)
m12 = mwkbuspacie.reg_localidad
m13 = provincia(mwkbuspacie.reg_provincia)
m14 = mwkbuspacie.reg_telefonos
&& Nro celular
mret = SQLExec(mcon1,"SELECT * FROM TabRegTel WHERE trt_Registracio = ?m1 and trt_TipoLinea = 'M' and Trt_pasiva = '1900-01-01' ","MWKREGTEL")
If mret <=0
	Set Step On
Endif
m15 = MWKREGTEL.trt_numero
m16 = "" && telefono de la empresa
m17 = Iif(Alltrim(mwkbuspacie.reg_email)=="NO TIENE","",Alltrim(mwkbuspacie.reg_email))
m18 = '' &&EstadoCivil()
m19 = '' &&Religion()
m20 = 'ES' && Idioma ?
m21 = "X" && Lista de Religiones ?
m22 = "" && VIP
m23 = "" && Donante de Organos
m24 = "" && Inactivo
m25 = Iif("DISCA" $ Nvl(mwkbuspacie.REG_bloq_comen,' '), "X","" )&& Discapacidad
m26 = TipoDocumento(Val(mwkbuspacie.reg_tipodocumento))
m27 = mwkbuspacie.reg_numdocumento
m28 = "" && Apellido ????
m29 = "" && Nombre de Referencia ???
m30 = "" && Direccion ???????
m31 = "" && Pais ????
m32 = "" && CP ?
m33 = "" && Localidad
m34 = "" && Telefono
m35 = "" && Email
m36 = ""
m37 = "" && Representante legal ????
m38 = "" && Apellido ????
m39 = "" && Nombre de Referencia ???
m40 = "" && Direccion ???????
m41 = "" && Pais ????
m42 = "" && CP ?
m43 = "" && Localidad
m44 = "" && Telefono
m45 = "" && Email
m46 = ""
m47 = "" && Representante legal ????
mccampos = ''
For I = 1 To 47
	mccampos = mccampos +Evaluate("m" + Alltrim(Transform(I)))+","
Next

mresultado = 0
merror = 0
mcopt = ''

mret = SQLExec(mcon1,"CALL WS.SI_PO_0006_Alta_Paciente_OutService('Registracion',5,mcampos,'calvarez',?@mresultado, ?@merror","C1")

miresp = "Resultado : " + Transform(mresultado)+"Error : " + Transform(merror)
Return miresp
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

Function provincia(lcProv)

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
nprov = Iif(I=25,0,I-1)
Return nprov
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
Return lcResu
*--------------------------------------------------------------------------------------
