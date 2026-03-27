****
** Listado estadistico para Morgulis primero disponible, cantidad ocupados, libres
** Modificado por Claudia el 13/6/03 linea 7, 8 ,10 y 11  de ambos querys
****

Parameter mfecdes, mfechas, mbusco1,mbusco2

Do sp_especialidad

If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif
mret = SQLExec(mcon1,'select FechaCierre,FechaProceso FROM TurnosFechas '+ ;
	' where &mccpoamb id<100000  order by fechacierre ','mwkctrlfecha')
Go Bottom In mwkctrlfecha
mfechalimite = mwkctrlfecha.fechacierre
Use In mwkctrlfecha
mret = SQLExec(mcon1, "select *  from TabTipoturno ","mwktipt")
mret = SQLExec(mcon1, "select fecpasiva,codent as codentexc,tpopac  from entidexclu "+;
	"where tpopac = 'AMB' and tipoturno = 7 ","mwkentex")

mret = SQLExec(mcon1, "select codmed, diasem, fecvigend, fecvigenh, horadesde, horahasta, " + ;
	" abrevio, estructura "+;
	", hhmmDes, hhmmHas " +;
	" from franjahoraria left join tabtipofranja on franjahoraria.tiposervicio = tabtipofranja.id " + ;
	" where &mccpoamb fecvigenh > ?mfecdes and fecvigend <= ?mfechas and fecvigenh <>fecvigend "+ ;
	mbusco1 + ;
	"group by codmed, diasem, horahasta, fecvigenh, tiposervicio " + ;
	" ", "mwkfranjas")
If mret < 0
	=Aerr(eros)
	Messagebox(eros(2), 16, "Validacion")
	Messagebox(eros(3), 16, "Validacion")
Endif

mret = SQLExec(mcon1, " select codmed, diasem, fecvigend,codesp "+;
	", fecvigenh,  hdesde1, hhasta1, horadesde, ESP_descripcion, horahasta "+;
	", hhmmDes, hhmmHas " +;
	" from medpresta, especialid "+;
	" where &mccpoamb diasem > 0 "+ mbusco2 +;
	" and trim(medpresta.codesp) = especialid.ESP_codesp " + ;
	" and fecvigenh > ?mfecdes and fecvigend <= ?mfechas and fecvigenh <>fecvigend "+;
	" group by codmed,codesp , diasem, fecvigend,fecvigenh, hdesde1 ","Mwkmedpre")

If mret < 0
	=Aerr(eros)
	Messagebox(eros(2), 16, "Validacion")
	Messagebox(eros(3), 16, "Validacion")
Endif

mret = SQLExec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, nombre,turnos.codesp, " + ;
	"tipoturno, confirmado, turnos.diasem,hhmmtur,codent,turnos.codesp "+ ;
	"from turnos, prestadores   " + ;
	"where &mccpoamb turnos.codmed =  prestadores.id and " + ;
	"turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas and " + ;
	"(turnos.tipoturno < 8 or turnos.tipoturno >9) "+ mbusco1  + ;
	" " , "mwktodosa")
If mret < 0
	=Aerr(eros)
	Messagebox(eros(2), 16, "Validacion")
	Messagebox(eros(3), 16, "Validacion")
Endif
If mfecdes <= mfechalimite
	mret = SQLExec(mcon1, "select turnos.id,afiliado, fechatur, horatur, codmed, nombre,turnos.codesp, " + ;
		"tipoturno, confirmado, turnos.diasem,hhmmtur,codent,turnos.codesp  " + ;
		"from turnoshis as turnos, prestadores  " + ;
		"where &mccpoamb turnos.codmed =  prestadores.id and " + ;
		"turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas and " + ;
		"(turnos.tipoturno < 8 or turnos.tipoturno >9) " + mbusco1  + ;
		" " , "mwktodosb")


	If mret < 0
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE", 16, "Validacion")
		Cancel
	Endif

	If Reccount ('mwktodosa')>0
		Select *,Iif(afiliado >1,afiliado, Id) As afi  From mwktodosa ;
			union All ;
			select *,Iif(afiliado > 1,afiliado, Id) As afi  From mwktodosb ;
			into Cursor mwktodos
	Else
		Select *,Iif(afiliado > 1,afiliado, Id) As afi  From mwktodosb ;
			into Cursor mwktodos
	Endif
Else
	Select *,Iif(afiliado > 1,afiliado, Id) As afi  From mwktodosa ;
		into Cursor mwktodos
Endif
Select mwktodos.*,abrevio As abre, Mwkmedpre.codesp, fecpasiva ;
	from mwktodos ;
	left Join Mwkmedpre On (mwktodos.fechatur >= Mwkmedpre.fecvigend And ;
	mwktodos.fechatur <  Mwkmedpre.fecvigenh And ;
	hhmmtur >= Mwkmedpre.hhmmdes And hhmmtur<Mwkmedpre.hhmmhas And ;
	mwktodos.codmed = Mwkmedpre.codmed And ;
	mwktodos.diasem = Mwkmedpre.diasem );
	left Join mwkfranjas On (mwktodos.fechatur >= mwkfranjas.fecvigend And ;
	mwktodos.fechatur <  mwkfranjas.fecvigenh And ;
	hhmmtur >= mwkfranjas.hhmmdes And hhmmtur<mwkfranjas.hhmmhas And ;
	mwktodos.codmed = mwkfranjas.codmed And ;
	mwktodos.diasem = mwkfranjas.diasem );
	left Join mwkentex On codent = codentexc;
	into Cursor mwktodosg
*	mwktodos.codesp = Mwkmedpre.codesp and
If At("codesp",mbusco2)>0
	Select *,Nvl(abre,"S/D") As abrevio From mwktodosg ;
		where codesp1 = mcodesp	And afiliado>1;
		group By Id,afi,codmed, codesp1, fechatur, horatur, tipoturno ;
		union All ;
		select *,Nvl(abre,"S/D") As abrevio From mwktodosg ;
		where codesp_b = mcodesp And afiliado<=1	;
		group By Id,afi,codmed, codesp_b, fechatur, horatur, tipoturno ;
		into Cursor mwktodoss
Else
	Select *,Nvl(abre,"S/D") As abrevio From mwktodosg ;
		group By Id,afi,codmed, codesp_b, fechatur, horatur, tipoturno ;
		into Cursor mwktodoss
Endif
Select *,Iif(Empty(codesp_a),codesp_b,codesp_a) As codesp  From mwktodoss Group By Id Into Cursor mwktodos

