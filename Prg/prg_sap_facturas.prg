Lparameters xusuario
*!*	http://desa.sg.com.ar/api/sap_facturas.php?
*!*	&tipo=FC&paciente=4028579-3&episodio=0FX069-C&importe=4400
*!*	&numero=0016B00330420&fecha=2023-01-24&operador=MCOLOMBO
mifechasap= Left(prg_dtoc(dat_fac(6)),10)
If Vartype(xusuario)<>"C"
	If !Used('mwkusuariosall')
		Do sp_busco_usuarios_all
	Endif
	Select mwkusuariosall
	Locate For codigovax = Val(dat_fac(12))
	If Eof()
		Locate For codigovax =  99999
	Endif
	musuario = Alltrim(mwkusuariosall.idusuario)
Else
	musuario = Alltrim(xusuario)
Endif
Do sp_busco_estados With 57,' and tipo = 18 ','mwkhabpasasap'&&
*lclink = "http://desa.sg.com.ar/api/sap_facturas.php?"
lclink = Alltrim(mwkhabpasasap.Descrip)
lclink = lclink + '?&'+'tipo=' + dat_fac(2)+ '&'+'paciente=' + dat_fac(14)
lclink = lclink + '&'+'episodio=' + dat_fac(13)+ '&'+'importe=' + dat_fac(9)
lclink = lclink + '&'+'numero=' + Alltrim(dat_fac(4))+Alltrim(dat_fac(3))+Padr(Alltrim(dat_fac(5)),8,"00000000")
lclink = lclink + '&'+'fecha=' + mifechasap+ '&'+'operador=' +musuario

Local xmlHTTP As "Microsoft.XMLHTTP"
xmlHTTP = Createobject("Microsoft.XMLHTTP")
If Alltrim(Type("xmlHTTP")) <> "O"
	Messagebox( "No se pudo crear el objeto (XMLHTTP). No se pudo enviar la guía.",48,"Aviso")
	Return
Endif
xmlHTTP.Open("GET", lclink)
xmlHTTP.Send()
Do While xmlHTTP.readyState<>4
	DoEvents
Enddo
lcresp = xmlHTTP.responseText

lnServidor = xmlHTTP.Status

Wait Clear

If !xmlHTTP.Status = 200
	Messagebox('Tipo de Error: '+Alltrim(Str(xmlHTTP.Status)),48,'Problemas con el Servidor')
Else
	If !Vartype(lcresp)="C"
		lcresp = ""
	Else
		If !At('Factura(s) creadas',lcresp)>0

		Endif
	Endif
Endif
*Set Step On
