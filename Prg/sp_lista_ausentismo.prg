****
** Listado estadistico para Morgulis primero disponible, cantidad ocupados, libres
****

Parameter mfecdes, mfechas, mbusco1, mlista, mbusco2, msectur,mbusco3


If Vartype(msectur)#"C"
	msectur = ""
Endif

If Vartype(mbusco3)#"C"
	mbusco3 = ""
Endif

lsigue = .T.
If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif

mccpocmed = " centromed = ?mxcentromedico and "

Use In Select("mwkespecag")
mret = SQLExec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")

** Control de fecha de cierre
mret = SQLExec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
' where &mccpoamb  id < 100000  order by fechacierre ','mwkctrlfecha')
Go Bottom In mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
Use In mwkctrlfecha
*mhfechas = datetime()
mret = SQLExec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, nombre,turnos.codesp, " + ;
"tipoturno, confirmado, turnos.diasem,hhmmtur,PRE_modoatencion " + ;
"from turnos, prestadores,Prestacions " + ;
"where &mccpoamb turnos.codreserva<>'' and turnos.codmed = prestadores.id and codprest = PRE_codprest and " + ;
"fechatur >= ?mfecdes and fechatur <= ?mfechas and " + ;
"(tipoturno < 8 or tipoturno >9) " + ;
mbusco1 +mbusco3 + msectur , "mwktodosa")
If mret < 0
	=Aerr(eros)
	Do prg_error With eros,'sp_lista_ausentismo1'
Endif
If mfecdes <= mfechalimite

	mret = SQLExec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, nombre,turnos.codesp, " + ;
	"tipoturno, confirmado, turnos.diasem,hhmmtur,PRE_modoatencion " + ;
	"from turnoshis as turnos, prestadores,Prestacions  " + ;
	"where &mccpoamb turnos.codreserva<>'' and  turnos.codmed = prestadores.id and codprest = PRE_codprest and " + ;
	"fechatur >= ?mfecdes and fechatur <= ?mfechas and " + ;
	"(turnos.tipoturno < 8 or turnos.tipoturno >9 " + ;
	mbusco1 +mbusco3+ msectur , "mwktodosb")
	If mret < 0
		=Aerr(eros)
		Do prg_error With eros,'sp_lista_ausentismo2'
	Endif
Endif
mret = SQLExec(mcon1, "select codmed, diasem, fecvigend, fecvigenh, horadesde, horahasta, " + ;
" tipoturno as pe, abrevio, estructura, hhmmDes, hhmmHas "+;
" from franjahoraria left join tabtipofranja on franjahoraria.tiposervicio = tabtipofranja.id " + ;
" where &mccpoamb &mccpocmed  fecvigenh > ?mfecdes and fecvigend <= ?mfechas and fecvigenh <>fecvigend " + ;
mbusco2 + " group by codmed, diasem, horahasta, fecvigenh, tiposervicio " , "mwkfranjas")

If mret < 0
	=Aerr(eros)
	Do prg_error With eros,'sp_lista_ausentismo3'
Endif

If mfecdes <= mfechalimite
	If Reccount('mwktodosa')>0
		Select *,Iif(afiliado <= 1,Id, afiliado) As afi From mwktodosa ;
		union All ;
		select *,Iif(afiliado <= 1,Id, afiliado) As afi  From mwktodosb ;
		into Cursor mwktodos
	Else
		Select *,Iif(afiliado <= 1,Id, afiliado) As afi  From mwktodosb ;
		into Cursor mwktodos
	Endif
Else
	Select *,Iif(afiliado <= 1,Id, afiliado) As afi  From mwktodosa ;
	into Cursor mwktodos
Endif

mbuscom = Strtran(mbusco1,"turnos.","")
Do sp_medpresta_mas_st_so With mfechas,mbuscom,mfecdes

mret = SQLExec(mcon1, "select ESP_codesp, ESP_descripcion " + ;
"from especialid " ,"mwkespe")
If mret < 0
	=Aerr(eros)
	Do prg_error With eros,'sp_lista_ausentismo4'
