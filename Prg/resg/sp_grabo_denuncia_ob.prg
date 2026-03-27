****
* Denuncia de Obito
*****
Parameters mabm,mpaciente,mtipopac,mcodmed,mDenPol,mSolDP,mInfFam,mcodCie,mfechaOb,mhoraOb,mobserva;
	,mestado ,mentregado,mnrocert,mprotocolo,mfecentrega,mmotegre ,mtipoInt ,mconsmed ,msolicambu,lfinal,;
	mfetoret,mcamina,msilla,lnregiob,lbajaygraba

If Vartype(lnregiob)#"N"
	lnregiob = 0
Endif

mdtF    = sp_busco_fecha_serv('DT')
mfecnul = Ctod("01/01/1900")
musu = Iif(Used('mwkusuarios'),mwkusuarios.idusuario,mwkusuario.idusuario)

midusu = Iif(Used('mwkusuarios'),mwkusuarios.codigovax,mwkusuario.codigovax)

If mwkexe.nomexe = "ADMISION"
	mret=SQLExec(mcon1,"SELECT	id,PO_Observac,PO_Estado from Tabpacobito where PO_admision = ?mpaciente and PO_FechaCierre = ?mfecnul  ","mwkrreg")
	If Reccount("mwkrreg")=0
		mret=SQLExec(mcon1,"SELECT	id,PO_Observac,PO_Estado from Tabpacobito where PO_admision = ?mpaciente order by id desc","mwkrreg")
		mid = mwkrreg.Id
		mret=SQLExec(mcon1,"SELECT	id,PO_Observac,PO_Estado from Tabpacobito where id = ?mid","mwkrreg")
	Endif
Else
	mret=SQLExec(mcon1,"SELECT	id,PO_Observac,PO_Estado from Tabpacobito where PO_admision = ?mpaciente and PO_FechaCierre = ?mfecnul  ","mwkrreg")
	If lnregiob>0 Or lbajaygraba
		Select mwkrreg
		Scan
			mid = mwkrreg.Id
			mestob = Iif(mwkrreg.PO_Estado <10,4,18)
			mobserva = "ANULADO POR PROFESIONAL SOLICITANTE"
			miobser = Nvl(mwkrreg.PO_Observac,'')+Iif(Empty(mobserva),'',Chr(10)+Ttoc(mdtF)+"-"+musu+;
				" FINALIZADO->"+mobserva)
			mret =SQLExec(mcon1,"update Tabpacobito set PO_Estado = ?mestob ,PO_FechaCierre = ?mdtF where id = ?mid ")
		Endscan
	Endif
	mret=SQLExec(mcon1,"SELECT	id,PO_Observac,PO_Estado from Tabpacobito where PO_admision = ?mpaciente and PO_FechaCierre = ?mfecnul  ","mwkrreg")
Endif


mfinal = ",PO_FechaCierre = ?mfecnul  "
If Vartype(lfinal)="N"
	If lfinal = 1
		mfinal = ",PO_FechaCierre = ?mdtF "
	Endif
Endif
If mret < 0
	=Aerr(eros)
	Messagebox("No se puede acceder a algunos Datos" + eros(3),0+64,"Usuario")
Endif
Select * From mwkrreg Where PO_Estado<40 Into Cursor mwkrregingr
Do Case
Case mabm = 1
	If Reccount("mwkrregingr")>0
		Messagebox("ESTE EGRESO YA FUE REGISTRADO",64,"Alerta")

	Else
		If Reccount("mwkrregingr")= 0
			mret =SQLExec(mcon1,"INSERT INTO Tabpacobito(PO_admision, PO_CodMed, PO_Codcie10, PO_DenPol, PO_Estado,PO_FamInf, "+;
				" PO_FechaCierre, PO_FechaIngreso, PO_FechaObito, PO_HoraObito, PO_NroCertif, PO_NroSocio, PO_Observac, "+;
				" PO_Protocolo, PO_SolicDen, PO_TipoPac, PO_Traumatico,PO_ConsMedico ,PO_MotivoEgreso ,PO_TipoInterna, PO_SolicAmbu,PO_SolicSillaRueda,PO_Caminando )"+;
				"VALUES (?mpaciente,?mcodmed,?mcodCie,?mDenPol,?mestado,?mInfFam,?mfecnul ,?mdtF,?mfechaOb, ?mhoraOb"+;
				", ?mnrocert ,0,?mobserva, ?mprotocolo,?mSolDP,?mtipopac, ?mfetoret,?mconsmed ,?mmotegre, ?mtipoInt ,?msolicambu,?msilla,?mcamina )")
			If mret<0
				=Aerr(eros)
				Messagebox("No se puede acceder a algunos Datos "+eros(3),0+64,"Usuario")
				Return .F.
			Else
				If mmotegre =6
					Do Case
					Case mtipopac = "INT"
						Select mwkpacint1
						mpac 	= pac_nombrepaciente
						madmis	= pac_codadmision
						mmot	= 15 && obito
						mobs	= mtipopac + ":" + Alltrim(mpaciente) + " " + sec_codsector+" "+pac_habitacion+" - "+pac_cama+ " Obs: "+ Alltrim(mobserva)
						ment 	= ENT_codent
					Case mtipopac = "QUI"
						Select mwkpacint1
						mpac 	= pac_nombrepaciente
						madmis	= mwkpacint1.pac_codhce
						mmot	= 15 && obito
