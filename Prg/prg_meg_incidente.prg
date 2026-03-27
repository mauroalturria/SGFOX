Lparameters xdni, xarea, xperfil, xnroadm

If myip='172.16.1.7'
	Set Step On
Endif
If Vartype(xdni)<>"N"
	xdni = 0
Endif
If Vartype(xarea)<>"C"
	xarea = ''
Endif
If Vartype(xperfil)<>"C"
	xperfil = ''
Endif
If Vartype(xnroadm)<>"C"
	xnroadm = ''
Endif

*!*	https://serviciosqas.sg.com.ar/interfaces/SendMegHL7_A01.php?hc=1293334-9&dni=22363468
*!*	&apellido=ALTURRIA&nombre=MAURO&snombre=EMILIANO&fecnac=19710904&sexo=M&calle=123%20CALLE%20FALSA%20456
*!*	&piso=PISO%203&ciudad=CABA&prov=BUENOS%20AIRES&cp=1407&telfijo=%28011%294321-0000&telmovil=%28011%2915-5555-2222
*!*	&email=mauro_alturria@gmail.com&tipopac=E&sector=UCO&hab=HAB-111&cama=CAMA-11&admision=727579-6&obrasoc=Osde
*!*	&condclin=CORONARIO&motivo=Descompensacion%20por%20Presion

Select mwkMEGIncid
Locate For subestado = 2

tcUrl= Alltrim(mwkMEGIncid.Descrip)

lapellido = ""
lnombre   = ""

lclink = Alltrim(tcUrl)

If  mwkMEGIncid.estado = 1
	If Empty(xnroadm)
		Do sp_busco_paciente_datos With xdni
		Select mwkencontrado
		If Reccount('mwkencontrado')>0

			lcdatos =  '?hc='+  ALLTRIM(REG_nrohclinica)+ ;
				'&'+'dni='+Alltrim(Transform(xdni))+;
				'&'+'apellido='+Alltrim(Left(REG_nombrepac,At(',',REG_nombrepac)-1))+;
				'&'+'nombre='+Alltrim(Substr(REG_nombrepac,At(',',REG_nombrepac)+1))+;
				'&'+'fecnac='+Dtos(REG_fecnacimiento)+;
				'&'+'sexo='+Alltrim(REG_sexo)+;
				'&'+'calle='+Alltrim(Nvl(REG_domicilio,'PEDIR'))+;
				'&'+'ciudad='+Alltrim(Nvl(REG_localidad,'PEDIR'))+;
				'&'+'prov='+Alltrim(Nvl(REG_provincia,'PEDIR'))+;
				'&'+'cp='+Alltrim(Transform(Nvl(REG_cpostal, 1001 )))+;
				'&'+'telfijo='+Alltrim(Nvl(REG_telefonos,'PEDIR'))+;
				'&'+'email='+Alltrim(Nvl(REG_email,'PEDIR'))

			lapellido = Alltrim(Left(REG_nombrepac,At(',',REG_nombrepac)-1))
			lnombre   = Alltrim(Substr(REG_nombrepac,At(',',REG_nombrepac)+1))

		Endif

	Else

		Do sp_busco_paciente_datos With  , , xnroadm
		If Reccount('mwkencontrado')>0
			Select mwkencontrado

			lcdatos =  '?hc='+ ALLTRIM(REG_nrohclinica)+ ;
				'&'+'dni='+Alltrim(Transform(xdni))+;
				'&'+'apellido='+Alltrim(Left(PAC_nombrepaciente,At(',',PAC_nombrepaciente)-1))+;
				'&'+'nombre='+Alltrim(Substr(PAC_nombrepaciente,At(',',PAC_nombrepaciente)+1))+;
				'&'+'fecnac='+Dtos(REG_fecnacimiento)+;
				'&'+'sexo='+Alltrim(REG_sexo)+;
				'&'+'calle='+Alltrim(Nvl(REG_domicilio,'PEDIR'))+;
				'&'+'ciudad='+Alltrim(Nvl(REG_localidad,'PEDIR'))+;
				'&'+'prov='+Alltrim(Nvl(REG_provincia,'PEDIR'))+;
				'&'+'cp='+Alltrim(Transform(Nvl(REG_cpostal, 1001 )))+;
				'&'+'telfijo='+Alltrim(Nvl(REG_telefonos,'PEDIR'))+;
				'&'+'email='+Alltrim(Nvl(REG_email,'PEDIR'))+;
				'&'+'tipopac='+Alltrim(COB_CondicImpositiva)

			lapellido = Alltrim(Left(PAC_nombrepaciente,At(',',PAC_nombrepaciente)-1))
			lnombre   = Alltrim(Substr(PAC_nombrepaciente,At(',',PAC_nombrepaciente)+1))

			If PAC_Tipopac >= 2
				lcdatos = lcdatos +	'&'+'sector='+Alltrim(PAC_tipopaciente)
			Else
				lcdatos = lcdatos +	'&'+'sector='+Alltrim(PAC_sectorinternac)+;
					'&'+'hab='+Alltrim(PAC_habitacion)+;
					'&'+'cama='+Alltrim(PAC_cama)
			Endif

			lcdatos = lcdatos +	'&'+'admision='+Alltrim(PAC_codadmision)+;
				'&'+'obrasoc='+Alltrim(ENT_descrient)

		Endif
	Endif

	tcUrl= lclink +lcdatos

	If Reccount('mwkencontrado')>0
		loHttp = Createobject("MSXML2.XMLHTTP")
		loHttp.Open("GET", tcUrl, .F.)
		loHttp.Send()
		lstatus = loHttp.Status
		lcResponse = loHttp.ResponseText
		If Inlist(loHttp.Status, 200,201)
			lcresp = lcResponse
		Else
			lcresp = Transform(loHttp.Status)
		Endif
		Strtofile(lcresp,"jsonresp.txt")
		If mwkusuario.sector = 'SISTEMAS'
			Messagebox("Respuesta:"+Chr(10)+Alltrim(lcresp))
		Endif
		If At('Observación creada con éxito',lcresp)=0
			Select mwkusuario
			Go Top
			midusua     = mwkusuario.idusuario
			Do sp_insert_tabctrlerr With lcdatos , "ERROR OSANA ", midusua, "prg_osana_alta"
		Endif
		Release loHttp
		Wait Clear
	Endif
