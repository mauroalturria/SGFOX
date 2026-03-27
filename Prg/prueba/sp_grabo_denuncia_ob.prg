****
* Denuncia de Obito
*****
parameters mabm,mpaciente,mtipopac,mcodmed,mDenPol,mSolDP,mInfFam,mcodCie,mfechaOb,mhoraOb,mobserva;
	,mestado ,mentregado,mnrocert,mprotocolo,mfecentrega,mmotegre ,mtipoInt ,mconsmed ,msolicambu,lfinal,mfetoret


mdtF    = sp_busco_fecha_serv('DT')
mfecnul = ctod("01/01/1900")
IF mwkexe.nomexe = "ADMISION"
	mret=sqlexec(mcon1,"SELECT	id,PO_Observac,PO_Estado from Tabpacobito where PO_admision = ?mpaciente and PO_FechaCierre = ?mfecnul  ","mwkrreg")
	IF RECCOUNT("mwkrreg")=0
		mret=sqlexec(mcon1,"SELECT	id,PO_Observac,PO_Estado from Tabpacobito where PO_admision = ?mpaciente order by id desc","mwkrreg")
		mid = mwkrreg.id
		mret=sqlexec(mcon1,"SELECT	id,PO_Observac,PO_Estado from Tabpacobito where id = ?mid","mwkrreg")
	endif
ELSE
	mret=sqlexec(mcon1,"SELECT	id,PO_Observac,PO_Estado from Tabpacobito where PO_admision = ?mpaciente and PO_FechaCierre = ?mfecnul  ","mwkrreg")

ENDIF

musu = iif(used('mwkusuarios'),mwkusuarios.idusuario,mwkusuario.idusuario)

midusu = iif(used('mwkusuarios'),mwkusuarios.codigovax,mwkusuario.codigovax)

mfinal = ",PO_FechaCierre = ?mfecnul  "
if vartype(lfinal)="N"
	if lfinal = 1
		mfinal = ",PO_FechaCierre = ?mdtF "
	endif
endif
if mret < 0
	=aerr(eros)
	messagebox("No se puede acceder a algunos Datos" + eros(3),0+64,"Usuario")