*!*						do sp_busco_quiro_dato with " FechaQuirof = '"+prg_dtoc(mfechaOb );
*!*							+"' and Nroregistrac = "+ transf(mwkpacint1.pac_codhci)
						mobs	= mtipopac + ":" + Alltrim(mpaciente) + " Quirofano: " + ;
							transform(mwkquiro2.tqs_sala)+ " Obs: "+ Alltrim(mobserva)
						ment 	= mwkpacint1.cob_codentidad
					Case mtipopac = "GUA"
						mpac 	= mwkbuspacie1.reg_nombrepac
						madmis	= mprotocolo
						mmot	= 15 && obito
						mobs	= mtipopac + ":" + Alltrim(mpaciente) + " Obs: "+ Alltrim(mobserva)
						ment 	= mwkvales.his_codentidad
					Endcase
					Do sp_grabo_mesaent With mpac ,mmot,mobs,ment,madmis

				Endif
				Messagebox('SE GRABARON LOS DATOS', 64,'Validacion')
			Endif

		Endif
	Endif
Case Inlist(mabm,2,3)
	mid = mwkrregingr.Id
	
	miobser = Nvl(mwkrregingr.PO_Observac,'')+Iif(Empty(mobserva),'',Chr(10)+Ttoc(mdtF)+"-"+ musu+;
		" "+ Alltrim(mwkestob.Descrip)+"->"+mobserva)
	If mid>0

		mret =SQLExec(mcon1,"update Tabpacobito set PO_Estado = ?mestado,PO_NroCertif = ?mnrocert "+;
			",PO_MotivoEgreso =?mmotegre, PO_entregadoa =?mentregado, PO_FHEntrega = ?mfecentrega "+mfinal +;
			" where id = ?mid ")
	Else
		mret =SQLExec(mcon1,"INSERT INTO Tabpacobito(PO_admision, PO_CodMed, PO_Codcie10, PO_DenPol, PO_Estado,PO_FamInf, "+;
			" PO_FechaCierre, PO_FechaIngreso, PO_FechaObito, PO_HoraObito, PO_NroCertif, PO_NroSocio, PO_Observac, "+;
			" PO_Protocolo, PO_SolicDen, PO_TipoPac, PO_Traumatico,PO_ConsMedico ,PO_MotivoEgreso ,PO_TipoInterna, PO_SolicAmbu,PO_SolicSillaRueda,PO_Caminando )"+;
			"VALUES (?mpaciente,?mcodmed,?mcodCie,?mDenPol,?mestado,?mInfFam,?mfecnul ,?mdtF,?mfechaOb, ?mhoraOb"+;
			", ?mnrocert ,0,?mobserva, ?mprotocolo,?mSolDP,?mtipopac, ?mfetoret,?mconsmed ,?mmotegre, ?mtipoInt ,?msolicambu,?msilla,?mcamina )")
	Endif
	musu = mwkusuario.idusuario
	midusu = mwkusuario.codigovax
	mret =SQLExec(mcon1,"INSERT INTO TabPacObitoObs(POO_Estado , POO_FechaObs , POO_Idpacob , POO_Observacion , POO_Usuario )"+;
		" values ( ?mestado,?mdtF,?mid, ?mobserva,?midusu )")


