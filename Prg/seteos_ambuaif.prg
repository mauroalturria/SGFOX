Clear
Set Date FRENCH
Set Deleted On
Close Tables
Set Escape On
Set Status Bar On

@4,1 Say "Procesando Padrón"

Public mconSql, mcon1
=ESC_EST("CONECTANDO CON LOS SERVIDOR")

*Sqldisconnect(mcon1)

mconSql = Sqlconnect("CEDI","cache","admcache")
mcon1   = Sqlconnect("Conec01")

*!*	mconSql = Sqlconnect("172.16.1.240","cache","admcache")
*!*	mcon1   = Sqlconnect("172.16.1.4")

ltfechoy = sp_busco_fecha_serv('DT')
@5,1 Say "Fecha " + Ttoc(ltfechoy)

=ESC_EST("SELECCIONANDO LA BASE DE DATOS")
If Sqlexec(mconSql,"Use TNGS_Cedi") <= 0
	Messagebox("AL SELECCIONAR LA BASE DE DATOS TNGS_Cedi",16,"ERROR")
	Set Step On
	Canc
Endif  

ldFecTop = ctod("01/01/2100")

*!*	If Sqlexec(mconSql,"Select * from Sg_Padrones","mwkPatrones") <= 0
*!*		Messagebox("AL GUARDAR",16,"ERROR")
*!*		Set Step On
*!*	Endif  

=ESC_EST("SELECCIONANDO ENTIDADES")
If Sqlexec(mconSql,"Select * from Sg_Entidades","mwkEntidades") <= 0
	Messagebox("AL SELECCIONAR ENTIDADES",16,"ERROR")
	Set Step On
	Canc
Endif  

=ESC_EST("SELECCIONANDO PADRON EXISTENTE")
If Sqlexec(mconSql,"Update Sg_Padrones Set Borrar = 1 ") <= 0
	Messagebox("AL SELECCIONAR EXISTENTES",16,"ERROR")
	Set Step On
	Canc
Endif 

Select mwkEntidades
Count To lnCount

Use In Select("mwkPadG")


