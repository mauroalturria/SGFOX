*!*	busca los diagnosticos de guardia

parameter mnivel, mfecha1, mfecha2, mbusca

mf1 = prg_dtoc(mfecha1)
mf2 = prg_dtoc(mfecha2+1)
mret = SQLExec(mcon1,"SELECT Capitulo, Letra FROM TabCiapCap ", "mwkcompo" )

mfecnul = CTOD("01/01/1900")
do case
case mnivel = 1
	mret = SqlExec(mcon1, "Select TabCiap2E.descripcion,TabCie10.descrip as descripcie9 , Guardia.FechaHoraIng,  " + ;
		"Guardia.FechaHoraAte, Guardia.Protocolo, Guardia.codCIE9,TabCiap2E.componente " + ;
		",TabCiap2E.codigo ,TabCie10.codcie10 "+;
		"from  Guardia " + ;
		"left join TabCiap2E on  Guardia.codcie9 = TabCiap2E.Id " + ;
		"left join TabCie10 ON ( Guardia.codcie9 = TabCie10.Id and TabCie10.tipo =3)" + ;
		"Where Guardia.codcie9 >0 " + mbusca +;
		"And Guardia.FechaHoraIng >= ?mf1 and Guardia.codmed>1 " + ;
		"And Guardia.FechaHoraIng < ?mf2 group by protocolo" , "mwkDiagGuar")
case mnivel = 2
	mret = SQLExec(mcon1,"SELECT id, nombre FROM prestadores  " + ;
		" union  SELECT ID , nombre FROM TabMedExterno " + ;
		" where gerenciadora = 0 " +;
		"ORDER BY nombre", "mwkMedgua" )

	mret = SqlExec(mcon1, "Select TabCiap2E.descripcion,TabCie10.descrip as descripcie9 , Guardia.FechaHoraIng,Guardia.codprest, " + ;
		"Guardia.FechaHoraAte, Guardia.Protocolo, Guardia.codCIE9,Guardia.codmedcie9,  " + ;
		"Registracio.Reg_NroHClinica, Registracio.Reg_NombrePac, Registracio.Reg_FecNacimiento, Registracio.Reg_sexo, " + ;
		"Entidades.Ent_DescriEnt,tabtipoaltas.descrip, TabGuaMsg.TGM_Mensaje,TabCiap2E.componente " + ;
		",TabCiap2E.codigo ,TabCie10.codcie10 "+;
		"from  Guardia, Registracio, Entidades,tabtipoaltas " + ;
		"left join TabCiap2E on  Guardia.codcie9 = TabCiap2E.Id " + ;
		"left join TabCie10 ON ( Guardia.codcie9 = TabCie10.Id and TabCie10.tipo =3)" + ;
		"left join TabGuaMsg on TabGuaMsg.TGM_Protocolo = Guardia.protocolo " + ;
		"Where Guardia.codcie9 >0 "  + mbusca +;
		" and guardia.codestado 		= tabtipoaltas.id " + ;
		"And Guardia.FechaHoraIng >= ?mf1 " + ;
		"And Guardia.FechaHoraIng < ?mf2 " + ;
		"And Guardia.NroRegistrac = Registracio.REG_NroRegistrac " + ;
		"And Entidades.Ent_CodEnt = Guardia.CodEnt "+;
		" and Guardia.codmed>1 ", "mwkDiagGuar")

case mnivel = 0 &&&& planilla de denuncia obligatoria
	mret = SQLExec(mcon1,"SELECT id, nombre FROM prestadores  " + ;
		" union  SELECT ID , nombre FROM TabMedExterno " + ;
		" where gerenciadora = 0 " +;
		"ORDER BY nombre", "mwkMedgua" )
	mret = SQLExec(mcon1,"SELECT MSP_patologia, MSP_codigo, MSP_tipo  FROM Zabmspat " + ;
		" " , "mwkpat0" )
	select *,int(val(msp_codigo)) as mspcodigo from mwkpat0 into cursor mwkpat

	mret = SqlExec(mcon1, "Select TabCiap2E.descripcion,Guardia.FechaHoraIng,Guardia.codprest, " + ;
		"Guardia.FechaHoraAte, Guardia.Protocolo, Guardia.codCIE9,Guardia.codmedcie9,  " + ;
		"Reg_NroHClinica,  REG_nombrepac,REG_sexo,REG_fecnacimiento, REG_domicilio,REG_telefonos, REG_numdocumento,"+;
		"REG_localidad, REG_provincia,REG_cpostal, REG_tipodocumento,REG_email, REG_pais, " + ;
		"TabCiap2E.componente " + ;
		",TabCiap2E.codigo, CR_diagnostico "+;
		"from  Guardia, Registracio " + ;
		"inner join TabCiap2E on  Guardia.codcie9 = TabCiap2E.Id " + ;
		"inner join Tabciaprel on  Guardia.codcie9 = Tabciaprel.CR_IdCie9 " + ;
		"Where Guardia.codcie9 >0 "  + mbusca +;
		"And Guardia.FechaHoraIng >= ?mf1 " + ;
		"And Guardia.FechaHoraIng < ?mf2 " + ;
		"And Guardia.NroRegistrac = Registracio.REG_NroRegistrac " + ;
		" and Guardia.codmed>1 ", "mwkDiagGuar0")

		select * from mwkDiagGuar0,mwkpat where CR_diagnostico = mspcodigo into cursor mwkDiagGuar

endcase
if mret <= 0
	messagebox("ERROR EN LA CONSULTA DE LOS DATOS", 48, "VALIDACION")
	cancel
endif
