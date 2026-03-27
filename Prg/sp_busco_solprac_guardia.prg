****
** busca los protocolo de guardia para la grilla
****
Parameter mcual,mfecha1,mbuscog

If Vartype(mbuscog )<>"C"
	mbuscog =''
Endif
mfechactr = sp_busco_fecha_serv('DT')
If Type("mfecha1")="T"
	mfecha = mfecha1
Else
	mfecha = mfechactr - 86400  && 57600 && 16hs   &&  86400  &&  24hs
Endif
If mwkusuario.codigovax = 54035
*	Set Step On
Endif
mfechaobs = mfechactr - 14400  && 4 horas
mf1 = prg_dtoc(mfecha1)

mret = SQLExec(mcon1,"SELECT ID , nombre FROM TabMedExterno "+;
	"where exists(select 1 from TabMedExterno where gerenciadora = 0 ) and gerenciadora = 0 ", "mwkMedicogua01" )
	mret = SQLExec(mcon1, "select TGM_protocolo ,TGM_Fechah , TGM_estado , TGM_mensaje , TGM_usuario  " + ;
			" from TabGuaMsg " + ;
			" where TGM_Fechah >= ?mfecha and TGM_estado <> 9 and TGM_codmed = 1 " + ;
			" ", "mwkprotomsg")
mret = SQLExec(mcon1, "select guardia.protocolo, fechahoraing, REG_nombrepac, nombre, codprest, ENT_descrient " + ;
	",prestasol.PRE_descriprest as prestasolic, presta.PRE_especialidad, fechahoraate, codestado, guardia.id, prioridad " + ;
	",REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email,ESP_descripcion,ASP_codprest,AFI_nroafiliado "+;
	", guardia.codent, nroregistrac,guardia.codmed,guardia.ID, tipoest,puesto,descrip,codcie9,ASP_observa " + ;
	", tabtipoaltas.sector,REG_sexo,REG_fecnacimiento,REG_localidad,reg_numdocumento,presta.PRE_descriprest as prestacons "+;
	" from afiliacion , guardia inner join prestacions as presta on guardia.codprest =presta.PRE_codprest "+;
	" inner join entidades on guardia.codent =  entidades.ENT_codent "+;
	" inner join especialid on presta.PRE_especialidad = ESP_codesp "+;
	" inner join registracio on guardia.nroregistrac = registracio.REG_nroregistrac "+;
	" inner join TabSolPract on TabSolPract.ASP_protocolo = guardia.protocolo "+;
	" inner join prestacions as prestasol on ASP_codprest = prestasol.PRE_codprest " + ;
	" inner join tabtipoaltas on guardia.codestado 		= tabtipoaltas.id "+;
	" left outer join prestadores on guardia.codmed = prestadores.id " + ;
	" where (guardia.nroregistrac = afiliacion.registracio and guardia.codent = afiliacion.AFI_codentidad) and "+;
	" guardia.fechahoraing >= ?mfecha and ASP_tipopac ='GUA' and presta.PRE_codservicio = 8000 " + mbuscog+;
	"", "mwkguardia0")


If Used("mwkMedicogua01" )
	Select protocolo, fechahoraing, REG_nombrepac, ;
		iif(Isnull(mwkguardia0.nombre) Or (Empty(mwkguardia0.nombre) And codmed>1),mwkMedicogua01.nombre,mwkguardia0.nombre) As nombre, ;
		codprest, ENT_descrient, ;
		prestasolic,prestacons , PRE_especialidad, fechahoraate, codestado, mwkguardia0.Id, prioridad, ;
		REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, ESP_descripcion,ASP_observa,;
		codent, nroregistrac,mwkguardia0.codmed,tpopac,tipoest,Nvl(puesto,0) As puesto,Descrip ;
		,codentexc,fecpasiva,tpopac,codcie9,descripcion,mwkprotomsg.*,sector,reg_numdocumento,ASP_codprest, AFI_nroafiliado,    ;
		REG_sexo,REG_fecnacimiento,REG_localidad,prg_vale_gua_prest(protocolo,ASP_codprest,TTOD(fechahoraing)) as vale ;
		from mwkguardia0 Left Join mwkMedicogua01 On codmed = mwkMedicogua01.Id  ;
		left Join mwkentexg On codent = codentexc ;
		left Join mwkprotomsg On protocolo = TGM_protocolo  ;
		left Join mwkciap2e On mwkciap2e.Id = codcie9 ;
		group By fechahoraing ,protocolo,codprest,ASP_codprest ,mwkguardia0.Id ;
		order By protocolo,prestasolic Into Cursor mwkguardia
Else
	Select * From mwkguardia0 ;
		left Join mwkentexg On codent = codentexc ;
		left Join mwkciap2e On mwkciap2e.Id = codcie9 ;
		left Join mwkprotomsg On protocolo = TGM_protocolo  ;
		into Cursor mwkguardia
Endif
