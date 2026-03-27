****
** busco pacientes internados y ambulatorios en quirofano
*!*	Clear
*!*	Do sp_conexion
*!*	msql_pac = ''
*!*	mfecdes  = ctod("01/01/2001")
*!*	mfechas  = ctod("01/01/2009")
****

Parameters msql_pac, mfecdes, mfechas

mbusco1 	= " and pac_fechaadmision >= ?mfecdes "
mfecant1    = mfecdes - 1
mfechahora  = sp_busco_fecha_serv('DT')
mbuscofecha =''
If mfechas < Ttod(mwkfecserv.fechahora)
	mfechas = mfechas+1
	mbuscofecha =" where fechaHoraQuir < mfechas "
Endif

*!*	--------------------------------------------------------------
*!*	Gustavo Fittipaldi, 2015-03-12
*!*	-------------------------------------------------------------- 

Text To lcSql Textmerge Noshow Pretext 7

select
        TabProtQuir.*,
        Pacientes.Pac_nombrepaciente, Pacientes.Pac_habitacion, Pacientes.Pac_cama,
        Pacientes.Pac_sexo, Pacientes.Pac_edad, Pacientes.Pac_codadmision,
        Pacientes.Pac_fechaadmision, Pacientes.Pac_horaadmision, Pacientes.Pac_codhci,
        Pacientes.Pac_codhce,
        Pacientes.Pac_descripdiagn, Pacientes.Pac_fechaalta, Pacientes.Pac_categoria,
        Pacientes.Pac_domicilio,
        Afiliacion.AFI_nroafiliado,
        Entidades.ENT_codent, Entidades.ENT_descrient,
        Sectores.Sec_codsector, Sectores.Sec_descripsec,
        Tabquiroflog.FechaMod,
        Lugarintern.lug_pacientes, Lugarintern.lug_fechaingreso, Lugarintern.lug_horaingreso,Tabquirofano.FechaQuirof
    from TabProtQuir
         Inner join pacientes on pacientes.pac_codadmision = TabProtQuir.Codadmision  and pac_fechaadmision >= ?mfecdes
         Inner join coberturas on coberturas.cob_pacientes = pacientes.PAC_codadmision
         Inner join entidades on coberturas.cob_codentidad = entidades.ENT_codent
         Inner join sectores on pacientes.PAC_sectorinternac = sectores.sec_codsector
         left join lugarintern on lug_pacientes = pac_codadmision
         left join Tabquiroflog  on IdTabQuirofano = TabProtQuir.quirofano
         left join Tabquirofano on  TabQuirofano.id = TabProtQuir.quirofano
         left join tabusuario on PAC_operadm = tabusuario.codigovax
         left join afiliacion on PAC_codhci = registracio and cob_codentidad = AFI_codentidad
        where exists(select 1 from TabProtQuir where TipoPac = 1 and fechaHoraQuir >= ?mfecant1) 
        and TipoPac = 1 and fechaHoraQuir >= ?mfecant1

Endtext         
mret = SqlExec(mcon1, lcSql, "mwkpacint01"	)

