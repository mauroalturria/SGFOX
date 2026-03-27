****
** busca los protocolo de guardia para la grilla
** modificado el 2020-02 para agregarle los campos de triage en la consulta de sala de espera.
****
Parameter mcual,mfecha1,mfecha2,mbuscog,mbuscov,mtodos,mesta

If Vartype (mtodos)#"N"
	mtodos = 0
Endif
If Vartype (mbuscog)#"C"
	mbuscog = ''
Endif
If Type ('mbuscov')#"C"
	mbuscov = ''
Endif
mfechactr = sp_busco_fecha_serv('DT')
If Type("mfecha1")="T"
	mfecha = mfecha1
Else
	mfecha = mfechactr - 86400  && 57600 && 16hs   &&  86400  &&  24hs
Endif
If mwkusuario.codigovax = 54035
	Set Step On
Endif
*!*	if vartype(mfecha2)#"T"
*!*		mfecha2 = ttod(mfechactr )
*!*	endif

If !Inlist(Type("mfecha2"),"T","D")
	mfecha2 = Ttod(mfechactr)
Endif
mfechahoy = Ttod(mfechactr )
mfechaobs = mfechactr - 14400  && 4 horas
mf1 = prg_dtoc(mfecha1)
mf2 = prg_dtoc(mfecha2+1)
If !Used('mwkMedicoant')
	Do sp_busco_medrempzt With 1,,Ctot("01/01/1900"),Ctod("01/01/1900"),'INT','mwkmedicoant'

Endif
mret = SQLExec(mcon1,"SELECT ID , nombre FROM TabMedExterno where exists(select 1 from TabMedExterno where gerenciadora = 0 ) and gerenciadora = 0 ", "mwkMedicogua01" )
mitime = Seconds()
If mcual = 3  && si es desde hasta
	mret = SQLExec(mcon1, "select TGM_protocolo,TGM_Fechah , TGM_estado , TGM_mensaje , TGM_usuario  " + ;
		" from TabGuaMsg " + ;
		" where TGM_Fechah >= ?mf1 and TGM_Fechah< ?mf2 and TGM_estado <> 9 and TGM_codmed = 1 " + ;
		" ", "mwkprotomsg0")
Else
	mret = SQLExec(mcon1, "select TGM_protocolo ,TGM_Fechah , TGM_estado , TGM_mensaje , TGM_usuario  " + ;
		" from TabGuaMsg " + ;
		" where TGM_Fechah >= ?mfecha and TGM_estado <> 9 and TGM_codmed = 1 " + ;
		" ", "mwkprotomsg0")
Endif
mitime2 = Seconds()
*	messagebox(transfor(mitime2-mitime))
Select * From mwkprotomsg0 Order By TGM_protocolo,TGM_Fechah Group By TGM_protocolo  Into Cursor mwkprotomsg


mret = SQLExec(mcon1, "select nrotriage,valortriage,fechahoratriage,protocolo, fechahoraing, REG_nombrepac, codprest, ENT_descrient, " + ;
	"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, guardia.id, prioridad, " + ;
	"REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, AFI_nroafiliado, ESP_descripcion,"+;
	" guardia.codent, nroregistrac,guardia.codmed,guardia.ID, tipoest,puesto,descrip,codcie9  " + ;
	", tabtipoaltas.sector,REG_sexo,REG_fecnacimiento,REG_localidad,reg_numdocumento "+;
	"from prestacions, entidades, especialid, registracio, afiliacion," + ;
	"tabtipoaltas,guardia   " + ;
	"where guardia.nroregistrac = registracio.REG_nroregistrac and " + ;
	"guardia.nroregistrac = afiliacion.registracio and " + ;
	"guardia.codent = afiliacion.AFI_codentidad and " + ;
	"guardia.codprest = prestacions.PRE_codprest and " + ;
	"guardia.codestado 		= tabtipoaltas.id and " + ;
	"prestacions.PRE_especialidad = ESP_codesp and " + ;
	"guardia.codent	= entidades.ENT_codent and " + ;
	"guardia.fechahoraing >= ?mfecha and PRE_codservicio = 8000 " +mbuscog+ ;
	"", "mwkguardia0")