Endif


Select mwktodos.Id,afi,mwktodos.diasem,	mwktodos.codmed, afiliado, fechatur, horatur, nombre, ;
mwktodos.tipoturno, confirmado, hdesde1, hhasta1, cantidad, porcentaje, ;
abrevio, pe,mwkmedpre.codesp,ESP_descripcion,  ;
mwkmedpre.horadesde, mwkmedpre.horahasta, estructura,mwkmedpre.duracion,PRE_modoatencion   ;
from mwktodos ;
left Join mwkmedpre On (mwktodos.fechatur >= mwkmedpre.fecvigend And ;
mwktodos.fechatur <  mwkmedpre.fecvigenh And ;
hhmmtur >= mwkmedpre.hhmmDes And hhmmtur< mwkmedpre.hhmmHas And ;
mwktodos.codmed = mwkmedpre.codmed And ;
mwktodos.diasem = mwkmedpre.diasem );
inner Join mwkfranjas On (mwktodos.fechatur >= mwkfranjas.fecvigend And ;
mwktodos.fechatur <  mwkfranjas.fecvigenh And ;
hhmmtur >= mwkfranjas.hhmmDes And hhmmtur< mwkfranjas.hhmmHas And ;
mwktodos.codmed = mwkfranjas.codmed And ;
mwktodos.diasem = mwkfranjas.diasem );
left Join mwkespe On Trim(mwkmedpre.codesp) = Trim(ESP_codesp) ;
where mwktodos.codesp = mwkmedpre.codesp ;
into Cursor mwktodosga

Select mwktodos.Id,afi,mwktodos.diasem,	mwktodos.codmed, afiliado, fechatur, horatur, nombre, ;
mwktodos.tipoturno, confirmado, hdesde1, hhasta1, cantidad, porcentaje, ;
abrevio, pe,mwkmedpre.codesp,ESP_descripcion,  ;
mwkmedpre.horadesde, mwkmedpre.horahasta, estructura,duracion,PRE_modoatencion   ;
from mwktodos ;
left Join mwkmedpre On (mwktodos.fechatur >= mwkmedpre.fecvigend And ;
mwktodos.fechatur <  mwkmedpre.fecvigenh And ;
hhmmtur >= mwkmedpre.hhmmDes And hhmmtur< mwkmedpre.hhmmHas And ;
mwktodos.codmed = mwkmedpre.codmed And ;
mwktodos.diasem = mwkmedpre.diasem );
inner Join mwkfranjas On (mwktodos.fechatur >= mwkfranjas.fecvigend And ;
mwktodos.fechatur <  mwkfranjas.fecvigenh And ;
hhmmtur >= mwkfranjas.hhmmDes And hhmmtur< mwkfranjas.hhmmHas And ;
mwktodos.codmed = mwkfranjas.codmed And ;
mwktodos.diasem = mwkfranjas.diasem );
left Join mwkespe On Trim(mwkmedpre.codesp) = Trim(ESP_codesp) ;
where 	Empty(mwktodos.codesp);
into Cursor mwktodosgb

Select * From mwktodosga Union All Select * From mwktodosgb ;
into Cursor mwktodosg


mgroup = Iif(mlista=3,',PRE_modoatencion ,codesp,tipoturno',Iif(mlista=4,',PRE_modoatencion ,codesp,codmed,tipoturno ','' ) )
Select afi, diasem,	codmed, afiliado, fechatur, horatur, nombre, ;
tipoturno, confirmado, hdesde1, hhasta1, cantidad, porcentaje, ;
nvl(abrevio,"S/D") As abrevio, Nvl(pe,0) As pe,codesp,ESP_descripcion,  ;
horadesde, horahasta, Nvl(estructura,"I") As estructura,duracion ,PRE_modoatencion  ;
from mwktodosg	;
group By Id,afi,codmed, codesp, fechatur, horatur, tipoturno ;
into Cursor mwktodosa

