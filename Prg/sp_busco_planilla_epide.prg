*
* Fichas de Epidemiología / Contactos
*
* mtipo = 1 (Epidemiología) / mbuscar = protocolo
* mtipo = 2 (Contactos)     / mbuscar = id de TabFichEp
* mtipo = 3 (Todas )    	/ mbuscar = desde hasta fecha
* mtipo = 4 (Todas )    	/ mbuscar = Nro de registracion
*
* mtipe = "H1N1" ó "DENGUE"
*
Lparameters mbuscar, mtipo, mtipe,lcodmed

If Vartype(mtipe)#"C"
	mtipe = "H1N1"
ENDIF
If Vartype(lcodmed)#"N"
	lcodmed = 1
Endif
mfecbase = prg_dtoc(sp_busco_fecha_serv("DD")-30)
Do Case
	Case mtipo = 1

		If Used('mwkepidemio')
			Use In mwkepidemio
		Endif
		mret = SQLExec(mcon1,"select id as lid,* from "+;
			iif(mtipe="H1N1","TabFichEp","TabFichEp2")+" where fe_proto =?mbuscar","mwkepidemio")
*!*			mret = SQLExec(mcon1,"select id as lid,* from "+;
*!*				iif(mtipe="H1N1","TabFichEp","TabFichEp2")+" where {fn LEFT(fe_proto  )} =?mbuscar","mwkepidemio")

		If mret < 0
			Messagebox("FICHAS DE EPIDEMIOLOGIA"+Chr(10)+;
				"AVISE A SISTEMAS",16,"ERROR")
		Else		
				Use In Select("mwkmatriculas")
				mbuscarid = lcodmed
				mret = SQLExec(mcon1,"select matriculas from prestadores where prestadores.id = ?mbuscarid","mwkmatriculas")
				If mret < 0
					Messagebox("CONSULTA MATRICULA DE PRESTADORES"+Chr(10)+;
						"AVISE A SISTEMAS",16,"ERROR")
				Endif
			
					Endif

	Case mtipo = 2

		If mtipe = "H1N1"

			If Used('mwkepidecon')
				Use In mwkepidecon
			Endif

			mret = SQLExec(mcon1,"select * from TabFichEpCon"+;
				" where FEC_idfich=?mbuscar","mwkepidecon")

			If mret < 0
				Messagebox("EN FICHAS DE EPIDEMIOLOGIA CONTACTOS"+Chr(10)+;
					"AVISE A SISTEMAS",16,"ERROR")
			Endif

		Else

			If Used('mwkepidesin')
				Use In mwkepidesin
			Endif

			mret = SQLExec(mcon1,"select * from TabFichEpSin2"+;
				" where FES_idfich=?mbuscar","mwkepidesin")

			If mret < 0
				Messagebox("EN FICHAS DE EPIDEMIOLOGIA SINTOMAS"+Chr(10)+;
					"AVISE A SISTEMAS",16,"ERROR")
			Endif

		Endif

	Case mtipo = 3

		If Used('mwkepidemio')
			Use In mwkepidemio
		Endif
		marchbase = Iif(mtipe="H1N1","TabFichEp","TabFichEp2")

		mret = SQLExec(mcon1,"select id as lid,* from &marchbase "+;
			" where "+mbuscar,"mwkepidemio")
		mret = SQLExec(mcon1,"select TabFichEp.*, TabCiap2E.descripcion, "+;
			" fechahoraing, protocolo, REG_nombrepac, REG_nrohclinica, REG_fecnacimiento"+;
			" ,Ent_DescriEnt,nroregistrac  "+;
			" from Guardia, REGISTRACIO,&marchbase as TabFichEp,entidades "+;
			" left join TabCiap2E on  Guardia.codCIE9 = TabCiap2E.id "+;
			" where TabFichEp.FE_proto = Guardia.protocolo "+;
			" and Guardia.nroregistrac = REGISTRACIO.REG_nroregistrac "+;
			" and Guardia.codent = entidades.ent_codent "+;
			" and " + mbuscar,"mwkepidem")
		
		If !Used("mwkpacint")
			Do sp_busco_pac_internados With '',''
		Endif 	
		
		Select * From mwkepidem Left Join mwkpacint On nroregistrac = PAC_codhci ;
			into Cursor mwkepidems
		If mret < 0
			Messagebox("FICHAS DE EPIDEMIOLOGIA"+Chr(10)+;
				"AVISE A SISTEMAS",16,"ERROR")
		Endif

	Case mtipo = 4

		If Used('mwkepidemio')
			Use In mwkepidemio
		Endif
		marchbase = Iif(mtipe="H1N1","TabFichEp","TabFichEp2")
*	mret = sqlexec(mcon1,"select id as lid,* from &marchbase "+;
" ","mwkepidemio")  &&where ?mbuscar
		mret = SQLExec(mcon1,"select TabFichEp.id as lid,TabFichEp.*,TabCiap2E.descripcion, "+;
			" fechahoraing, protocolo, REG_nombrepac, REG_nrohclinica "+;
			"  ,nroregistrac, REG_fecnacimiento  "+;
			" from Guardia, REGISTRACIO,&marchbase as TabFichEp  "+;
			" left join TabCiap2E on  Guardia.codCIE9 = TabCiap2E.id "+;
			" where TabFichEp.FE_proto = Guardia.protocolo "+;
			" and Guardia.nroregistrac = REGISTRACIO.REG_nroregistrac "+;
			" and guardia.fechahoraing>= ?mfecbase and " + mbuscar +" group by TabFichEp.id","mwkepidemg")
		mret = SQLExec(mcon1,"select TabFichEp.id as lid,TabFichEp.*,Tabcie10.descrip as descripcion, "+;
			" IH_fechaHoraIng as fechahoraing,IH_admision  as protocolo,  REG_nombrepac,  "+;
			"  REG_nrohclinica "+;
			" ,REG_nroregistrac as nroregistrac, REG_fecnacimiento  "+;
			" from tabinthce, pacientes,&marchbase as TabFichEp  "+;
			" INNER JOIN Registracio ON  Pacientes.PAC_codhci = Registracio.REG_nroregistrac "+;
			" left join Tabcie10 on IH_motIngreso = Tabcie10.ID "+;
			" where Pacientes.PAC_codadmision = Tabinthce.IH_admision and {fn LEFT(IH_admision,6)} = {fn LEFT(fe_proto,6)}"+;
			" and fe_fecmodifica>= ?mfecbase and " + mbuscar+" group by TabFichEp.id","mwkepidemi")
		Select * From 	mwkepidemi ;
			UNION All Select * From mwkepidemg;
			INTO Cursor mwkepidem
* saco
*	Do sp_busco_pac_internados with '',''
		Select * From mwkepidem ; &&left join mwkpacint on nroregistrac = PAC_codhci
		Into Cursor mwkepidems
		Select * From mwkepidem  Into Cursor mwkepidemio
		If mret < 0
			Messagebox("FICHAS DE EPIDEMIOLOGIA"+Chr(10)+;
				"AVISE A SISTEMAS",16,"ERROR")
		Endif

Endcase


