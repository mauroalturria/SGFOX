do while !eof('mwkevolpnurse') and !eof('mwkevolNurid')
	select mwkevolNurid
	go top
	midia =ttod(iif(mwkevolNurid.EIN_fechaH>mwkevolpnurse.fechaevol,mwkevolpnurse.fechaevol,mwkevolNurid.EIN_fechaH ))
	mevol =  "______________________________________________________________________"+ dtoc(midia)
	insert into mwkevolprin (tipo,linea) values (1,mevol)
	do while !eof('mwkevolpnurse') and !eof('mwkevolNurid')
		if mwkevolNurid.EIN_fechaH > mwkevolpnurse.fechaevol or eof('mwkevolNurid')
			if midia # ttod(mwkevolpnurse.fechaevol)
				midia = ttod(mwkevolpnurse.fechaevol)
				mevol =  "______________________________________________________________________"+ dtoc(midia)
				insert into mwkevolprin (tipo,linea) values (1,mevol)
			endif
			miusu = mwkevolpnurse.EIP_usuario
			midia = ttod(mwkevolpnurse.fechaevol)
			lcabe = .t.
			if midia # ttod(mwkevolpnurse.fechaevol)
				mevoln = mevoln + iif(midia =ctod("01/01/1900"),'',chr(10)+;
					"______________________________________________________________________"+ dtoc(midia)+chr(10))
				midia = ttod(mwkevolpnurse.fechaevol)
			endif
			miusu = mwkevolpnurse.EIP_usuario
			do while midia = ttod(mwkevolpnurse.fechaevol) and miusu = mwkevolpnurse.EIP_usuario and !eof('mwkevolpnurse')
				do case
					case = "E" and ("E" $ copciones)
						mevol = iif(lcabe, ttoc(mwkevolpnurse.fechaevol) + " - " + allt(mwkevolpnurse.nomape )+ " - ",'' )+;
							alltrim(eim_evol)
						lcabe = .f.
					case = "V" and ("V" $ copciones)
						mevol = iif(lcabe, ttoc(mwkevolpnurse.fechaevol) + " - " + allt(mwkevolpnurse.nomape )+ " - ",'' )+;
							"C.S.V."+chr(10)+alltrim(eim_evol)
						lcabe = .f.
					case = "M" and ("M" $ copciones)
						mevol = iif(lcabe, ttoc(mwkevolpnurse.fechaevol) + " - " + allt(mwkevolpnurse.nomape )+ " - ",'' )+;
							"Medicación" +chr(10)+alltrim(eim_evol)
						lcabe = .f.
					case = "C" and ("C" $ copciones)
						mevol = iif(lcabe, ttoc(mwkevolpnurse.fechaevol) + " - " + allt(mwkevolpnurse.nomape )+ " - ",'' )+;
							"Cuidados realizados" +chr(10)+alltrim(eim_evol)
						lcabe = .f.
					case = "S" and ("S" $ copciones)
						mevol = iif(lcabe, ttoc(mwkevolpnurse.fechaevol) + " - " + allt(mwkevolpnurse.nomape )+ " - ",'' )+ ;
							"Escores" +chr(10)+alltrim(eim_evol)
						lcabe = .f.
				endcase
				thisform.insertolin_nur(mevol,2)
				select mwkevolpnurse
				skip 1
			enddo
		else
			if !eof('mwkevolNurid')
				if midia # ttod(mwkevolNurid.EIN_fechaH)
					midia = ttod(mwkevolNurid.EIN_fechaH)
					mevol =  "______________________________________________________________________"+ dtoc(midia)
					insert into mwkevolprin (tipo,linea) values (1,mevol)
				endif
				mevol = ttoc(mwkevolNurid.EIN_fechaH) + " - " + allt(mwkevolNurid.nomape )

				insert into mwkevolprin (tipo,linea) values (2,mevol)
				thisform.insertolin_nur(mwkevolNurid.EIN_evolNurse,2)
				skip 1 in mwkevolNurid
			endif
		endif
	enddo
	if eof('mwkevolNurid')
		do while !eof('mwkevolpnurse')
			if midia # ttod(mwkevolpnurse.fechaevol)
				midia = ttod(mwkevolpnurse.fechaevol)
				mevol =  "______________________________________________________________________"+ dtoc(midia)
				insert into mwkevolprin (tipo,linea) values (1,mevol)
			endif
			miusu = mwkevolpnurse.EIP_usuario
			midia = ttod(mwkevolpnurse.fechaevol)
			lcabe = .t.
			if midia # ttod(mwkevolpnurse.fechaevol)
				mevoln = mevoln + iif(midia =ctod("01/01/1900"),'',chr(10)+;
					"______________________________________________________________________"+ dtoc(midia)+chr(10))
				midia = ttod(mwkevolpnurse.fechaevol)
			endif
			miusu = mwkevolpnurse.EIP_usuario
			do while midia = ttod(mwkevolpnurse.fechaevol) and miusu = mwkevolpnurse.EIP_usuario and !eof('mwkevolpnurse')
				do case
					case = "E" and ("E" $ copciones)
						mevol = iif(lcabe, ttoc(mwkevolpnurse.fechaevol) + " - " + allt(mwkevolpnurse.nomape )+ " - ",'' )+;
							alltrim(eim_evol)
						lcabe = .f.
					case = "V" and ("V" $ copciones)
						mevol = iif(lcabe, ttoc(mwkevolpnurse.fechaevol) + " - " + allt(mwkevolpnurse.nomape )+ " - ",'' )+;
							"C.S.V."+chr(10)+alltrim(eim_evol)
						lcabe = .f.
					case = "M" and ("M" $ copciones)
						mevol = iif(lcabe, ttoc(mwkevolpnurse.fechaevol) + " - " + allt(mwkevolpnurse.nomape )+ " - ",'' )+;
							"Medicación" +chr(10)+alltrim(eim_evol)
						lcabe = .f.
					case = "C" and ("C" $ copciones)
						mevol = iif(lcabe, ttoc(mwkevolpnurse.fechaevol) + " - " + allt(mwkevolpnurse.nomape )+ " - ",'' )+;
							"Cuidados realizados" +chr(10)+alltrim(eim_evol)
						lcabe = .f.
					case = "S" and ("S" $ copciones)
						mevol = iif(lcabe, ttoc(mwkevolpnurse.fechaevol) + " - " + allt(mwkevolpnurse.nomape )+ " - ",'' )+ ;
							"Escores" +chr(10)+alltrim(eim_evol)
						lcabe = .f.
				endcase
				thisform.insertolin_nur(mevol,2)
				select mwkevolpnurse
				skip 1
			enddo
		enddo

	endif
	if eof('mwkevolpnurse')
		do while !eof('mwkevolNurid')
			if midia # ttod(mwkevolNurid.EIN_fechaH)
				midia = ttod(mwkevolNurid.EIN_fechaH)
				mevol =  "______________________________________________________________________"+ dtoc(midia)
				insert into mwkevolprin (tipo,linea) values (2,mevol)
			endif
			mevol = ttoc(mwkevolNurid.EIN_fechaH) + " - " + allt(mwkevolNurid.nomape )
			insert into mwkevolprin (tipo,linea) values (2,mevol)
			thisform.insertolin_nur(mwkevolNurid.EIN_evolNurse,2)
			skip 1 in mwkevolNurid
		enddo

	endif
