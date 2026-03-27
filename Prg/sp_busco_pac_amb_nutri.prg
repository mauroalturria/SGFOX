Lparameters mFechaIni, mFechaFin, mbusco

&& PARA HACER PRUEBAS
mFechaInig = mFechaIni-1
*!*	mFechaFin = Ctod("06/04/2011") + 1
*!*	mbusco = ''

*!*	PACIENTES AMBULATORIOS DE NUTRICION

Local mfechanull
mfechanull = Ctod("01/01/1900")

mret = SQLExec(mcon1, "select guardia.protocolo, fechahoraing, REG_nombrepac, " + ;
	"nombre, codprest, ent_descrient, Prestacions.pre_descriprest, " + ;
	"Prestacions.pre_especialidad, fechahoraate, codestado, guardia.id, " + ;
	"prioridad, guardiavale.nrovale, pia_codprest, " + ;
	"afi_nroafiliado,  " + ;
	"esp_descripcion, guardia.codent, guardiavale.codserv, guardia.codmed, " + ;
	"nroregistrac, guardia.usuario, ptovta, tpocte, nrocte, letracte, fechacte, nroregistracio, " + ;
	"val_horasolicitud, val_fechasolicitud, val_codvaleasist, tipoest,tabtipoaltas.sector, descrip, " + ;
	"val_prestador, val_codservvale, val_bono, pia_cantsolicitada, " + ;
	"Presta.pre_descriprest as diagnostico, TabCiap2E.DescrAbrev as descie, val_operadorcarga, " + ;
	"Reg_nrohclinica, Reg_numdocumento, Reg_telefonos, Reg_domicilio, REG_fecnacimiento " + ;
	"from guardia " + ;
	"Inner join tabtipoaltas on guardia.codestado = tabtipoaltas.id " + ;
	"left outer join guardiavale on guardia.protocolo = guardiavale.protocolo " + ;
	"Inner join valesasist on guardiavale.nrovale = val_codvaleasist " + ;
	"Inner join presinsuvas on presinsuvas.pia_valesasist = val_codpun " + ;
	"Inner join prestacions on pia_codprest = prestacions.pre_codprest " + ;
	"Inner join prestacions presta on Guardia.CodPrest = presta.pre_codprest " + ;
	"left outer join entidades on guardia.codent = entidades.ent_codent " + ;
	"left outer join especialid on prestacions.pre_especialidad = especialid.esp_codesp " + ;
	"left outer join registracio on guardia.nroregistrac = registracio.reg_nroregistrac " + ;
	"left outer join prestadores on guardia.codmed = prestadores.id " + ;
	"left outer join tabfacturas on tabfacturas.codpun 	= valesasist.val_codpun " +;
	"left outer join TabCiap2E on TabCiap2E.Id = guardia.codcie9 "+;
	"Inner join afiliacion on guardia.nroregistrac = afiliacion.registracio and " + ;
		"guardia.codent = afiliacion.afi_codentidad " + ;
	"where " + ;
	"val_fechasolicitud >= ?mFechaIni and " + ;
	"val_fechasolicitud < ?mFechaFin and " + ;
	"VAL_codservvale = 9400 and VAL_codsector = 'GUA' " + ;
	"" + mbusco + " " + ;
	"Group by  guardia.Protocolo ", "mwknutripacamb")
		
