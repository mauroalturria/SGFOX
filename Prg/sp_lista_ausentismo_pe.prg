****
** Listado estadistico para Morgulis primero disponible, cantidad ocupados, libres
****

Parameter mfecdes, mfechas, mbusco1, mlista,mbusco2 
mbusco3 = ''
lsigue = .T.
If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif
** Control de fecha de cierre
mret = SQLExec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
' where &mccpoamb id < 100000  order by fechacierre ','mwkctrlfecha')
If mret < 0
	=Aerr(eros)
	Do prg_error With eros,'sp_lista_ausentismo_pe1'
Endif
Go Bottom In mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
Use In mwkctrlfecha
mret = SQLExec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, nombre,turnos.codesp, " + ;
"tipoturno, confirmado, turnos.diasem,hhmmtur,PRE_modoatencion " + ;
"from turnos, prestadores,Prestacions " + ;
"where &mccpoamb  turnos.codreserva<>'' and turnos.codmed = prestadores.id  and codprest = PRE_codprest and " + ;
"fechatur >= ?mfecdes and fechatur <= ?mfechas and " + ;
" (turnos.tipoturno < 8  or turnos.tipoturno >=13) " + ;
mbusco1 +mbusco3, "mwktodosa")
If mret < 0
	=Aerr(eros)
	Do prg_error With eros,'sp_lista_ausentismo_pe2'
Endif
If mfecdes <= mfechalimite

	mret = SQLExec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, nombre,turnos.codesp, " + ;
	"tipoturno, confirmado, turnos.diasem,hhmmtur,PRE_modoatencion " + ;
	"from turnoshis as turnos, prestadores,Prestacions " + ;
	"where &mccpoamb turnos.codreserva<>'' and  turnos.codmed = prestadores.id and codprest = PRE_codprest and " + ;
	"fechatur >= ?mfecdes and fechatur <= ?mfechas " + ;
	mbusco1 +mbusco3, "mwktodosb")
	If mret < 0
		=Aerr(eros)
		Do prg_error With eros,'sp_lista_ausentismo_pe3'
	Endif
Endif
mret = SQLExec(mcon1, "select codmed, diasem, fecvigend, fecvigenh, horadesde, horahasta, " + ;
" tipoturno as pe, abrevio, estructura, hhmmDes, hhmmHas "+;
" from franjahoraria left join tabtipofranja on franjahoraria.tiposervicio = tabtipofranja.id " + ;
" where &mccpoamb fecvigenh > ?mfecdes and fecvigend <= ?mfechas " + ;
" and fecvigenh <> fecvigend  " + mbusco2 + ;
" group by codmed, diasem, horahasta, fecvigenh, tiposervicio " + ;
"", "mwkfranjas")
*** &mbusco1
If mret < 0
	=Aerr(eros)
	Do prg_error With eros,'sp_lista_ausentismo_pe4'
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

Do sp_medpresta_mas_st_so With mfechas,'',mfecdes

Select Id,afi,mwktodos.diasem,	mwktodos.codmed, afiliado, fechatur, horatur, nombre, ;
mwktodos.tipoturno, confirmado, hdesde1, hhasta1, cantidad, porcentaje, ;
abrevio, pe,mwkmedpre.codesp,mwkfranjas.fecvigend,mwkfranjas.fecvigenh, ;
mwkmedpre.horadesde, mwkmedpre.horahasta, estructura,duracion,PRE_modoatencion;
from mwktodos ;
left Join mwkfranjas On (mwktodos.fechatur >= mwkfranjas.fecvigend And ;
mwktodos.fechatur <  mwkfranjas.fecvigenh And ;
hhmmtur >= mwkfranjas.hhmmDes And hhmmtur< mwkfranjas.hhmmHas And ;
mwktodos.codmed = mwkfranjas.codmed And ;
mwktodos.diasem = mwkfranjas.diasem );
left Join mwkmedpre On (;
mwkfranjas.codmed = mwkmedpre.codmed And ;
mwkfranjas.diasem = mwkmedpre.diasem And ;
mwkfranjas.hhmmDes 	= mwkmedpre.hhmmDes And ;
mwkfranjas.hhmmHas = mwkmedpre.hhmmHas And ;
mwkfranjas.fecvigend <= mwkmedpre.fecvigend And ;
mwkfranjas.fecvigenh >= mwkmedpre.fecvigenh );
into Cursor mwktodosg


mgroup = Iif(mlista=3,',codesp','' )

Select afi,diasem, codmed, afiliado, fechatur, horatur, nombre, ;
tipoturno, confirmado, hdesde1, hhasta1, cantidad, porcentaje, ;
nvl(abrevio,"S/D") As abrevio, Nvl(pe,0) As pe,codesp, ;
horadesde, horahasta, Nvl(estructura,"I") As estructura,duracion,PRE_modoatencion;
,fecvigend,fecvigenh;
from mwktodosg	;
group By Id,afi,codmed, codesp, fechatur, horatur, tipoturno ;
into Cursor mwktodosa

**
Select * From mwktodosa ;
group By codmed, codesp, fechatur, hdesde1, hhasta1 ;
order By codmed, codesp, fechatur, hdesde1 ;
into Cursor mwktodosa1