Select nrotriage,valortriage,fechahoratriage,protocolo, fechahoraing, REG_nombrepac,nombre, ;
	codprest, ENT_descrient, ;
	PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkguardia0.Id, prioridad, ;
	REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, AFI_nroafiliado, ESP_descripcion,;
	codent, nroregistrac,mwkguardia0.codmed,tpopac,tipoest,Nvl(puesto,0) As puesto,Descrip ;
	,codentexc,fecpasiva,tpopac,codcie9,descripcion,mwkprotomsg.*,sector,reg_numdocumento,     ;
	REG_sexo,REG_fecnacimiento,REG_localidad,Ttod(fechahoraate) As fechaaate ;
	from mwkguardia0 Left Join mwkMedicoant On codmed = mwkMedicoant.Id  ;
	left Join mwkentexg On codent = codentexc ;
	left Join mwkprotomsg On protocolo = TGM_protocolo  ;
	left Join mwkciap2e On mwkciap2e.Id = codcie9 ;
	group By fechahoraing ,protocolo,codprest,mwkguardia0.Id,AFI_nroafiliado ;
	order By fechahoraing Into Cursor mwkguardia1

mret = SQLExec(mcon1, "select  protocolo, fechahoraing, REG_nombrepac, codprest, ENT_descrient, " + ;
	"PRE_descriprest, PRE_especialidad, fechahoraate, codestado, Tabambulatorio.id,  " + ;
	"REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, AFI_nroafiliado, ESP_descripcion,"+;
	" Tabambulatorio.codent, nroregistrac,Tabambulatorio.codmed,Tabambulatorio.ID, tipoest,descrip,codcie9  " + ;
	", tabtipoaltas.sector,REG_sexo,REG_fecnacimiento,REG_localidad,reg_numdocumento "+;
	"from ZabRegCtgAgenda,prestacions, entidades, especialid, afiliacion," + ;
	"tabtipoaltas,Tabambulatorio " + ;
	" inner join registracio on  zca_registracion =  reg_nroregistrac "+;
	"where tabambulatorio.nroregistrac = registracio.reg_nroregistrac and " + ;
	"Tabambulatorio.nroregistrac = afiliacion.registracio and " + ;
	"Tabambulatorio.codent = afiliacion.AFI_codentidad and " + ;
	"Tabambulatorio.codprest = prestacions.PRE_codprest and " + ;
	"Tabambulatorio.codestado 		= tabtipoaltas.id and " + ;
	"prestacions.PRE_especialidad = ESP_codesp and " + ;
	"Tabambulatorio.codent	= entidades.ENT_codent and " + ;
	"Tabambulatorio.fechahoraing >= ?mfecha and ZCA_Fecha = ?mfechahoy  and ZCA_ESTADO  NOT IN (8,9) " +;
	" and Tabambulatorio.codestado = 63 ", "mwkambula0")
Select 0 As nrotriage,0 As valortriage,mfechactr  As fechahoratriage,protocolo, fechahoraing, REG_nombrepac,nombre, ;
	codprest, ENT_descrient, ;
	PRE_descriprest, PRE_especialidad, fechahoraate, codestado, mwkambula0.Id,0 As  prioridad, ;
	REG_nrohclinica, REG_telefonos, REG_domicilio,reg_email, AFI_nroafiliado, ESP_descripcion,;
	codent, nroregistrac,mwkambula0.codmed,tpopac,tipoest,0 As puesto,Descrip ;
	,codentexc,fecpasiva,tpopac,codcie9,descripcion,mwkprotomsg.*,sector,reg_numdocumento,     ;
	REG_sexo,REG_fecnacimiento,REG_localidad,Ttod(fechahoraate) As fechaaate ;
	from mwkambula0 Left Join mwkMedicoant On codmed = mwkMedicoant.Id  ;
	left Join mwkentexg On codent = codentexc ;
	left Join mwkprotomsg On protocolo = TGM_protocolo  ;
	left Join mwkciap2e On mwkciap2e.Id = codcie9 ;
	group By fechahoraing ,protocolo,codprest,mwkambula0.Id,AFI_nroafiliado ;
	order By fechahoraing Into Cursor mwkambula

If Reccount('mwkambula')>0
	Select * From mwkguardia1 Union All Select * From mwkambula Into Cursor mwkguardia
Else
	Select * From mwkguardia1   Into Cursor mwkguardia
Endif