Do Case
Case mlista = 1
	Select nombre, fechatur, ;
	iif(diasem = 2, 'Lun', Iif(diasem = 3, 'Mar', ;
	iif(diasem = 4, 'Mie', Iif(diasem = 5, 'Jue', ;
	iif(diasem = 6, 'Vie', Iif(diasem = 7, 'Sab', 'Dom')))))) As dia, ;
	sum(Iif(afiliado <= 1 , 1, 0000)) As libre, ;
	sum(Iif(afiliado > 1 And !Inlist(tipoturno,1,2), 1, 0000)) As ocupast, ;
	sum(Iif(afiliado > 1 And !Inlist(tipoturno,1,2) And confirmado = 0, 1, 0000)) As faltost, ;
	sum(Iif(afiliado > 1, 1, 0000)) As ocupa, ;
	sum(Iif(afiliado > 1 And confirmado = 0 And PRE_modoatencion  ='VIRTUAL', 1, 0000)) As faltodist, ;
	sum(Iif(afiliado > 1 And confirmado = 0 And PRE_modoatencion <>'VIRTUAL', 1, 0000)) As falto , ;
	sum(Iif(afiliado > 1 And confirmado = 1 And PRE_modoatencion  ='VIRTUAL', 1, 0000)) As vinodist, ;
	sum(Iif(afiliado > 1 And confirmado = 1 And PRE_modoatencion <>'VIRTUAL', 1, 0000)) As vino, ;
	count(afiliado) As ofrecido, hdesde1, hhasta1, cantidad, ;
	sum(Iif(tipoturno = 2, 1, 0000)) As ST, ;
	porcentaje, abrevio, pe, estructura,codesp,duracion,hhasta1-hdesde1 As horas ;
	from mwktodosa ;
	group By nombre, diasem, horadesde, horahasta, abrevio ;
	order By nombre, diasem, horadesde, horahasta, abrevio ;
	into Cursor mwklista

Case mlista = 2
	Select nombre, fechatur, ;
	iif(Dow(fechatur) = 2, 'Lunes     ', Iif(Dow(fechatur) = 3, 'Martes    ', ;
	iif(Dow(fechatur) = 4, 'Miércoles ', Iif(Dow(fechatur) = 5, 'Jueves    ', ;
	iif(Dow(fechatur) = 6, 'Viernes   ', Iif(Dow(fechatur) = 7, 'Sabado    ', ;
	'Domingo   ')))))) As dia, ;
	sum(Iif(afiliado <= 1, 1, 0000)) As libre, ;
	sum(Iif(afiliado > 1 And !Inlist(tipoturno,1,2), 1, 0000)) As ocupast, ;
	sum(Iif(afiliado > 1 And !Inlist(tipoturno,1,2) And confirmado = 0, 1, 0000)) As faltost, ;
	sum(Iif(afiliado > 1, 1, 0000)) As ocupa, ;
	sum(Iif(afiliado > 1 And confirmado = 0 And PRE_modoatencion  ='VIRTUAL', 1, 0000)) As faltodist, ;
	sum(Iif(afiliado > 1 And confirmado = 0 And PRE_modoatencion <>'VIRTUAL', 1, 0000)) As falto , ;
	sum(Iif(afiliado > 1 And confirmado = 1 And PRE_modoatencion  ='VIRTUAL', 1, 0000)) As vinodist, ;
	sum(Iif(afiliado > 1 And confirmado = 1 And PRE_modoatencion <>'VIRTUAL', 1, 0000)) As vino, ;
	sum(Iif(tipoturno = 2, 1, 0000)) As ST, ;
	count(afiliado) As ofrecido, hdesde1, hhasta1, cantidad, porcentaje,;
	codesp,duracion ,hhasta1-hdesde1 As horas;
	from mwktodosa ;
	group By nombre, fechatur, horadesde, horahasta ;
	order By nombre, fechatur, horadesde, horahasta ;
	into Cursor mwklista
