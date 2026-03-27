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

mret = SQLExec(mcon1, " select codmed, diasem, fecvigend,codesp,codprest,sala,codserv "+;
	", fecvigenh, Prestacions.PRE_descriprest,hhmmDes, hhmmHas " +;
	" from medpresta  "+;
	" INNER JOIN  Prestacions ON  Medpresta.codprest = Prestacions.PRE_codprest "+;
	" where &mccpoamb diasem > 0 "+ mbusco2 +;
	"  and GeneraAgen = 1  " + ;
	" and fecvigenh > ?mfecdes and fecvigend <= ?mfechas and fecvigenh <>fecvigend "+;
	"  ","Mwkmedpre")
If mret < 0
	=Aerr(eros)
	Messagebox(eros(3), 16, "Validacion")
Endif

mret = SQLExec(mcon1, "select turnos.id,tabtipoturno.abreviatura, fechatur, horatur, codmed, nombre , " + ;
	"turnos.tipoturno,  turnos.diasem,hhmmtur "+ ;
	"from turnos, prestadores,tabtipoturno " + ;
	"where &mccpoamb turnos.codmed =  prestadores.id and " + ;
	"turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas and " + ;
	"  turnos.tipoturno <>9 and afiliado = 0 and turnos.tipoturno=tabtipoturno.tipoturno "+ mbusco1  + ;
	" " , "mwktodosa")
If mret < 0
	=Aerr(eros)
	Messagebox(eros(3), 16, "Validacion")
Endif
If mfecdes <= mfechalimite
	mret = SQLExec(mcon1, "select turnos.id,tabtipoturno.abreviatura, fechatur, horatur, codmed, nombre, " + ;
		"turnos.tipoturno,  turnos.diasem,hhmmtur "+ ;
		"from  turnoshis as turnos, prestadores,tabtipoturno " + ;
		"where &mccpoamb turnos.codmed =  prestadores.id and " + ;
		"turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas and " + ;
		"  turnos.tipoturno <>9 and afiliado = 0 and turnos.tipoturno=tabtipoturno.tipoturno "+ mbusco1  + ;
		" " , "mwktodosb")


	If mret < 0
		Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE", 16, "Validacion")
		Cancel
	Endif

	If Reccount ('mwktodosa')>0
		Select *  From mwktodosa ;
			union All ;
			select *   From mwktodosb ;
			into Cursor mwktodos
	Else
		Select *  From mwktodosb ;
			into Cursor mwktodos
	Endif
Else
	Select *   From mwktodosa ;
		into Cursor mwktodos
Endif
Select mwktodos.*, Mwkmedpre.codesp,PRE_descriprest, Mwkmedpre.codserv,Mwkmedpre.sala ;
	from mwktodos ;
	left Join Mwkmedpre On (mwktodos.fechatur >= Mwkmedpre.fecvigend And ;
	mwktodos.fechatur <  Mwkmedpre.fecvigenh And ;
	hhmmtur >= Mwkmedpre.hhmmdes And hhmmtur<Mwkmedpre.hhmmhas And ;
	mwktodos.codmed = Mwkmedpre.codmed And ;
	mwktodos.diasem = Mwkmedpre.diasem );
	into Cursor mwktodosg


Select *,Iif(At("DISTANCIA",PRE_descriprest )>0,1,2) As presvirt,IIF(AT("LIMA",sala)>0,"LIMA","    ") as centro From mwktodosg ;
	WHERE !ISNULL(codserv);
	group By  Id,presvirt  ;
	into Cursor mwktodoss

Select *,Count(Id) As cuantos  From mwktodoss Group By codmed, fechatur, horatur, tipoturno,presvirt  ;
	Into Cursor mwktodosv
Select *, Sum(presvirt) As ambos From mwktodosv Group By codmed, fechatur, horatur, tipoturno;
	Into Cursor mwktodosp
Select id,abreviatura , fechatur, horatur, codmed, nombre, tipoturno, prg_diasem(diasem,2) As dia,hhmmtur,diasem, ;
	codesp,PRE_descriprest ,cuantos as t_multiples,Iif(ambos=1,"DISTANCIA ",Iif(ambos=2,"PRESENCIAL","AMBOS     ")) As TIPO;
	,IIF(codserv =2200,"CONS","PRAC") as tipocons,centro ;
	From mwktodosp ;
	Into Cursor mwktodos