*!*	*!*	--------------------------------------------------------------
*!*	*!*	Gustavo Fittipaldi, 01/11/2013
*!*	*!*	-------------------------------------------------------------- 
*!*	mret = SqlExec(mcon1, "select " + ;
*!*		"TabProtQuir.*, " + ;
*!*		"Pacientes.Pac_nombrepaciente, Pacientes.Pac_habitacion, Pacientes.Pac_cama, " + ;
*!*		"Pacientes.Pac_sexo, Pacientes.Pac_edad, Pacientes.Pac_codadmision, " + ;
*!*		"Pacientes.Pac_fechaadmision, Pacientes.Pac_horaadmision, Pacientes.Pac_codhci, " + ;
*!*		"Pacientes.Pac_codhce, " + ;
*!*		"Pacientes.Pac_descripdiagn, Pacientes.Pac_fechaalta, Pacientes.Pac_categoria, " + ;
*!*		"Pacientes.Pac_domicilio, " + ;
*!*		"Afiliacion.AFI_nroafiliado, " + ;
*!*		"Entidades.ENT_codent, Entidades.ENT_descrient, " + ;
*!*		"Sectores.Sec_codsector, Sectores.Sec_descripsec, " + ;
*!*		"Tabquiroflog.FechaMod, " + ;
*!*		"Lugarintern.lug_pacientes, Lugarintern.lug_fechaingreso, Lugarintern.lug_horaingreso " + ;
*!*		"from TabProtQuir " + ;
*!*		" Inner join pacientes on pacientes.pac_codadmision = TabProtQuir.Codadmision  " + ;
*!*		" Inner join coberturas on coberturas.cob_pacientes = pacientes.PAC_codadmision " + ;
*!*		" Inner join entidades on coberturas.cob_codentidad = entidades.ENT_codent " + ;
*!*		" Inner join sectores on pacientes.PAC_sectorinternac = sectores.sec_codsector " + ;
*!*		" left join lugarintern on lug_pacientes = pac_codadmision "+;
*!*		" left join Tabquiroflog  on IdTabQuirofano = TabProtQuir.id   "+;
*!*		" left join tabusuario on PAC_operadm = tabusuario.codigovax " +;
*!*		" left join afiliacion on PAC_codhci = registracio and cob_codentidad = AFI_codentidad  " + ;
*!*		"where TipoPac = 1 "+ mbusco1 , "mwkpacint01")

*!*	V5	 
*!*	mret = SqlExec(mcon1, "select " + ;
*!*		"TabProtQuir.*, " + ;
*!*		"Pacientes.Pac_nombrepaciente, Pacientes.Pac_habitacion, Pacientes.Pac_cama, " + ;
*!*		"Pacientes.Pac_sexo, Pacientes.Pac_edad, Pacientes.Pac_codadmision, " + ;
*!*		"Pacientes.Pac_fechaadmision, Pacientes.Pac_horaadmision, Pacientes.Pac_codhci, " + ;
*!*		"Pacientes.Pac_codhce, " + ;
*!*		"Pacientes.Pac_descripdiagn, Pacientes.Pac_fechaalta, Pacientes.Pac_categoria, " + ;
*!*		"Pacientes.Pac_domicilio, " + ;
*!*		"Afiliacion.AFI_nroafiliado, " + ;
*!*		"Entidades.ENT_codent, Entidades.ENT_descrient, " + ;
*!*		"Sectores.Sec_codsector, Sectores.Sec_descripsec, " + ;
*!*		"Tabquiroflog.FechaMod, " + ;
*!*		"Lugarintern.lug_pacientes, Lugarintern.lug_fechaingreso, Lugarintern.lug_horaingreso " + ;
*!*		"from TabProtQuir, pacientes ,coberturas ,entidades, sectores " + ;
*!*		" left join  pacinternad on pin_codadmision = pac_codadmision "+;
*!*		" left join  lugarintern on lug_pacientes = pin_codadmision "+;
*!*		"left join Tabquiroflog "+;
*!*		" on IdTabQuirofano = TabProtQuir.id   "+;
*!*		"left join  tabusuario on PAC_operadm = tabusuario.codigovax " +;
*!*		"left join  afiliacion on " +;
*!*		"	PAC_codhci = registracio and " + ;
*!*		"	cob_codentidad = AFI_codentidad  " + ;
*!*		"where cob_pacientes = PAC_codadmision and cob_codentidad   = ENT_codent "+;
*!*		"and pac_codadmision = Codadmision and " + ;
*!*		"PAC_sectorinternac = sec_codsector and TipoPac = 1"+ mbusco1 , "mwkpacint01")

If mret<1
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
 	=Aerror(eros)
	Messagebox(eros(3)  )
	Messagebox(eros(3))
	Cancel
Endif