If mRet <= 0
	Messagebox("ERROR DE LECTURA ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

*------------------------------------------------------------------------------------
*!*	ANAMNESIS DE LOS PACIENTES 
*------------------------------------------------------------------------------------
	
mret = sqlexec(mcon1, "select TNH_fecha, " + ;
	"TNH_anamnesis, TNH_registracio, cast(0 as Integer) as cometodo, " + ;
	"Guardia.protocolo, Guardia.nroregistrac " + ;
	"from guardia " + ;
	"left join TabNutHpac on GUARDIA.nroregistrac = TabNutHpac.TNH_registracio " + ; 
	"where guardia.fechahoraing >= ?mFechaIni and " + ;
	"guardia.fechahoraing < ?mFechaFin " + ;
	"", "mwknuthana02")

If mRet <= 0
	Messagebox("ERROR DE LECTURA ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

select *  ; 
	from mwknuthana02 ; 
	order by tnh_fecha  ; 
	group by nroregistrac ; 
	into cursor mwknuthana1

Use In mwknuthana02

*!*	-----------------------------------------------------------------------------------------
*!*	DETALLE
*!*	-----------------------------------------------------------------------------------------
mret = sqlexec(mcon1, "select TabNutPacAmb.*, " + ;
	"TabNutPrest.TNP_codfactu, TabNutPrest.TNP_factura, TabNutPrest.TNP_dieta, " + ; 
	"TabNutDetAmb.TND_idPaciente, TabNutDetAmb.TND_codPrest, TabNutDetAmb.TND_NroVale, " + ;
	"TabNutDetAmb.TND_FHoraCarga, TabNutDetAmb.TND_observa, TabNutDetAmb.TND_hora, " + ;
	"TabNutDetAmb.TND_FHoraCarga " + ; 
	"from TabNutPacAmb " + ; 
	"left join TabNutDetAmb on TabNutDetAmb.TND_idPaciente = TabNutPacAmb.id and tnd_fecbaja = ?mfechanull " +  ; 
	"left join TabNutPrest on TabNutPrest.TNP_codPrest = TabNutDetAmb.TND_codPrest " +  ; 
	"where TabNutPacAmb.TNP_Fecha = ?mFechaIni " , "mwknutdet1")

If mRet <= 0
	Messagebox("ERROR DE LECTURA ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 	
*------------------------------------------------------------------------------------

select mwknutripacamb.*, ;
	mwknutdet1.Id as IdDet, ;
	mwknutdet1.Tnp_fecimp, tnp_observaciones, ;
	nvl(mwknutdet1.Tnp_fecha, mFechaIni) as tnp_fecha, ; 
	nvl(tnp_codserv, 0) as tnp_codserv, ; 
	iif(tnp_codserv = 0, tnp_codfact, space(50)) as tnp_codfact0, ; 
	iif(tnp_codserv > 0, tnp_codfact, space(50)) as tnp_codfact, ; 
	iif(mod(nvl(tnp_codserv, 0), 2) = 1 and nvl(tnp_codserv, 0) > 0, ;
		nvl(tnp_codfact, space(50)), space(50)) as tnp_codfact1, ; 
	iif(mod(nvl(tnp_codserv, 0), 2) = 0 and nvl(tnp_codserv, 0) > 0, ;
		nvl(tnp_codfact, space(50)), space(50)) as tnp_codfact2, ; 
	iif(mod(nvl(tnp_codserv, 0), 2) = 1 and nvl(tnp_codserv, 0) > 0, ;
		nvl(tnp_observaciones, space(200)), space(200)) as tnp_observaciones1, ; 
	iif(mod(nvl(tnp_codserv, 0), 2) = 0 and nvl(tnp_codserv, 0) > 0,  ; 
	nvl(tnp_observaciones, space(200)), space(200)) as tnp_observaciones2, ; 
	nvl(tnp_usuario, 00000) as tnp_usuario, ;
	iif(tnp_codserv=0, TND_observa, space(250)) as observaciones, ; 
	mwknutdet1.Tnp_modi, ;
	mwknutdet1.Tnp_protocolo, mwknutdet1.Tnp_codfactu, ; 
	mwknutdet1.Tnp_factura, mwknutdet1.Tnp_dieta, ;
	mwknutdet1.Tnd_idpaciente, mwknutdet1.Tnd_codprest, ;
	mwknutdet1.Tnd_nrovale, mwknutdet1.Tnd_fhoracarga, ;
	mwknutdet1.Tnd_observa, mwknutdet1.Tnd_hora, ;
	mwknutdet1.Tnd_fhoracarga1, ;
	mwknuthana1.tnh_anamnesis,  mwknuthana1.cometodo, ;
	iif(isnull(tnh_anamnesis), ' ', iif(cometodo=1, '=', '*')) as hanam; 
	from mwknutripacamb ; 
	left join mwknutdet1 on mwknutripacamb.Protocolo = mwknutdet1.TNP_Protocolo  ; 
	Left Join mwknuthana1 On mwknuthana1.nroregistrac = mwknutripacamb.nroregistrac ;
	into cursor mwknutact1

*------------------------------------------------------------------------------------	