Case mlista = 3
	Select nombre, fechatur, Iif(tipoturno = 7, 'PE', '  ') As tpe, ;
	iif(Dow(fechatur) = 2, 'Lunes     ', Iif(Dow(fechatur) = 3, 'Martes    ', ;
	iif(Dow(fechatur) = 4, 'Miércoles ', Iif(Dow(fechatur) = 5, 'Jueves    ', ;
	iif(Dow(fechatur) = 6, 'Viernes   ', Iif(Dow(fechatur) = 7, 'Sabado    ', ;
	'Domingo   ')))))) As dia, ;
	sum(Iif(afiliado <= 1, 1, 0000)) As libre,ESP_descripcion, ;
	sum(Iif(afiliado > 1 And !Inlist(tipoturno,1,2), 1, 0000)) As ocupast, ;
	sum(Iif(afiliado > 1 And !Inlist(tipoturno,1,2) And confirmado = 0, 1, 0000)) As faltost, ;
	sum(Iif(afiliado > 1, 1, 0000)) As ocupa, ;
	sum(Iif(afiliado > 1 And confirmado = 0 And PRE_modoatencion  ='VIRTUAL', 1, 0000)) As faltodist, ;
	sum(Iif(afiliado > 1 And confirmado = 0 And PRE_modoatencion <>'VIRTUAL', 1, 0000)) As falto , ;
	sum(Iif(afiliado > 1 And confirmado = 1 And PRE_modoatencion  ='VIRTUAL', 1, 0000)) As vinodist, ;
	sum(Iif(afiliado > 1 And confirmado = 1 And PRE_modoatencion <>'VIRTUAL', 1, 0000)) As vino, ;
	sum(Iif(tipoturno = 2, 1, 0000)) As ST, ;
	count(afiliado) As ofrecido, hdesde1, hhasta1, cantidad, porcentaje,codesp,duracion  ;
	from mwktodosa Where !Isnul(hdesde1);
	group By codesp, tpe;
	order By ESP_descripcion, tpe ;
	into Cursor mwklista
Case mlista = 4
	Select nombre, fechatur, Iif(tipoturno = 7, 'PE', '  ') As tpe, ;
	iif(Dow(fechatur) = 2, 'Lunes     ', Iif(Dow(fechatur) = 3, 'Martes    ', ;
	iif(Dow(fechatur) = 4, 'Miércoles ', Iif(Dow(fechatur) = 5, 'Jueves    ', ;
	iif(Dow(fechatur) = 6, 'Viernes   ', Iif(Dow(fechatur) = 7, 'Sabado    ', ;
	'Domingo   ')))))) As dia, ;
	sum(Iif(afiliado <= 1, 1, 0000)) As libre,ESP_descripcion, ;
	sum(Iif(afiliado > 1 And !Inlist(tipoturno,1,2), 1, 0000)) As ocupast, ;
	sum(Iif(afiliado > 1 And !Inlist(tipoturno,1,2) And confirmado = 0, 1, 0000)) As faltost, ;
	sum(Iif(afiliado > 1, 1, 0000)) As ocupa, ;
	sum(Iif(afiliado > 1 And confirmado = 0 And PRE_modoatencion  ='VIRTUAL', 1, 0000)) As faltodist, ;
	sum(Iif(afiliado > 1 And confirmado = 0 And PRE_modoatencion <>'VIRTUAL', 1, 0000)) As falto , ;
	sum(Iif(afiliado > 1 And confirmado = 1 And PRE_modoatencion  ='VIRTUAL', 1, 0000)) As vinodist, ;
	sum(Iif(afiliado > 1 And confirmado = 1 And PRE_modoatencion <>'VIRTUAL', 1, 0000)) As vino, ;
	sum(Iif(tipoturno = 2, 1, 0000)) As ST, ;
	count(afiliado) As ofrecido, hdesde1, hhasta1, cantidad, porcentaje,codesp,duracion  ;
	from mwktodosa Where !Isnul(hdesde1);
	group By codesp, codmed,fechatur ;
	order By ESP_descripcion,nombre,fechatur ;
	into Cursor mwklista

Endcase