*!*	mret = SqlExec(mcon1, "select " + ;
*!*		"TabProtQuir.*, " + ;
*!*		"Pacientes.Pac_nombrepaciente, Pacientes.Pac_habitacion, Pacientes.Pac_cama, " + ;
*!*		"Pacientes.Pac_sexo, Pacientes.Pac_edad, Pacientes.Pac_codadmision, " + ;
*!*		"Pacientes.Pac_fechaadmision, Pacientes.Pac_horaadmision, Pacientes.Pac_codhci, " + ;
*!*		"Pacientes.Pac_codhce, " + ;
*!*		"Pacientes.Pac_descripdiagn, Pacientes.Pac_fechaalta, Pacientes.Pac_categoria, " + ;
*!*		"Pacientes.Pac_domicilio, " + ;
*!*		"Entidades.ENT_codent, Entidades.ENT_descrient, " + ;
*!*		"Tabquiroflog.FechaMod, " + ;
*!*		"Afiliacion.AFI_nroafiliado " + ;
*!*		"From TabProtQuir " + ;
*!*		"Inner Join histambgua on histambgua.his_codadmision = TabProtQuir.Codadmision " + ;
*!*		"Inner Join Entidades on histambgua.HIS_codentidad = Entidades.ENT_codent " + ;
*!*		"Inner Join Pacientes on Pacientes.PAC_codhci = histambgua.his_nroregistrac " + ;
*!*		"and PAC_codadmision = TabProtQuir.Codadmision " + ;
*!*		"left Join Tabquiroflog on IdTabQuirofano = TabProtQuir.id  "+;
*!*		"left Join afiliacion on PAC_codhci = registracio and HIS_codentidad = AFI_codentidad " + ;
*!*		"Where " + ;
*!*	    "Tabprotquir.TipoPac = 2 &mbusco1 " + ;
*!*		"", "mwkpacint02")	

Text To lcSql Textmerge Noshow Pretext 7

select  TabProtQuir.*,  
	Pacientes.Pac_nombrepaciente, Pacientes.Pac_habitacion, Pacientes.Pac_cama, 
	Pacientes.Pac_sexo, Pacientes.Pac_edad, Pacientes.Pac_codadmision, 
	Pacientes.Pac_fechaadmision, Pacientes.Pac_horaadmision, Pacientes.Pac_codhci, 
	Pacientes.Pac_codhce, 
	Pacientes.Pac_descripdiagn, Pacientes.Pac_fechaalta, Pacientes.Pac_categoria, 
	Pacientes.Pac_domicilio, 
	Entidades.ENT_codent, Entidades.ENT_descrient, 
	Tabquiroflog.FechaMod, 
	Afiliacion.AFI_nroafiliado,Tabquirofano.FechaQuirof 
    from TabProtQuir
	Inner Join histambgua on histambgua.his_codadmision = TabProtQuir.Codadmision 
	Inner Join Entidades on histambgua.HIS_codentidad = Entidades.ENT_codent 
	Inner Join Pacientes on Pacientes.PAC_codhci = histambgua.his_nroregistrac and 
		PAC_codadmision = TabProtQuir.Codadmision and pac_fechaadmision >= ?mfecdes 
	left Join Tabquiroflog on IdTabQuirofano = TabProtQuir.quirofano
	left join Tabquirofano on  TabQuirofano.id = TabProtQuir.quirofano
	left Join afiliacion on PAC_codhci = registracio and HIS_codentidad = AFI_codentidad 
        where exists(select 1 from TabProtQuir where TipoPac = 2 and fechaHoraQuir >= ?mfecant1) 
        and TipoPac = 2 and fechaHoraQuir >= ?mfecant1 

Endtext         


mret = SqlExec(mcon1, lcSql, "mwkpacint02"	)

	
If mret<1 
Do show_error
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
 	=Aerror(eros)
	Messagebox(eros(3)  )
	Messagebox(eros(3))
	Cancel
Endif

Select PAC_nombrepaciente, ;
	Sec_CodSector, Sec_DescripSec, ;
	PAC_habitacion, PAC_cama, ENT_descrient, ;
	PAC_sexo, PAC_edad, PAC_codadmision, PAC_fechaadmision, ;
	PAC_horaadmision, PAC_codhci, ;
	PAC_codhce, AFI_nroafiliado, PAC_descripdiagn, ;
	PAC_fechaalta, PAC_categoria, pac_domicilio, ENT_codent,;
	ID, CodMedicoAdm, Codadmision, FechaHoraQuir, ;
	FirmaConsentimiento, MedicoAdmision, Observa,Observado, Quirofano, ;
	TipoPac, Urgencia, codcie10diagn, descripdiagn, ;
	FechaMod, lug_pacientes, lug_fechaingreso, lug_horaingreso,FechaQuirof,  ;
	Count(PAC_codadmision) As cant ;
	From mwkpacint01 ;
	Group By PAC_codadmision ;
