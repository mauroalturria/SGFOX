public mcon1
do sp_conexion

mfecdes = ctod("01/07/2004")
mfechas = ctod("31/07/2004")

mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, codmed, nombre,turnos.codesp, " + ;
	"tipoturno, confirmado " + ;
	", especialid.esp_descripcion " + ;
	"from turnoshis as turnos, especialid " + ;
	" left join prestadores on turnos.codmed = prestadores.id "+;
	"where turnos.codesp = trim(especialid.esp_codesp) " + ;
	" and turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas " + ;
	" and tipoturno < 9 and turnos.codesp ='CIRP' "+;
	" group by afiliado, fechatur, codmed " , "mwktodosc1")
if mret < 0
	=aerr(eros)
		messagebox(eros(3), 16, "Validacion")
endif

select codmed,nombre,sum (IIF(confirmado=1,1,0)) as pacatend, count(tipoturno) as tdados; 
 from mwktodosc1 group by codmed into cursor total
select total
copy to totturjul type xls

mfecdes = ctod("01/08/2004")
mfechas = ctod("31/08/2004")

mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, codmed, nombre,turnos.codesp, " + ;
	"tipoturno, confirmado " + ;
	", especialid.esp_descripcion " + ;
	"from turnoshis as turnos, especialid " + ;
	" left join prestadores on turnos.codmed = prestadores.id "+;
	"where turnos.codesp = trim(especialid.esp_codesp) " + ;
	" and turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas " + ;
	" and tipoturno < 9 and turnos.codesp ='CIRP' "+;
	" group by afiliado, fechatur, codmed " , "mwktodosc1")
if mret < 0
	=aerr(eros)
		messagebox(eros(3), 16, "Validacion")
endif

select codmed,nombre,sum (IIF(confirmado=1,1,0)) as pacatend, count(tipoturno) as tdados; 
 from mwktodosc1 group by codmed into cursor total
select total
copy to totturago type xls

mfecdes = ctod("01/09/2004")
mfechas = ctod("30/09/2004")

mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, codmed, nombre,turnos.codesp, " + ;
	"tipoturno, confirmado " + ;
	", especialid.esp_descripcion " + ;
	"from turnoshis as turnos, especialid " + ;
	" left join prestadores on turnos.codmed = prestadores.id "+;
	"where turnos.codesp = trim(especialid.esp_codesp) " + ;
	" and turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas " + ;
	" and tipoturno < 9 and turnos.codesp ='CIRP' "+;
	" group by afiliado, fechatur, codmed " , "mwktodosc1")
if mret < 0
	=aerr(eros)
		messagebox(eros(3), 16, "Validacion")
endif

select codmed,nombre,sum (IIF(confirmado=1,1,0)) as pacatend, count(tipoturno) as tdados; 
 from mwktodosc1 group by codmed into cursor total
select total
copy to tottursep type xls

mfecdes = ctod("01/10/2004")
mfechas = ctod("31/10/2004")

mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, codmed, nombre,turnos.codesp, " + ;
	"tipoturno, confirmado " + ;
	", especialid.esp_descripcion " + ;
	"from turnoshis as turnos, especialid " + ;
	" left join prestadores on turnos.codmed = prestadores.id "+;
	"where turnos.codesp = trim(especialid.esp_codesp) " + ;
	" and turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas " + ;
	" and tipoturno < 9 and turnos.codesp ='CIRP' "+;
	" group by afiliado, fechatur, codmed " , "mwktodosc1")
if mret < 0
	=aerr(eros)
		messagebox(eros(3), 16, "Validacion")
endif

select codmed,nombre,sum (IIF(confirmado=1,1,0)) as pacatend, count(tipoturno) as tdados; 
 from mwktodosc1 group by codmed into cursor total
select total
copy to totturoct type xls

mfecdes = ctod("01/11/2004")
mfechas = ctod("30/11/2004")

mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, codmed, nombre,turnos.codesp, " + ;
	"tipoturno, confirmado " + ;
	", especialid.esp_descripcion " + ;
	"from turnoshis as turnos, especialid " + ;
	" left join prestadores on turnos.codmed = prestadores.id "+;
	"where turnos.codesp = trim(especialid.esp_codesp) " + ;
	" and turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas " + ;
	" and tipoturno < 9 and turnos.codesp ='CIRP' "+;
	" group by afiliado, fechatur, codmed " , "mwktodosc1")
if mret < 0
	=aerr(eros)
		messagebox(eros(3), 16, "Validacion")
endif

select codmed,nombre,sum (IIF(confirmado=1,1,0)) as pacatend, count(tipoturno) as tdados; 
 from mwktodosc1 group by codmed into cursor total
select total
copy to totturnov type xls


mfecdes = ctod("01/12/2004")
mfechas = ctod("31/12/2004")

mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, codmed, nombre,turnos.codesp, " + ;
	"tipoturno, confirmado " + ;
	", especialid.esp_descripcion " + ;
	"from turnoshis as turnos, especialid " + ;
	" left join prestadores on turnos.codmed = prestadores.id "+;
	"where turnos.codesp = trim(especialid.esp_codesp) " + ;
	" and turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas " + ;
	" and tipoturno < 9 and turnos.codesp ='CIRP' "+;
	" group by afiliado, fechatur, codmed " , "mwktodosc1")
if mret < 0
	=aerr(eros)
		messagebox(eros(3), 16, "Validacion")
endif

select codmed,nombre,sum (IIF(confirmado=1,1,0)) as pacatend, count(tipoturno) as tdados; 
 from mwktodosc1 group by codmed into cursor total
select total
copy to totturdic type xls

close all