endif
do case
	case mabm = 1
		if reccount("mwkrreg")>0
			messagebox("ESTE EGRESO YA FUE REGISTRADO",64,"Alerta")
		else
			if reccount("mwkrreg")= 0
				mret =sqlexec(mcon1,"INSERT INTO Tabpacobito(PO_admision, PO_CodMed, PO_Codcie10, PO_DenPol, PO_Estado,PO_FamInf, "+;
					" PO_FechaCierre, PO_FechaIngreso, PO_FechaObito, PO_HoraObito, PO_NroCertif, PO_NroSocio, PO_Observac, "+;
					" PO_Protocolo, PO_SolicDen, PO_TipoPac, PO_Traumatico,PO_ConsMedico ,PO_MotivoEgreso ,PO_TipoInterna, PO_SolicAmbu )"+;
					"VALUES (?mpaciente,?mcodmed,?mcodCie,?mDenPol,?mestado,?mInfFam,?mfecnul ,?mdtF,?mfechaOb, ?mhoraOb"+;
					", ?mnrocert ,0,?mobserva, ?mprotocolo,?mSolDP,?mtipopac, ?mfetoret,?mconsmed ,?mmotegre, ?mtipoInt ,?msolicambu )")
				if mret<0
					=aerr(eros)
					messagebox("No se puede acceder a algunos Datos "+eros(3),0+64,"Usuario")
				ELSE
					IF mmotegre =6 
						do case
							case mtipopac = "INT"
								select mwkpacint1
								mpac 	= pac_nombrepaciente
								madmis	= pac_codadmision
								mmot	= 15 && obito
								mobs	= mtipopac + ":" + alltrim(mpaciente) + " " + sec_codsector+" "+pac_habitacion+" - "+pac_cama+ " Obs: "+ alltrim(mobserva)
								ment 	= ENT_codent
							case mtipopac = "QUI"
								select mwkpacint1
								mpac 	= pac_nombrepaciente
								madmis	= mwkpacint1.pac_codhce
								mmot	= 15 && obito
	*!*						do sp_busco_quiro_dato with " FechaQuirof = '"+prg_dtoc(mfechaOb );
	*!*							+"' and Nroregistrac = "+ transf(mwkpacint1.pac_codhci)
								mobs	= mtipopac + ":" + alltrim(mpaciente) + " Quirofano: " + ;
									transform(mwkquiro2.tqs_sala)+ " Obs: "+ alltrim(mobserva)
								ment 	= mwkpacint1.cob_codentidad
							case mtipopac = "GUA"
								mpac 	= mwkbuspacie1.reg_nombrepac
								madmis	= mprotocolo
								mmot	= 15 && obito
								mobs	= mtipopac + ":" + alltrim(mpaciente) + " Obs: "+ alltrim(mobserva)
								ment 	= mwkvales.his_codentidad
						endcase
						do sp_grabo_mesaent with mpac ,mmot,mobs,ment,madmis

					endif
					messagebox('SE GRABARON LOS DATOS', 64,'Validacion')
				endif

			endif
		endif
	case inlist(mabm,2,3)
		mid = mwkrreg.id
		miobser = nvl(mwkrreg.PO_Observac,'')+iif(empty(mobserva),'',chr(10)+ttoc(mdtF)+"-"+ musu+;
			" "+ alltrim(mwkestob.descrip)+"->"+mobserva)

		mret =sqlexec(mcon1,"update Tabpacobito set PO_Estado = ?mestado,PO_NroCertif = ?mnrocert "+;
			",PO_MotivoEgreso =?mmotegre, PO_entregadoa =?mentregado, PO_FHEntrega = ?mfecentrega "+mfinal +;
			" where id = ?mid ")
		mret =sqlexec(mcon1,"INSERT INTO TabPacObitoObs(POO_Estado , POO_FechaObs , POO_Idpacob , POO_Observacion , POO_Usuario )"+;
			" values ( ?mestado,?mdtF,?mid, ?mobserva,?midusu )")


	case inlist(mabm , 4,5) &&& mismo medico modifica todos los datos
		mid = mwkrreg.id
		miobser =mobserva
		mret =sqlexec(mcon1,"update Tabpacobito set PO_Codcie10 = ?mcodCie, PO_DenPol = ?mDenPol, "+;
			" PO_FamInf = ?mInfFam, PO_FechaObito = ?mfechaOb, PO_HoraObito = ?mhoraOb, "+;
			" PO_Observac = ?miobser , PO_SolicDen = ?mSolDP ,PO_ConsMedico = ?mconsmed , PO_Traumatico = ?mfetoret"+;
			" PO_MotivoEgreso =?mmotegre, PO_TipoInterna  =?mtipoInt , PO_SolicAmbu = ?msolicambu "+;
			" where id = ?mid ")

	case mabm = 9 && Anulo
		mid = mwkrreg.id
		mobserva = "ANULADO POR PROFESIONAL SOLICITANTE"
		miobser = nvl(mwkrreg.PO_Observac,'')+iif(empty(mobserva),'',chr(10)+ttoc(mdtF)+"-"+musu+;
			" FINALIZADO->"+mobserva)
		mret =sqlexec(mcon1,"update Tabpacobito set PO_Estado = ?mestado "+mfinal +;
			" where id = ?mid ")
		mret =sqlexec(mcon1,"INSERT INTO TabPacObitoObs(POO_Estado , POO_FechaObs , POO_Idpacob , POO_Observacion , POO_Usuario )"+;
			" values ( ?mestado,?mdtF,?mid, ?mobserva,?midusu )")
	case mabm = 15 && actualizo estado por alta
		mid = mwkrreg.id
		miobser = nvl(mwkrreg.PO_Observac,'')+iif(empty(mobserva),'',chr(10)+ttoc(mdtF)+"-"+musu+;
			" FINALIZADO->"+mobserva)
		mret =sqlexec(mcon1,"update Tabpacobito set PO_Estado = ?mestado ,PO_FechaCierre = ?mfecnul  "+;
			" where id = ?mid ")
		mret =sqlexec(mcon1,"INSERT INTO TabPacObitoObs(POO_Estado , POO_FechaObs , POO_Idpacob , POO_Observacion , POO_Usuario )"+;
			" values ( ?mestado,?mdtF,?mid, ?mobserva,?midusu )")
	case mabm = 16 && CIERRE ALTA TRANSITORIA
		mid = mwkrreg.id
		miobser = nvl(mwkrreg.PO_Observac,'')+iif(empty(mobserva),'',chr(10)+ttoc(mdtF)+"-"+musu+;
			" FINALIZADO->"+mobserva)
		mret =sqlexec(mcon1,"update Tabpacobito set PO_Estado = ?mestado ,PO_FechaCierre = ?mdtF "+;
			" where id = ?mid ")
		mret =sqlexec(mcon1,"INSERT INTO TabPacObitoObs(POO_Estado , POO_FechaObs , POO_Idpacob , POO_Observacion , POO_Usuario )"+;
			" values ( ?mestado,?mdtF,?mid, ?mobserva,?midusu )")
endcase
