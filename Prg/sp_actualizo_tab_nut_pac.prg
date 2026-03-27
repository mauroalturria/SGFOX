****
** Actualizo Datos de Alimentacion
****
lparameters nopcion, mcodadm, mtiposer, mobserva,mcodfact,mid,mfechahoy,mmodi
if type('mfechahoy')#"D"
	mfechahoy = sp_busco_fecha_serv('DD')
endif	
if type('mmodi')#"N"
	mmodi = -1
endif	
if !used("mwkusuario")
	create cursor mwkusuario (idusuario c(20),codigovax n(7),password c(10),id n(2),nivel n(2),sector c(30),nomape c(30))
	insert into mwkusuario values ("CFUNES",54035,'',146,1,'SISTEMAS',"Carmencita")
endif
mcodvax	= mwkusuario.codigovax
do case 
	case nopcion = 1  &&&  alta o modificacion

		mret =sqlexec(mcon1, "select * from TabNutPaciente "+;
				"where TNP_codadmision = ?mcodadm and TNP_Fecha = ?mfechahoy "+;
				" and TNP_CodServ = ?mtiposer","mwkexistepac")
		if reccount("mwkexistepac")>0
			mid= mwkexistepac.id
				mmodif = iif(((alltrim(TNP_Observaciones) # alltrim(mobserva) and !empty(TNP_Observaciones));
							or TNP_Modi=1 or mmodi=1) ;
						and !(TNP_Modi=0 and mmodi=0),1,0)
			mret =sqlexec(mcon1, "update TabNutPaciente set TNP_CodFact = ?mcodfact"+;
				",TNP_Observaciones = ?mobserva,TNP_Usuario = ?mcodvax, TNP_Modi = ?mmodif "+;
				" where id=?mid" )

		else
			mret =sqlexec(mcon1, "insert into TabNutPaciente (TNP_codadmision"+;
				",TNP_Fecha,TNP_CodServ,TNP_CodFact,TNP_Observaciones,TNP_Usuario ,TNP_Modi )"+;
				" values (?mcodadm,?mfechahoy,?mtiposer,?mcodfact,?mobserva,?mcodvax,0 )")
			if mret<1
				=aerr(eros)
				messagebox(eros(3))
			endif
		endif
	case nopcion = 2  &&&  solo modificacion
		if type('mid')#"N"
			mret =sqlexec(mcon1, "select * from TabNutPaciente "+;
				"where TNP_codadmision = ?mcodadm and TNP_Fecha = ?mfechahoy "+;
				" and TNP_CodServ = ?mtiposer","mwkexistepac")
			if reccount("mwkexistepac")>0
				mid= mwkexistepac.id
				mmodif = iif(((alltrim(TNP_Observaciones) # alltrim(mobserva) and !empty(TNP_Observaciones));
							or TNP_Modi=1 or mmodi=1) ;
							and !(TNP_Modi=0 and mmodi=0),1,0)
				mret =sqlexec(mcon1, "update TabNutPaciente set TNP_CodFact = ?mcodfact"+;
					",TNP_Observaciones = ?mobserva,TNP_Usuario = ?mcodvax, TNP_Modi = ?mmodif "+;
					" where id=?mid" )
			else
				mret =sqlexec(mcon1, "insert into TabNutPaciente (TNP_codadmision"+;
					",TNP_Fecha,TNP_CodServ,TNP_CodFact,TNP_Observaciones,TNP_Usuario,TNP_Modi )"+;
					" values (?mcodadm,?mfechahoy,?mtiposer,?mcodfact,?mobserva,?mcodvax,0 )")
				if mret<1
					=aerr(eros)
					messagebox(eros(3))
				endif
			endif
		else
			mret =sqlexec(mcon1, "update TabNutPaciente set TNP_CodFact = ?mcodfact"+;
				",TNP_Observaciones = ?mobserva,TNP_Usuario = ?mcodvax "+;
				" where id=?mid" )
		endif		
		case nopcion = 3  &&&  BAJA
			mret =sqlexec(mcon1, "delete from TabNutPaciente where id=?mid" )
			if mret<1
				=aerr(eros)
				messagebox(eros(3))
			endif

endcase