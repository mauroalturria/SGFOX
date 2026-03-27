mfecha = ctod("11/04/2013")-1
set step on
for yy=1 to 1
	cfiles="turnos_"+transf(yy+10,"@L 99")+"_04.dbf"
	cfilexls = "turno_"+transf(yy+10,"@L 99")+"04"
	if file(cfiles)
		mifecha = mfecha+yy
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

*set step on
		select turnos
		scan
			mihc = turnos.n_ref
			requery('turnos_telid')
			select turnos
			wait windows transform(recno()) nowait
			if reccount('turnos_telid')= 0
					replace estado with 'NOAN'
			else
				select turnos
				replace apeynom with turnos_telid.REG_nombrepac;
					,fecnac  with turnos_telid.REG_fecnacimiento, sexo with alltrim(turnos_telid.reg_sexo),;
					domic with nvl(turnos_telid.REG_domicilio,''),provincia with nvl(turnos_telid.REG_provincia,'');
					,localidad with nvl(turnos_telid.REG_localidad,''), codpos with transform(nvl(turnos_telid.REG_cpostal,0));
					, codent with turnos_telid.codent,estado with iif(turnos_telid.confirmado=1,"PRES","AUS");
					,especial with iif(isnull(turnos_telid.ESP_descripcion),turnos_telid.codesp,turnos_telid.ESP_descripcion)
			endif
		endscan
		copy to &cfilexls  type xl5
		use in turnos

	endif
next yy
