*
* Graba protocolo de la atencion

do sp_conexion
 mtipomov = 1
	if mtipomov = 1
		mret = sqlexec(mcon1, "SELECT sector,SectorAgrup FROM secagrup","secagrup")
		mret = sqlexec(mcon1, "SELECT idusuario,codigovax FROM tabusuario","tabusuario")
		create cursor bristol (OS_ID n(4),NROAFIL c(20),TIPODOC n(4),NRODOC n(13),APELLIDO	C(40);
			,NOMBRE C(40),SEXO C(1),FECHANAC	c(10),FECHORAING c(20),DIAGNOSTICO	C(40),FECHORAEGR c(20);
			,FECHAORDEN	c(20),LUGARINTERNAC	C(3),CODADMISION	C(8),TIPOMOV C(1),USUARIO C(20);
			,FECHAHORA c(20),NROORDEN n(8),BRISTOL C(1),FECHAHORABRISTOL c(20),motivoegreso n(1),motivoadmision n(1))
		select * from pacbristolalta left join tabusuario on pac_operadm = codigovax union all;
		select * from pacbristoladm left join tabusuario on pac_operadm = codigovax into cursor pacbristol
	else
	endif
	mcursor = 'pacbristol'

	set step on
	scan
		mcodadm	= &mcursor->PAC_codadmision
		mnroregistra= &mcursor->reg_nroregistrac
		mret = sqlexec(mcon1, "select AFI_nroafiliado, cob_codentidad " + ;
			"from  coberturas, pacientes,afiliacion " + ;
			" where PAC_codadmision 	= COB_pacientes and afiliacion.registracio  =?mnroregistra and " + ;
			" afiliacion.AFI_codentidad = cob_codentidad and  PAC_codadmision 	= ?mcodadm	" , "mwkpacalta")
		if inlist(mwkpacalta.cob_codentidad,945,948)
			musua 	= alltrim(&mcursor->idusuario)
			mnroafil = alltrim(CHRTRAN(prg_saca_char(mwkpacalta.AFI_nroafiliado)," ",""))
			micodent = mwkpacalta.cob_codentidad
			mmotivoegreso = nvl(&mcursor->PAC_motivoalta,0)
			mmotivoadmision = nvl(&mcursor->PAC_motivoadmision,0)
			mfechaingr = prg_dtoc(ctot(dtoc(&mcursor->pac_fechaadmision)+" "+ttoc(&mcursor->pac_horaadmision,2)))
			if mtipomov = 2
				mfechaegr = prg_dtoc(ctot(dtoc(&mcursor->pac_fechaalta)+" "+ttoc(&mcursor->pac_horaalta,2)))
				mfHoy   = mfechaegr
			else
				mfechaegr = '2100-01-01 00:00:00'
				mfHoy   = mfechaingr
			endif
			mfecorden = left(mfHoy  ,10)
			ctipomov = iif(mtipomov=1,"I",iif(mtipomov=2,"E",iif(mtipomov=3,"M","N" ) ) )
				mret = sqlexec(mcon1, "SELECT NROAFIL FROM Bristol.SG_INTERNACION "+;
					" where NROAFIL= ?mnroafil and FECHAORDEN = ?mfecorden and TIPOMOV = ?ctipomov ","mwkexis")
				if reccount("mwkexis")= 0
				msector = &mcursor->PAC_sectorinternac
				select secagrup
				locate for sector = msector
				if found()
					msector = SectorAgrup
				endif
				mdiagno = alltrim(iif(inlist(mtipomov,1,3), &mcursor->PAC_descripdiagn,&mcursor->PAC_descripdiagegr))
				mnrodoc = round(&mcursor->REG_numdocumento,0)
				mtipodoc = round(val(&mcursor->REG_tipodocumento),0)
				mapel = alltrim(left(&mcursor->reg_nombrepac,at(",",&mcursor->reg_nombrepac)-1))
				mnombre = alltrim(substr(&mcursor->reg_nombrepac,at(",",&mcursor->reg_nombrepac)+1))
				msex = alltrim(&mcursor->reg_sexo)
				mfecnac = left(prg_dtoc(&mcursor->REG_fecnacimiento),10)
				if micodent=948
					micodent = 11
					mret = sqlexec(mcon1,"select * from SQLUser.PadCabe "+;
						" left join padotrosdatos on padotrosdatos.idpadcabe=padcabe.id "+;
						" where Padcabe.NroAfiliado = ?mnroafil and Padcabe.entidad = 948 "+;
						" order by padotrosdatos.FechaDesde desc","mwkctrlpad")
					if mret < 0
						=aerror(merror)
						messagebox("EN CONSULTA PADRONES"+chr(10)+;
							alltrim(merror(3)),16,"ERROR")
						do log_errores with error(), message(), message(1), program(), lineno()
					else
						menttipo = val(mwkctrlpad.contenido)
						if menttipo >0
							micodent = menttipo
						else
							micodent = iif(alltrim(mwkctrlpad.contenido)='GASMBA',19,;
								iif(alltrim(mwkctrlpad.contenido)='GASTRO',11,11 ) )
						endif
					endif
				else 
					?mnroafil
				endif
				insert into Bristol(OS_ID,NROAFIL,TIPODOC,NRODOC,APELLIDO,NOMBRE,SEXO,FECHANAC ;
					,FECHORAING,DIAGNOSTICO,FECHORAEGR,FECHAORDEN,LUGARINTERNAC;
					,CODADMISION,TIPOMOV,USUARIO,FECHAHORA,motivoegreso ) ;
					values(;
					micodent ,mnroafil ,mtipodoc , mnrodoc , mapel   ;
					,mnombre, msex, mfecnac, mfechaingr, mdiagno,mfechaegr,mfecorden ;
					,msector,mcodadm,ctipomov,musua, mfHoy,mmotivoegreso )
				endif
			endif
		select &mcursor
	endscan

*		set step on
		select * from bristol order by FECHAHORA into cursor bristolord
		select bristolord
		scan
			scatter memvar
			mret = sqlexec(mcon1, "insert into Bristol.SG_INTERNACION (" + ;
				"OS_ID,NROAFIL,TIPODOC,NRODOC,APELLIDO,NOMBRE,SEXO,FECHANAC "+;
				",FECHORAING,DIAGNOSTICO,FECHORAEGR,FECHAORDEN,LUGARINTERNAC"+;
				",CODADMISION,TIPOMOV,USUARIO,FECHAHORA,motivoegreso ) "+;
				"values(" + ;
				"?m.OS_ID,?m.NROAFIL,?m.TIPODOC,?m.NRODOC,?m.APELLIDO,?m.NOMBRE,?m.SEXO,?m.FECHANAC "+;
				",?m.FECHORAING,?m.DIAGNOSTICO,?m.FECHORAEGR,?m.FECHAORDEN,?m.LUGARINTERNAC"+;
				",?m.CODADMISION,?m.TIPOMOV,?m.USUARIO,?m.FECHAHORA,?M.motivoegreso )")
*!*			if mret<1
*!*					do log_errores with error(), message(), message(1), program(), lineno()
*!*			endif
		endscan
	endif
do sp_desconexion