Union ;
	Select PAC_nombrepaciente, ;
	'' As Sec_CodSector, '' As Sec_DescripSec, ;
	PAC_habitacion, PAC_cama, ENT_descrient, ;
	PAC_sexo, PAC_edad, PAC_codadmision, PAC_fechaadmision, ;
	PAC_horaadmision, PAC_codhci, ;
	PAC_codhce, AFI_nroafiliado, PAC_descripdiagn, ;
	PAC_fechaalta, PAC_categoria, pac_domicilio, ENT_codent, ;
	ID, CodMedicoAdm, Codadmision, FechaHoraQuir, ;
	FirmaConsentimiento, MedicoAdmision, Observa,Observado, Quirofano, ;
	TipoPac, Urgencia, codcie10diagn, descripdiagn, ;
	FechaMod, ;
	'' as lug_pacientes, ctod('') as lug_fechaingreso, ctot('') as lug_horaingreso,FechaQuirof , ; 
	Count(PAC_codadmision) As cant ;
	From mwkpacint02 ;
	Group By PAC_codadmision ;
	Into Cursor mwkpacint0
	
Use in mwkpacint02
Use in mwkpacint01
*!* --------------------------------------------------------------------------- 
mret = SqlExec(mcon1, "select fecpasiva, codent from entidexclu where tpopac = 'INT' ","mwkentex")
If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
 	Return .f.
Endif  
*!* --------------------------------------------------------------------------- 

Select * ;
	From mwkpacint0 ;
	Left Join mwkentex on codent = ENT_codent ;
	 Into Cursor mwkpacint0

Use in mwkentex

Select PAC_nombrepaciente, ;
	Iif(Nvl(FechaHoraQuir,Ctot("01/01/1900"))< Ttod(mfechahora), ;
		Hour(PAC_horaadmision) * 100 + Minute(PAC_horaadmision), ;
		Hour(FechaHoraQuir) * 100 + Minute(FechaHoraQuir)) As PAC_horaadmision, ;
	Nvl(PAC_habitacion, "    " ) + "-" + Nvl(PAC_cama,"  ") As PAC_cama, ;
	Iif( !empty( Nvl(PAC_descripdiagn,'') ), ;
		Padr( Alltrim(Nvl(PAC_descripdiagn,'')),50), ;
		Padr( Alltrim(Nvl(descripdiagn,'')),50) ) As PAC_descripdiagn, ;
	Nvl(MedicoAdmision,Space(30)) As MedicoAdmision, ;
	Iif(!FirmaConsentimiento,"SI","NO") As FC, ;
	Iif(IsNull(FechaMod),"        ","Cumplido") As firmo, ;
	ENT_descrient, ;
	Observa, ;
	PAC_codadmision, ;
	Sec_CodSector, ;
	Nvl(Sec_DescripSec,Space(50)) As Sec_DescripSec, ;
	PAC_sexo, PAC_edad, PAC_fechaadmision, PAC_codhce, ;
	Nvl(PAC_categoria,"      ") As PAC_categoria, ;
	Iif(IsNull(mwkpacint0.fecpasiva),'  ','PE') As PAC_excl, ;
	Iif(IsNull(PAC_fechaalta),"          ", Dtoc(PAC_fechaalta)) As PAC_fechaalta, ;
	AFI_nroafiliado, ;
	Iif(IsNull(FechaMod),Space(19),Ttoc(FechaMod)) As FechaMod, ;
	PAC_codhci, TipoPac, pac_domicilio, ENT_codent, Observado,;
	mfechahora - Ctot(Dtoc(lug_fechaingreso) + '  ' + SubStr(Ttoc(lug_horaingreso),12)) As diferencia, ;
	cant,id,FechaQuirof  ;
	From mwkpacint0 &mbuscofecha;
	Group By PAC_codadmision ;
	Order By PAC_nombrepaciente ;
	Into Cursor mwkpacint

msql_pac = "select * " + ;
	"from mwkpacint " + ;
	"order by PAC_fechaadmision DESC, PAC_horaadmision DESC " + ;
	"into cursor mwkpacint1 "