Select mwkEntidades
Scan All  
	lnCodEnt = mwkEntidades.CodEnt

	Select mwkEntidades
	lcestado = " - " + Transform(Recno()) + " / " + Transform(lnCount)
	=ESC_EST("PROCESANDO ENTIDAD " + Transform(lnCodEnt) + lcestado)
	
	mbusco1 = "where entidad = ?lnCodEnt and FecEgreso = ?ldFecTop "
	
	IF lnCodEnt = 948

			if sqlexec(mcon1,"select PadCabe.ID , PadCabe.Apellido , PadCabe.grupofamiliar, " + ;
				"PadCabe.ApeyNom , PadCabe.CUIL , PadCabe.Credencial , PadCabe.Documento, " + ;
				"PadCabe.Entidad, PadCabe.FecEgreso , PadCabe.FecIngreso, " + ;
				"PadCabe.FecNac , PadCabe.Nombre , PadCabe.NroAfiliado, " + ;
				"PadCabe.NroAfiliadoAlternativo, PadCabe.Plan, PadCabe.PlanAlternativo, " + ;
				"PadCabe.Sexo, PadCabe.TipoDocumento, " + ;
				"entidades.ent_descrient, " + ;
				"Paddomicilio.Domicilio, Paddomicilio.FechaDesde, Paddomicilio.FechaHasta, " + ;
				"Paddomicilio.Localidad, Paddomicilio.Provincia, Paddomicilio.Telefono, " + ;
				"Paddomicilio.Id as IdDom, Paddomicilio.Codigo, " + ;
				"tabdocumentos.abrevio as TipoDocDes, 'SG' AS Contenido, " + ;
				"nvl(padotrosdatos.contenido,'GASTRO-SD') as Des_planes " + ;
				"FROM PadCabe " + ;
				"left join padotrosdatos on  padotrosdatos.idpadcabe = padcabe.id and padotrosdatos.campo = 'OBRASOC' " + ;
					" and PadOtrosDatos.fechahasta = ?ldFecTop " +;
				"left join entidades on entidad = ent_codent " + ;
				"left join tabdocumentos on PadCabe.TipoDocumento= tabdocumentos.codigovax " + ;
				"Inner Join Paddomicilio on PadCabe.ID = Paddomicilio.IdPadCabe " + ;
				"left join planes on padcabe.plan = planes.id " + ;
				"" + mbusco1  + "  " + ;
				" Group By PadCabe.Id " + ;
				" Order by Paddomicilio.Id Desc " , "mwkbuspadron") <=0

			Messagebox("DE LECTURA",16,"ERROR")
			Set Step On
			CANCEL
		ENDIF 
		
	ELSE
	
		if sqlexec(mcon1,"select PadCabe.ID , PadCabe.Apellido , PadCabe.grupofamiliar, " + ;
			"PadCabe.ApeyNom , PadCabe.CUIL , PadCabe.Credencial , PadCabe.Documento, " + ;
			"PadCabe.Entidad, PadCabe.FecEgreso , PadCabe.FecIngreso, " + ;
			"PadCabe.FecNac , PadCabe.Nombre , PadCabe.NroAfiliado, " + ;
			"PadCabe.NroAfiliadoAlternativo, PadCabe.Plan, PadCabe.PlanAlternativo, " + ;
			"PadCabe.Sexo, PadCabe.TipoDocumento, " + ;
			"entidades.ent_descrient, " + ;
			"Paddomicilio.Domicilio, Paddomicilio.FechaDesde, Paddomicilio.FechaHasta, " + ;
			"Paddomicilio.Localidad, Paddomicilio.Provincia, Paddomicilio.Telefono, " + ;
			"Paddomicilio.Id as IdDom, Paddomicilio.Codigo, " + ;
			"tabdocumentos.abrevio as TipoDocDes, nvl(padotrosdatos.contenido,'SG') AS Contenido, " + ;
			"planes.Descripcion as Des_planes " + ;
			"FROM PadCabe " + ;
			"left join padotrosdatos on  padotrosdatos.idpadcabe = padcabe.id and padotrosdatos.campo = 'EMERGENCIA' " + ;
				" and PadOtrosDatos.fechahasta = ?ldFecTop " +;
			"left join entidades on entidad = ent_codent " + ;
			"left join tabdocumentos on PadCabe.TipoDocumento= tabdocumentos.codigovax " + ;
			"Inner Join Paddomicilio on PadCabe.ID = Paddomicilio.IdPadCabe " + ;
			"left join planes on padcabe.plan = planes.id " + ;
			"" + mbusco1  + "  " + ;
			" Group By PadCabe.Id " + ;
			" Order by Paddomicilio.Id Desc " , "mwkbuspadron") <=0

			Messagebox("DE LECTURA",16,"ERROR")
			Set Step On
			Canc
		
		Endif 

		
	Endif 
	

	
	
*!*		Select Id ,Apeynom, Documento, Entidad, Fecnac, ;
*!*			Nombre, Nroafiliado, Sexo, Tipodocumento, Ent_descrient, Domicilio, IdDom, ;
*!*			TipoDocDes, Localidad, Provincia, Codigo ; 
*!*			From mwkbuspadron2 ;
*!*			Group By Id ;
*!*			Into Cursor mwkbuspadron
		