Endif

*!*https://staging-clients.azure.megsupporttools.com/webforms/70kjrdwk
*!*	?paciente_involucrado=Con%20Paciente%20Involucrado&hay_un_paciente_involucrado=Si
*!*	&paciente_id=752291243&fecha_del_incidente=2026-01-14&hora_del_incidente=13:44:45
*!*	&donde_ocurrio_el_incidente=Ambulatorio
*!*	&que_rol_notifica=Camillero
*!*

Select  mwkMEGIncid
Locate For subestado = 1

mifecha = prg_dtoc(sp_busco_fecha_serv("DT"))
midia   = Left(mifecha,10)
mihora  = Substr(mifecha,12,5)
tcUrl   = Alltrim(mwkMEGIncid.Descrip)

If  mwkMEGIncid.estado = 1

	If xdni>0
		lclink = Alltrim(tcUrl)
		lcdatos =  '?paciente_involucrado=Con%20Paciente%20Involucrado'+ ;
			'&'+'hay_un_paciente_involucrado=Si'+ '&'+'paciente_id='+;
			Alltrim(Transform(xdni))+;
			'&'+'donde_ocurrio_el_incidente='+Alltrim(xarea)+;
			'&'+'fecha_del_incidente='+Alltrim(midia)+;
			'&'+'hora_del_incidente='+Alltrim(mihora)+;
			'&'+'que_rol_notifica='+Alltrim(xperfil)+;
			'&'+'apellido_paciente='+Alltrim(lapellido)+;
			'&'+'nombre_paciente='+Alltrim(lnombre)

		tcUrl= lclink +lcdatos
	Endif

	=prg_veo_url(tcUrl)

Endif
