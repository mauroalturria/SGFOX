lparameters mcancelado,mfechad,mcodmed,mcodreserv
	mcfecdes 	= prg_dtoc(mfechad) 
	mcfecHas 	= prg_dtoc(mfechad + 1) 
IF EMPTY(mcodreserv)
	IF mcancelado = 1 
			mret = SQLEXEC(mcon1," select horatur,reg_nombrepac as nombre,"+ ;
			" reg_telefonos,codmed,turnoscancel.codreserva,turnoscall.usuario,turnoscancel.id, "+;
			" turnoscall.codreserva as codreserv,afiliado,turnoscancel.codreserva,fechatur "+;
			" from registracio,turnoscancel "+;
			" left join turnoscall on turnoscall.codreserva  = turnoscancel.codreserva "+;
			" where  feccancela>=?mcfecdes and "+;
			" turnoscancel.afiliado = registracio.reg_nroregistrac "+;
			" and codmed = ?mcodmed  "  +;
			" " ,"mwkcancrepro01")
            SELECT horatur as fecha,nombre,NVL(reg_telefonos,'') as reg_telefonos,;
                IIF(ISNULL(usuario),100-100,COUNT(codreserva)) as cantcodreserva,codreserva ;
    	        from mwkcancrepro01  group by fechatur, afiliado, codreserva ORDER BY horatur ;
    	        INTO CURSOR mwkcancrepro
	ELSE		
		    mret = SQLEXEC(mcon1," select fechaturnva ,cantidadpac, "+;
		    " turnosreprog.codmed as codmedr,"+;
		    " turnos.codmed as codmedt,codmedrepro,fecharep,fechaturant,fechatur,hhmmtur,"+;
		    " reg_nombrepac as nombre,reg_telefonos,turnos.observa, "+;
		    " turnos.codreserva,turnoscall.usuario,estado,horatur,turnos.id,   "+;
			" turnoscall.codreserva as codreserv,afiliado"+;
			" from registracio ,turnosreprog left join turnos on turnos.fechatur = turnosreprog.fechaturnva  "+;
			" left join turnoscall on turnoscall.codreserva  = turnos.codreserva "+;
			" where  fecharep>=?mcfecdes and fecharep<=?mcfecHas and "+;
			" turnos.afiliado = registracio.reg_nroregistrac   "+;
			" and turnosreprog.codmed = ?mcodmed and codmedrepro = turnos.codmed "+; 
			" union all " +;
			" select fechaturnva,cantidadpac,turnosreprog.codmed as codmedr,"+;
			" turnos.codmed as codmedt,codmedrepro,fecharep,fechaturant,fechatur,hhmmtur,"+;
			" reg_nombrepac as nombre,reg_telefonos,turnos.observa, "+;
			" turnos.codreserva,turnoscall.usuario,estado,horatur,turnos.id,  "+;
			" turnoscall.codreserva as codreserv,afiliado "+;
			" from turnosreprog,registracio left join turnos on fechatur = fechaturnva  "+;
			" left join turnoscall on turnoscall.codreserva  = turnos.codreserva "+;
			" where  fecharep>=?mcfecdes and fecharep<=?mcfecHas and "+;
			" turnos.afiliado = registracio.reg_nroregistrac   "+;
			" and turnos.codmed = ?mcodmed and (turnosreprog.codmed = ?mcodmed  "+;
			" and codmedrepro = 1) ","mwkturnos")
			
            SELECT horatur as fecha,nombre,NVL(reg_telefonos,'') as reg_telefonos,;
                IIF(ISNULL(codreserv),100-100,COUNT(codreserv)) as cantcodreserva,;
                fechaturant,;
                cantidadpac,codmedr,;
	            IIF(codmedrepro = 1,codmedr,codmedrepro) as codmedrepro,;
	            usuario,codreserva,estado ;
    	        from mwkturnos WHERE SUBSTR(ALLTRIM(observa),1,3) = 'REP' ;
    	        group by fechatur, afiliado, codreserva ORDER BY horatur ;
    	        INTO CURSOR mwkcancrepro
	ENDIF 
ENDIF 

if mret < 0
	messagebox("ERROR AL CREAR EL CURSOR, AVISAR A SISTEMAS", 16, "Validación")
endif