If mlista = 1
	Select mwktodosa1.*, Sum(Round(((hhasta1 - hdesde1) /3600), 2)) As horas;
	from mwktodosa1 ;
	group By codmed, diasem, hdesde1, hhasta1;
	into Cursor mwktodosa2
Else
	Select mwktodosa1.*, Sum(Round(((hhasta1 - hdesde1) /3600), 2)) As horas;
	from mwktodosa1 ;
	group By codmed, fechatur, diasem, hdesde1, hhasta1;
	into Cursor mwktodosa2
Endif
**
If mlista = 1
	Select nombre, fechatur, ;
	iif(diasem = 2, 'Lun', Iif(diasem = 3, 'Mar', ;
	iif(diasem = 4, 'Mie', Iif(diasem = 5, 'Jue', ;
	iif(diasem = 6, 'Vie', Iif(diasem = 7, 'Sab', 'Dom')))))) As dia, ;
	sum(Iif(afiliado <= 1, 1, 0000)) As libre, ;
	sum(Iif(afiliado > 1, 1, 0000)) As ocupa, ;
	sum(Iif(afiliado > 1 And confirmado = 0 And PRE_modoatencion  ='VIRTUAL', 1, 0000)) As faltodist, ;
	sum(Iif(afiliado > 1 And confirmado = 0 And PRE_modoatencion <>'VIRTUAL', 1, 0000)) As falto , ;
	sum(Iif(afiliado > 1 And confirmado = 1 And PRE_modoatencion  ='VIRTUAL', 1, 0000)) As vinodist, ;
	sum(Iif(afiliado > 1 And confirmado = 1 And PRE_modoatencion <>'VIRTUAL', 1, 0000)) As vino, ;
	count(afiliado) As ofrecido, hdesde1, hhasta1, cantidad, ;
	porcentaje,abrevio, pe, estructura,duracion, diasem, horadesde, horahasta, codmed;
	,fecvigend,fecvigenh,codesp ;
	from mwktodosa ;
	group By nombre, diasem, horadesde, horahasta, abrevio ;
	order By nombre, diasem, horadesde, horahasta, abrevio ;
	into Cursor mwklistapre

	Select mwklistapre.*,horas ;
	from mwklistapre Left Join mwktodosa2 ;
	on (mwklistapre.nombre =  mwktodosa2.nombre And ;
	mwklistapre.diasem =  mwktodosa2.diasem And ;
	mwklistapre.hdesde1 =  mwktodosa2.hdesde1 And ;
	mwklistapre.hhasta1 =  mwktodosa2.hhasta1 ) ;
	into Cursor mwklista

Else
	Select mwktodosa.nombre, mwktodosa.fechatur, ;
	iif(mwktodosa.diasem = 2, 'Lun', Iif(mwktodosa.diasem = 3, 'Mar', ;
	iif(mwktodosa.diasem = 4, 'Mie', Iif(mwktodosa.diasem = 5, 'Jue', ;
	iif(mwktodosa.diasem = 6, 'Vie', Iif(mwktodosa.diasem = 7, 'Sab', 'Dom')))))) As dia, ;
	sum(Iif(mwktodosa.afiliado <= 1, 1, 0000)) As libre, ;
	sum(Iif(mwktodosa.afiliado > 1, 1, 0000)) As ocupa, ;
	sum(Iif(afiliado > 1 And confirmado = 0 And PRE_modoatencion  ='VIRTUAL', 1, 0000)) As faltodist, ;
	sum(Iif(afiliado > 1 And confirmado = 0 And PRE_modoatencion <>'VIRTUAL', 1, 0000)) As falto , ;
	sum(Iif(afiliado > 1 And confirmado = 1 And PRE_modoatencion  ='VIRTUAL', 1, 0000)) As vinodist, ;
	sum(Iif(afiliado > 1 And confirmado = 1 And PRE_modoatencion <>'VIRTUAL', 1, 0000)) As vino, ;
	count(mwktodosa.afiliado) As ofrecido, mwktodosa.hdesde1, mwktodosa.hhasta1, mwktodosa.cantidad, ;
	mwktodosa.porcentaje, mwktodosa.abrevio, mwktodosa.pe, mwktodosa.estructura,mwktodosa.duracion,horas ;
	,mwktodosa.fecvigend,mwktodosa.fecvigenh,mwktodosa.codesp ;
	from mwktodosa Left Join mwktodosa2 ;
	on mwktodosa.nombre =  mwktodosa2.nombre And ;
	mwktodosa.diasem =  mwktodosa2.diasem And ;
	mwktodosa.fechatur =  mwktodosa2.fechatur And ;
	mwktodosa.hdesde1 =  mwktodosa2.hdesde1 And ;
	mwktodosa.hhasta1 =  mwktodosa2.hhasta1 ;
	group By mwktodosa.nombre, mwktodosa.fechatur, mwktodosa.horadesde, mwktodosa.horahasta ;
	order By mwktodosa.nombre, mwktodosa.fechatur, mwktodosa.horadesde, mwktodosa.horahasta ;
	into Cursor mwklista
Endif