*	do C:\desaguemes\Prg\sp_busco_padron with mbusco1, ''
	Set Step On
	Select mwkBusPadron
	Count To lnCountp
	
	Select mwkBusPadron
	Scan All 
		

		
		Select mwkBusPadron
		lcestado = " - " + Transform(Recno()) + " / " + Transform(lnCountp)
		=ESC_EST2("PROCESANDO AFILIADO " + Transform(mwkBusPadron.nroafiliado) + lcestado)
		
		
	*	Do c:\desaguemes\prg\sp_busco_padron_domic With mwkBusPadron.id
		
		*Select mwkBusPadDom
		*Go Top 
	*	lcDomicilio = Alltrim(mwkBusPadDom.domicilio)
		
		lcDomicilio = Alltrim(mwkBusPadron.Domicilio)
		lcApeynom = Alltrim(mwkBusPadron.apeynom)
		lnDocumento = mwkBusPadron.documento
		lnEntidad = lnCodEnt 
		ldFecnac = mwkBusPadron.fecnac
		lnNroafiliado = mwkBusPadron.nroafiliado
		lcSexo = Alltrim(mwkBusPadron.sexo)
		lnTipodocumento = mwkBusPadron.tipodocumento
		lnIdPadCabe = mwkBusPadron.id
		lcTipoDoc = Alltrim(mwkBusPadron.TipoDocDes)
		lcLocalidad = Alltrim(mwkBusPadron.Localidad)
		lcProvincia = Alltrim(mwkBusPadron.Provincia)
		lcCodigo = Alltrim(mwkBusPadron.Codigo)
		lnTipT = Iif(Alltrim(mwkBusPadron.Contenido) = "SG", 0, ;
			Iif(Alltrim(mwkBusPadron.Contenido) = "SOS", 1 , ;
			Iif(Alltrim(mwkBusPadron.Contenido) = "SC", 2 , 0)))
		lcPlan = Alltrim(Nvl(mwkBusPadron.Des_planes,Space(25)))
			
			

		If Sqlexec(mconSql,"Insert into Sg_Padrones (" + ;
			"Apeynom, Documento, Entidad, Fecnac, " + ;
			"Nroafiliado, Sexo, Tipodocumento, Domicilio, IdPadCabe, " + ;
			" localidad, provincia, CP, Tipo, [Plan] ) Values " + ;
			" ( ?lcApeynom, ?lnDocumento, ?lnEntidad, ?ldFecnac, " + ;
			" ?lnNroafiliado, ?lcSexo, ?lcTipoDoc , ?lcDomicilio, ?lnIdPadCabe, " + ;
			"?lcLocalidad, ?lcProvincia, ?lcCodigo, ?lnTipT, ?lcPlan ) ")  <=0  
			
			Messagebox("AL GUARDAR",16,"ERROR")
			Set Step On
			Canc
		Endif 
		
		Select mwkBusPadron
	Endscan 	


Select mwkEntidades
Endscan 

=ESC_EST("ELIMINANDO SELECCION")
=ESC_EST2("")

If Sqlexec(mconSql,"Delete from Sg_Padrones Where Borrar = 1 ") <= 0
	Messagebox("AL BORRAR SELECCION",16,"ERROR")
	Set Step On
	Canc
Endif 

ltfechoy = sp_busco_fecha_serv('DT')
@8,1 Say "Fecha Fin " + Ttoc(ltfechoy)

=ESC_EST("FIN DEL PROCESO")

Sqldisconnect(mconSql)
Sqldisconnect(mcon1)
*-----------------------------------------------------
Procedure ESC_EST
Lparameters lcTxt
*-----------------------------------------------------
@6,1 CLEAR
@6,1 Say "SubEstado " + lcTxt

*-----------------------------------------------------
Procedure ESC_EST2
Lparameters lcTxt
*-----------------------------------------------------
@7,1 CLEAR
@7,1 Say "Estado " + lcTxt



*!*		sqlexec(mcon1,"select PadCabe.ID , PadCabe.Apellido , PadCabe.grupofamiliar, " + ;
*!*			"PadCabe.ApeyNom , PadCabe.CUIL , PadCabe.Credencial , PadCabe.Documento, " + ;
*!*			"PadCabe.Entidad, PadCabe.FecEgreso , PadCabe.FecIngreso, " + ;
*!*			"PadCabe.FecNac , PadCabe.Nombre , PadCabe.NroAfiliado, " + ;
*!*			"PadCabe.NroAfiliadoAlternativo, PadCabe.Plan, PadCabe.PlanAlternativo, " + ;
*!*			"PadCabe.Sexo, PadCabe.TipoDocumento, " + ;
*!*			"entidades.ent_descrient, " + ;
*!*			"Paddomicilio.Domicilio, Paddomicilio.FechaDesde, Paddomicilio.FechaHasta, " + ;
*!*			"Paddomicilio.Localidad, Paddomicilio.Provincia, Paddomicilio.Telefono, " + ;
*!*			"Paddomicilio.Id as IdDom, Paddomicilio.Codigo, " + ;
*!*			"tabdocumentos.abrevio as TipoDocDes " + ;
*!*			"FROM PadCabe " + ;
*!*			"left join entidades on entidad = ent_codent " + ;
*!*			"left join tabdocumentos on PadCabe.TipoDocumento= tabdocumentos.codigovax " + ;
*!*			"Inner Join Paddomicilio on PadCabe.ID = IdPadCabe " + ;
*!*			"" + mbusco1  + "  " + ;
*!*			"" , "mwkbuspadron2")