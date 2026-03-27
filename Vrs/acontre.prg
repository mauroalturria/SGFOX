
		SELECT mwkdatos
		IF VARTYPE(ValorFloat1 )#"N"
			do sp_busco_datos
		ENDIF
		SELECT mwkveopass
		if mwkdatos.ValorFloat1 # 1
			do sp_busco_resgpass with 1,mcodmed
			if reccount('mwkresgpass')= 0
				lcambiarpass = .t.
			else
				mfech = sp_busco_fecha_serv('DD')
				if mfech-ttod(mwkresgpass.FechaAct)>mwkdatos.ValorFloat1
					lcambiarpass = .t.
				endif
			endif
		endif
	IF !USED('mwkdatos')
		do sp_busco_datos
	endif
	select mwkdatos
	if vartype(ValorFloat1 )#"N"
		do sp_busco_datos
	endif
	if mwkdatos.ValorFloat1 >1
		do sp_busco_resgpass with 1,mcodmed
	endif

with thisform
	lsigue = .f.
	.cmdaceptar.enabled = .f.
	.cmdcpass.enabled = .f.
	mcodvax = mwkusuarios.codigovax
	mnmedico = mwkusuarios.IdCodMed
	mhora = sp_busco_fecha_serv('DT')
	midusua	= upper(alltrim(mwkusuarios.idusuario))
	if left(mwkusuarios.nomape,1)#"*"
		if !empty(.txtpassword.value)
			midusua	= upper(alltrim(mwkusuarios.idusuario))
			mpasswo	= alltrim(upper(.txtpassword.value))
			do sp_busco_usuario_sec with midusua, mpasswo
			if reccount('mwkusuario_sec') = 0
				messagebox("DATOS ERRONEOS, VERIFIQUE SUS DATOS",48,"Validacion")
				mncodvax = 0
				.cbousuario.setfocus()
			else
				mcodmed = mwkusuario_sec.codigovax
				select * from mwkusuarios where codigovax= mcodmed  into cursor mwkautorizado
				if reccount('mwkautorizado')>0 and !inlist(midusua,'ENFERMERIA','MEDICO','ANAIS')
					mncodvax 	= iif(mwkusuarios.codigovax = 0, 99999, mwkusuarios.codigovax)
					miususec 	= mwkusuario_sec.idusuario
					mid			= mwkusuario_sec.id
					if thisform.llabo = 1
						do sp_insert_tabaccesolab with alltrim(upper(miususec)),mid
					endif
					if .miexe = 'ENFERMERIA'
*-*-*-*-*-*-*- MSG
						do sp_busco_guamsg with 1, mwkusuario_sec.id, 1, " and TGM_Estado = 1 "
						if reccount("mwkGuaMsg")>0
							messagebox("TIENE MENSAJES PENDIENTES",64,"AVISO")
						endif
						use in mwkGuaMsg
					endif
					lsigue = .t.
					if .lcontrolmed = 1
						ldfechoy = ttod(mwkfecserv.fechahora)
						lcontrola = .t.
						if mnmedico > 1
							do sp_busco_medico_datos with mnmedico, "mwkveopassid"
							if nvl(mwkveopassid.TPF_filtro,0)=0
								lcontrola = .t.
							endif
						endif
						if lcontrola 
						if (fecpasivap > ctod("01/01/1900") and fecpasivap <= ldfechoy)
							do sp_actualizo_tabusuario with ,,mwkusuarios.codigovax,,, mwkveopassid.fecpasivap, 3
							messagebox("      USUARIO NO HABILITADO " + chr(13) + ;
								"COMUNIQUESE CON SISTEMAS (INT 8668) ",48,"VALIDACION")
							lsigue = .f.
							mncodvax = 0
							mnmedico = 0
							return .f.
						endif

					else
						mfechoy = ttod(mwkfecserv.fechahora)
						if mwkusuario.fecexpira <= mfechoy and upper(midusua)#"MEDICO"
							if mwkusuario.diasaviso>mfechoy
								if messagebox("SU CONTRASEÑA CADUCA INDEFECTIBLEMENTE EL ";
										+ dtoc(mwkusuario.diasaviso)+chr(13)+"DEBE CAMBIARLA ANTES DE ESA FECHA!!!";
										,1+64+256,"Validacion")=2    &&&(cancela)
									.cmdaceptar.enabled = .f.
									.cbosector.enabled	= .f.
									.txtnombre.setfocus()
								else
									.cbosector.controlsource = "mwksector2.id"
									.cbosector.rowsource	 = "mwksector2.descrip,id"
									select mwksector2
									locate for preferido = 1
									if eof()
										go top
									endif
									.cbosector.displayvalue	 = mwksector2.descrip
									.cbosector.enabled		 = .t.
									.cmdaceptar.enabled = .t.
									mcodvax = iif(mwkusuario.codigovax = 0, '99999', str(mwkusuario.codigovax, 5))
								endif
							else
								.cmdaceptar.enabled = .f.
								.cbosector.enabled	= .f.
*!*							messagebox("SU CONTRASEÑA HA CADUCADO EL "+dtoc(mwkusuario.diasaviso);
*!*								+chr(13)+"COMUNIQUESE CON SISTEMAS",48,"Validacion")
*!*							.txtnombre.setfocus()
								messagebox("SU CONTRASEÑA HA CADUCADO EL "+dtoc(mwkusuario.diasaviso)+chr(10)+;
									"SE PROCEDE A SU ACTUALIZACION",48,"Validación")
								select mwkusuario_sec.*, "pisos"as sector ;
									from mwkusuario ;
									into cursor mwkusuario
								do form frmpass_amb WITH 
								IF USED(
							endif
						endif


					endif
					if lsigue

						mqform = .mformeje
						if !empty(mqform)
							do form &mqform
						endif
						.cmdaceptar.enabled = .t.
						.cmdcpass.enabled = !inlist(mpasswo,"SISTEMAS","AUDITORIA","EXTERNO")
						.cmdaceptar.setfocus()
					endif
				else
					messagebox('ESTE USUARIO NO ESTA AUTORIZADO A INGRESAR', 48, 'Validacion')
					mncodvax = 0
				endif
			endif
		else
			messagebox('FALTA INGRESAR SU PASSWORD', 48, 'Validacion')
			mncodvax = 0
		endif
	else
		messagebox('NO PUEDE UTILIZAR USUARIO GENERICOS....', 48, 'Validacion')
		mncodvax = 0
	endif
endwith
