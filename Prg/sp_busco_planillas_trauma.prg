*!*	--------------------------------------------------------------------------
*!*	Planillas de pacientes Traumatizados
*!*	--------------------------------------------------------------------------
lparameters mbuscar

mret = sqlexec(mcon1,"SELECT Registracio.REG_nombrepac,REG_fecnacimiento,REG_nroregistrac, Reg_Sexo, " + ;
	"Guardia.fechahoraing, " + ;
	"Prestadores.Nombre as prestador,  " + ;
	"Prestacions.Pre_descriprest,  " + ;
	"Entidades.Ent_Descrient, " + ;
	"FT_estadoing->FTV_descripcion as FTD_estadoing, " + ;
	"FT_respira->FTV_descripcion as FTD_Respira, " + ;
	"FT_tas->FTV_descripcion as FTD_Tas, " + ;
	"FT_tipoTrau->FTV_descripcion as FTD_tipoTrau, " + ;
	"FT_circunst->FTV_descripcion as FTD_circunst, " + ;
	"FT_mecanismo->FTV_descripcion as FTD_mecanismo, " + ;
	"FT_estadoEgr->FTV_descripcion as FTD_estadoEgr, " + ;
	"TabFichaTraumatologica.*  " + ;
	"FROM TabFichaTraumatologica  " + ;
	"Inner join Guardia on Guardia.protocolo = TabFichaTraumatologica.FT_protocolo " + ;
	"Inner join Registracio on Guardia.nroregistrac = Registracio.REG_nroregistrac " + ;
	"Inner join Prestadores on Prestadores.Id = Guardia.Codmed " + ;
	"Inner join Prestacions on Prestacions.Pre_CodPrest = Guardia.codprest " + ;
	"Inner join Entidades on Entidades.Ent_CodEnt = Guardia.CodEnt " + ;
	"where 1=1 " + mbuscar,"mwktraumag")


if mret < 0
	=aerror(merror)

	messagebox("EN CONSULTA DE PLANILLAS DE PACIENTE TRAUMATIZADOS " + ;
		chr(10)+alltrim(merror(3))+chr(10) + ;
		"AVISE A SISTEMAS",16,"ERROR")

	return .f.
endif
mret = sqlexec(mcon1,"SELECT Registracio.REG_nombrepac,REG_fecnacimiento,REG_nroregistrac, Reg_Sexo, " + ;
	"pac_fechaadmision,pac_horaadmision , " + ;
	"pac_medicoadmision as prestador,  " + ;
	"pac_descripdiagn as Pre_descriprest,  " + ;
	"Entidades.Ent_Descrient, " + ;
	"FT_estadoing->FTV_descripcion as FTD_estadoing, " + ;
	"FT_respira->FTV_descripcion as FTD_Respira, " + ;
	"FT_tas->FTV_descripcion as FTD_Tas, " + ;
	"FT_tipoTrau->FTV_descripcion as FTD_tipoTrau, " + ;
	"FT_circunst->FTV_descripcion as FTD_circunst, " + ;
	"FT_mecanismo->FTV_descripcion as FTD_mecanismo, " + ;
	"FT_estadoEgr->FTV_descripcion as FTD_estadoEgr, " + ;
	"TabFichaTraumatologica.*  " + ;
	"FROM TabFichaTraumatologica  " + ;
	"Inner join pacientes on pacientes.pac_codadmision = TabFichaTraumatologica.FT_protocolo " + ;
	"Inner join coberturas on pacientes.pac_codadmision = cob_pacientes  " + ;
	"Inner join Registracio on pacientes.pac_codhci = Registracio.REG_nroregistrac " + ;
	"Inner join Entidades on Entidades.Ent_CodEnt = cob_codentidad " + ;
	"where 1=1 " + mbuscar+" group by TabFichaTraumatologica.id","mwktraumap")

if mret < 0
	=aerror(merror)

	messagebox("EN CONSULTA DE PLANILLAS DE PACIENTE TRAUMATIZADOS " + ;
		chr(10)+alltrim(merror(3))+chr(10) + ;
		"AVISE A SISTEMAS",16,"ERROR")

	return .f.
endif
if reccount("mwktraumap")>0
select REG_nombrepac,REG_fecnacimiento,REG_nroregistrac, Reg_Sexo, ;
		ctot(dtoc(pac_fechaadmision)+" "+ttoc(pac_horaadmision,2)) as fechahoraing,;
		padr(prestador,40) as prestador,padr(Pre_descriprest,45) as Pre_descriprest, Ent_Descrient, FTD_estadoing, FTD_Respira, FTD_Tas, ;
		FTD_tipoTrau, FTD_circunst, FTD_mecanismo, FTD_estadoEgr, ;
		id,FT_actran,FT_ambiente, FT_antTrauEsp, FT_aperOcular, FT_atendido, FT_circunst,;
		FT_complica, FT_compltip, FT_condicion, FT_condpre, FT_condtip, FT_deriva, FT_dervivo, FT_descr, FT_descsec,;
		FT_diasSala, FT_diasemana, FT_diasint, FT_diasucip, FT_distancia, FT_edad, FT_estadoEgr, FT_estadoing,;
		FT_estudios, FT_fecEgreso, FT_fechaIngr, FT_fechaTrau, FT_frecCar, FT_frecResp, FT_glasgow, FT_hce, FT_horaIngr,;
		FT_horaTrau, FT_hospint, FT_hsCTP, FT_hsinst, FT_indRts, FT_insinter, FT_intubado, FT_iss, FT_lugarinc,;
		FT_lugartemp, FT_manejoini, FT_manopc, FT_mecanismo, FT_operador, FT_pasajero, FT_privehicu, FT_proteccion,;
		FT_protocolo, FT_queint, FT_respMotora, FT_respVerbal, FT_respira, FT_secuelas, FT_segvehicu, FT_sexo,;
		FT_tas, FT_temperatura, FT_tipoTrau, FT_tipoinci, FT_transp, FT_transpu, FT_tratamiento, FT_tratamto,;
		FT_tratipo, FT_fechamov, FT_idusuario, FT_ipadress from mwktraumap;
		union all select * from mwktraumag;
		into cursor mwktraumas
else
	select * from mwktraumag into cursor mwktraumas
endif


