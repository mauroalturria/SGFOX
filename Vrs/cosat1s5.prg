public mcon1
do sp_conexion

mfecdes = ctod("01/01/2005")
mfechas = ctod("31/01/2005")

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
copy to totturene5 type xls

mfecdes = ctod("01/02/2005")
mfechas = ctod("28/02/2005")

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
copy to totturfeb5 type xls

mfecdes = ctod("01/03/2005")
mfechas = ctod("31/03/2005")

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
copy to totturmar5 type xls

mfecdes = ctod("01/04/2005")
mfechas = ctod("30/04/2005")

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
copy to totturabr5 type xls

mfecdes = ctod("01/05/2005")
mfechas = ctod("31/05/2005")

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
copy to totturmay5 type xls


mfecdes = ctod("01/06/2005")
mfechas = ctod("30/06/2005")

mret = sqlexec(mcon1, "select turnos.id,afiliado, fechatur, codmed, nombre,turnos.codesp, " + ;
	"tipoturno, confirmado " + ;
	", especialid.esp_descripcion " + ;
	"from turnos, especialid " + ;
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
copy to totturjun5 type xls