enddo






	if mwkevolpnurse.EIN_fechaH>mwkevolpnurse.fechaevol or eof('mwkevolpnurse')
		if !empty(nvl(mwkevolpnurse.eim_evol,''))
			miusu = mwkevolpnurse.EIP_usuario
			midia = ttod(mwkevolpnurse.fechaevol)
			lcabe = .t.
			if midia # ttod(mwkevolpnurse.fechaevol)
				mevoln = mevoln + iif(midia =ctod("01/01/1900"),'',chr(10)+;
					"______________________________________________________________________"+ dtoc(midia)+chr(10))
				midia = ttod(mwkevolpnurse.fechaevol)
			endif
			miusu = mwkevolpnurse.EIP_usuario
			do while midia = ttod(mwkevolpnurse.fechaevol) and miusu = mwkevolpnurse.EIP_usuario and !eof('mwkevolpnurse')
				do case
					case = "E" and ("E" $ copciones)
						mevol = iif(lcabe, ttoc(mwkevolpnurse.fechaevol) + " - " + allt(mwkevolpnurse.nomape )+ " - ",'' )+;
							alltrim(eim_evol)
						lcabe = .f.
					case = "V" and ("V" $ copciones)
						mevol = iif(lcabe, ttoc(mwkevolpnurse.fechaevol) + " - " + allt(mwkevolpnurse.nomape )+ " - ",'' )+;
							"C.S.V."+chr(10)+alltrim(eim_evol)
						lcabe = .f.
					case = "M" and ("M" $ copciones)
						mevol = iif(lcabe, ttoc(mwkevolpnurse.fechaevol) + " - " + allt(mwkevolpnurse.nomape )+ " - ",'' )+;
							"Medicación" +chr(10)+alltrim(eim_evol)
						lcabe = .f.
					case = "C" and ("C" $ copciones)
						mevol = iif(lcabe, ttoc(mwkevolpnurse.fechaevol) + " - " + allt(mwkevolpnurse.nomape )+ " - ",'' )+;
							"Cuidados realizados" +chr(10)+alltrim(eim_evol)
						lcabe = .f.
					case = "S" and ("S" $ copciones)
						mevol = iif(lcabe, ttoc(mwkevolpnurse.fechaevol) + " - " + allt(mwkevolpnurse.nomape )+ " - ",'' )+ ;
							"Escores" +chr(10)+alltrim(eim_evol)
						lcabe = .f.
				endcase
				select mwkevolpnurse
				skip 1
			enddo
			insert into mwkevolprin (tipo,linea) values (11,mevol)
			thisform.insertolin_nur(mwkevolpnurse.EIN_evolNurse,1)
			skip 1 in mwkevolpnurse

		else

			if !eof('mwkevolpnurse')
				if midia # ttod(mwkevolpnurse.EIN_fechaH)
					miusu = mwkevolNurid.EIP_usuario
					midia = ttod(mwkevolNurid.EIN_fechaH)
					lcabe = .t.
					mevol =  "______________________________________________________________________"+ dtoc(midia)
					insert into mwkevolprin (tipo,linea) values (1,mevol)
				endif
				if !empty(alltrim(nvl(mwkevolNurid.EIN_evolNurse,'')))
					if midia # ttod(mwkevolNurid.EIN_fechaH)
						mevoln = mevoln + iif(midia =ctod("01/01/1900"),'',chr(10)+;
							"______________________________________________________________________"+ dtoc(midia)+chr(10))
						midia = ttod(mwkevolNurid.EIN_fechaH)
					endif
					thisform.insertolin_nur(ttoc(mwkevolNurid.EIN_fechaH ) + " - " + alltrim(mwkevolNurid.nomape)+;
						" - " + alltrim(mwkevolNurid.EIN_evolNurse ),2)
				endif

			endif
		endif
	enddo
	if eof('mwkevolNurid')
		do while !eof('mwkevolpnurse')
			if midia # ttod(mwkevolpnurse.fechaevol)
				midia = ttod(mwkevolpnurse.fechaevol)
				mevol =  "______________________________________________________________________"+ dtoc(midia)
				insert into mwkevolprin (tipo,linea) values (1,mevol)
			endif
			if !empty(nvl(mwkevolpnurse.eim_evol,''))
				insert into mwkevolprin (tipo,linea) values (1,'.')
				mevol = ttoc(mwkevolpnurse.fechaevol) +" M.N.:"+alltrim(transform(nvl(mwkevolpnurse.matevol,'')));
					+ " - " + allt(nvl(mwkevolpnurse.nomape,'MEDICO INTERNACION'))
				insert into mwkevolprin (tipo,linea) values (1,mevol)
				thisform.insertolin_nur(nvl(mwkevolpnurse.eim_evol,''),1)
			endif
			skip 1 in mwkevolpnurse
		enddo

	endif
	if eof('mwkevolpnurse')
		do while !eof('mwkevolNurid')
			if midia # ttod(mwkevolNurid.EIN_fechaH)
				midia = ttod(mwkevolNurid.EIN_fechaH)
				mevol =  "______________________________________________________________________"+ dtoc(midia)
				insert into mwkevolprin (tipo,linea) values (1,mevol)
			endif
			select MWKespeciall
			locate for ESP_codesp = alltrim(mwkevolNurid.eic_codesp)
			miesp = ''
			if found()
				miesp = "con "+alltrim(ESP_descripcion)
			endif
			mevol = "Interconsulta "+ miesp +" - " +ttoc(mwkevolNurid.EIN_fechaH) + " M.N.:"+alltrim(transform(mwkevolNurid.matic))+ " - " + allt(mwkevolNurid.nomape )
			insert into mwkevolprin (tipo,linea) values (11,mevol)
			thisform.insertolin_nur(mwkevolNurid.EIN_evolNurse,1)
			skip 1 in mwkevolNurid
		enddo

	endif
