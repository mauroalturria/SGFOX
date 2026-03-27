mfecha = ctod("03/08/2013")-1
for yy=3 to 8
	cfiles="turnos_"+transf(yy,"@L 99")+"_08.dbf"
	cfilexls = "turno_"+transf(yy,"@L 99")+"08"
	if file(cfiles)
		use &cfiles in 0 exclusive alias turnos
		alter table turnos   add column fecnac D
		alter table turnos  add column sexo c(1)
		alter table turnos  add column domic c(50)
		alter table turnos  add column provincia c(50)
		alter table turnos  add column localidad c(50)
		alter table turnos  add column codpos c(5)
		alter table turnos  add column codent n(5)
		alter table turnos  add column apeynom c(50)
		alter table turnos  add column estado c(20)
		alter table turnos  add column especial c(50)

		select turnos
		mifecha = turnos.fecha_trun
		scan
			mihc = turnos.hclin
			requery('turnos_tel')
			select turnos
			wait windows transform(recno()) nowait
			if reccount('turnos_tel')= 0
				requery('turnos_telc')
				select turnos
				if reccount('turnos_telc')= 0
					nref = turnos.n_ref
					requery('turnos_telid')
					if reccount('turnos_telid')= 0
						replace estado with 'NOAN'
					else
						select turnos
						replace apeynom with turnos_telid.REG_nombrepac;
							,fecnac  with turnos_telid.REG_fecnacimiento, sexo with alltrim(turnos_telid.reg_sexo),;
							domic with nvl(turnos_telid.REG_domicilio,''),provincia with nvl(turnos_telid.REG_provincia,'');
							,localidad with nvl(turnos_telid.REG_localidad,''), codpos with transform(nvl(turnos_telid.REG_cpostal,0));
							, codent with turnos_telid.codent,estado with iif(turnos_telid.confirmado=1,"PRE_","AUS_")+"REP"+dtoc(turnos_telid.fechatur);
							,especial with iif(isnull(turnos_telid.ESP_descripcion),turnos_telid.codesp,turnos_telid.ESP_descripcion)
					endif
				else
					replace estado with iif(turnos_telc.coDcancela =5,"CMAS",;
						iif(turnos_telc.codcancela =2,"PACTE",;
						iif(turnos_telc.codcancela =6,"3AUS",;
						iif(turnos_telc.codcancela =36,"A1T",;
						iif(turnos_telc.codcancela =28,"CAM",;
						iif(turnos_telc.codcancela =30,"CxO",;
						iif(turnos_telc.codcancela =42,"TMC",;
						iif(turnos_telc.codcancela =49,"IVR","OTRO")))))))),;
						fecnac with turnos_telc.REG_fecnacimiento, sexo with alltrim(turnos_telc.reg_sexo),;
						domic with nvl(turnos_telc.REG_domicilio,''),provincia with nvl(turnos_telc.REG_provincia,'');
						,localidad with nvl(turnos_telc.REG_localidad,''), codpos with transform(nvl(turnos_telc.REG_cpostal,0));
						, codent with turnos_telc.codent;
						,apeynom with turnos_telc.REG_nombrepac;
						,especial with iif(isnull(turnos_telc.ESP_descripcion),turnos_telc.codesp,turnos_telc.ESP_descripcion)
				endif

			else
				select turnos
				replace apeynom with turnos_tel.REG_nombrepac;
					,fecnac  with turnos_tel.REG_fecnacimiento, sexo with alltrim(turnos_tel.reg_sexo),;
					domic with nvl(turnos_tel.REG_domicilio,''),provincia with nvl(turnos_tel.REG_provincia,'');
					,localidad with nvl(turnos_tel.REG_localidad,''), codpos with transform(nvl(turnos_tel.REG_cpostal,0));
					, codent with turnos_tel.codent,estado with iif(turnos_tel.confirmado=1,"PRES","AUS");
					,especial with iif(isnull(turnos_tel.ESP_descripcion),turnos_tel.codesp,turnos_tel.ESP_descripcion)
			endif
		endscan
		copy to &cfilexls  type xl5
		use in turnos

	endif
next yy