Case Inlist(mabm , 4,5) &&& mismo medico modifica todos los datos
	mid = mwkrregingr.Id
	miobser =mobserva
	If mid>0
		mret =SQLExec(mcon1,"update Tabpacobito set PO_Codcie10 = ?mcodCie, PO_DenPol = ?mDenPol, "+;
			" PO_FamInf = ?mInfFam, PO_FechaObito = ?mfechaOb, PO_HoraObito = ?mhoraOb, "+;
			" PO_Observac = ?miobser , PO_SolicDen = ?mSolDP ,PO_ConsMedico = ?mconsmed , PO_Traumatico = ?mfetoret"+;
			" PO_MotivoEgreso =?mmotegre, PO_TipoInterna  =?mtipoInt , PO_SolicAmbu = ?msolicambu "+;
			" where id = ?mid ")
	Else
		mret =SQLExec(mcon1,"INSERT INTO Tabpacobito(PO_admision, PO_CodMed, PO_Codcie10, PO_DenPol, PO_Estado,PO_FamInf, "+;
			" PO_FechaCierre, PO_FechaIngreso, PO_FechaObito, PO_HoraObito, PO_NroCertif, PO_NroSocio, PO_Observac, "+;
			" PO_Protocolo, PO_SolicDen, PO_TipoPac, PO_Traumatico,PO_ConsMedico ,PO_MotivoEgreso ,PO_TipoInterna, PO_SolicAmbu,PO_SolicSillaRueda,PO_Caminando )"+;
			"VALUES (?mpaciente,?mcodmed,?mcodCie,?mDenPol,?mestado,?mInfFam,?mfecnul ,?mdtF,?mfechaOb, ?mhoraOb"+;
			", ?mnrocert ,0,?mobserva, ?mprotocolo,?mSolDP,?mtipopac, ?mfetoret,?mconsmed ,?mmotegre, ?mtipoInt ,?msolicambu,?msilla,?mcamina )")
	Endif
Case mabm = 9 && Anulo
	mid = mwkrregingr.Id
	mobserva = "ANULADO POR PROFESIONAL SOLICITANTE"
	miobser = Nvl(mwkrregingr.PO_Observac,'')+Iif(Empty(mobserva),'',Chr(10)+Ttoc(mdtF)+"-"+musu+;
		" FINALIZADO->"+mobserva)
	mret =SQLExec(mcon1,"update Tabpacobito set PO_Estado = ?mestado "+mfinal +;
		" where id = ?mid ")
	mret =SQLExec(mcon1,"INSERT INTO TabPacObitoObs(POO_Estado , POO_FechaObs , POO_Idpacob , POO_Observacion , POO_Usuario )"+;
		" values ( ?mestado,?mdtF,?mid, ?mobserva,?midusu )")
Case mabm = 15 && actualizo estado por alta
	mid = mwkrregingr.Id
	miobser = Nvl(mwkrregingr.PO_Observac,'')+Iif(Empty(mobserva),'',Chr(10)+Ttoc(mdtF)+"-"+musu+;
		" FINALIZADO->"+mobserva)
	mret =SQLExec(mcon1,"update Tabpacobito set PO_Estado = ?mestado ,PO_FechaCierre = ?mfecnul  "+;
		" where id = ?mid ")
	mret =SQLExec(mcon1,"INSERT INTO TabPacObitoObs(POO_Estado , POO_FechaObs , POO_Idpacob , POO_Observacion , POO_Usuario )"+;
		" values ( ?mestado,?mdtF,?mid, ?mobserva,?midusu )")
Case mabm = 16 && CIERRE ALTA TRANSITORIA
	mid = mwkrregingr.Id
	miobser = Nvl(mwkrregingr.PO_Observac,'')+Iif(Empty(mobserva),'',Chr(10)+Ttoc(mdtF)+"-"+musu+;
		" FINALIZADO->"+mobserva)
	mret =SQLExec(mcon1,"update Tabpacobito set PO_Estado = ?mestado ,PO_FechaCierre = ?mdtF "+;
		" where id = ?mid ")
	mret =SQLExec(mcon1,"INSERT INTO TabPacObitoObs(POO_Estado , POO_FechaObs , POO_Idpacob , POO_Observacion , POO_Usuario )"+;
		" values ( ?mestado,?mdtF,?mid, ?mobserva,?midusu )")
Endcase
