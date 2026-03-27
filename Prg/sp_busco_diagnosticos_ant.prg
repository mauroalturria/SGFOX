*!*	busca los diagnosticos de guardia

parameter mnivel, mfecha1, mfecha2, mbusca

mf1 = prg_dtoc(mfecha1)
mf2 = prg_dtoc(mfecha2+1)
mret = SQLExec(mcon1,"SELECT Capitulo, Letra FROM TabCiapCap ", "mwkcompo" )

mfecnul = CTOD("01/01/1900")
mret = sqlexec(mcon1, "select  ID , Codigo , Componente , Criterio , "+;
	"DescrAbrev , Descripcion , Excluye , Incluye,fecanula "+;
	" from  TabCiap2E  "	, "mwkCiap2e")  
if mnivel = 1
	mret = SqlExec(mcon1, "Select TabCiap2E.descripcion,TabCie10.descrip as descripcie9 , Guardia.FechaHoraIng,  " + ;
		"Guardia.FechaHoraAte, Guardia.Protocolo, Guardia.codCIE9,TabCiap2E.componente " + ;
		",TabCiap2E.codigo ,TabCie10.codcie10 "+;
		"from  Guardia " + ;
		"left join TabCiap2E on  Guardia.codcie9 = TabCiap2E.Id " + ;
		"left join TabCiapCap on TabCiapCap.id = TabCiap2E.componente " + ;
		"left join TabCie10 ON ( Guardia.codcie9 = TabCie10.Id and TabCie10.tipo =3)" + ;
		"Where Guardia.codcie9 >0 " + mbusca +;
		"And Guardia.FechaHoraIng >= ?mf1 and Guardia.codmed>1 " + ;
		"And Guardia.FechaHoraIng < ?mf2 group by protocolo" , "mwkDiagGuar")
else
	mret = SQLExec(mcon1,"SELECT id, nombre FROM prestadores  " + ;
		" union  SELECT ID , nombre FROM TabMedExterno " + ;
		" where gerenciadora = 0 " +;
		"ORDER BY nombre", "mwkMedgua" )

	mret = SqlExec(mcon1, "Select TabCiap2E.descripcion,Guardia.FechaHoraIng,Guardia.codprest, " + ;
		"Guardia.FechaHoraAte, Guardia.Protocolo, Guardia.codCIE9,Guardia.codmedcie9,  " + ;
		"Registracio.Reg_NroHClinica, Registracio.Reg_NombrePac, Registracio.Reg_FecNacimiento, Registracio.Reg_sexo, " + ;
		"Entidades.Ent_DescriEnt,tabtipoaltas.descrip, TabGuaMsg.TGM_Mensaje,TabCiap2E.componente " + ;
		",TabCiap2E.codigo ,TabCie10.codcie10 "+;
		"from  Guardia, Registracio, Entidades,tabtipoaltas " + ;
		"left join TabCiap2E on  Guardia.codcie9 = TabCiap2E.Id " + ;
		"left join TabGuaMsg on TabGuaMsg.TGM_Protocolo = Guardia.protocolo " + ;
		"left join TabCiapCap on TabCiapCap.id = TabCiap2E.componente " + ;
		"Where Guardia.codcie9 >0 "  + mbusca +;
		" and guardia.codestado 		= tabtipoaltas.id " + ;
		"And Guardia.FechaHoraIng >= ?mf1 " + ;
		"And Guardia.FechaHoraIng < ?mf2 " + ;
		"And Guardia.NroRegistrac = Registracio.REG_NroRegistrac " + ;
		"And Entidades.Ent_CodEnt = Guardia.CodEnt "+;
		" and Guardia.codmed>1 ", "mwkDiagGuar")


endif
if mret <= 0
	messagebox("ERROR EN LA CONSULTA DE LOS DATOS", 48, "VALIDACION")
	cancel
endif
