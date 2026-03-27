***
*** Generacion de planilla de Turnos mal
***


mfechad=ctod("07/11/2005")
mret = sqlexec(mcon1, 'select turnos.*,nombre ' + ;
	'from turnos , prestadores, prestacions '+;
	'where turnos.codmed = prestadores.id and ' + ;
	'turnos.codprest = prestacions.pre_codprest and '  + ;
	'turnos.tipoturno < 9 and ' + ;
	'turnos.fechatur = ?mfechad and ' + ;
	'turnos.diasem = 2 ' + ;
	' and pre_turnosmultip= 1 ' + ;
	'', 'mwkphorario1')
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
endif
select horatur,fechatomado,nombre,codreserva,tipoturno  from 	mwkphorario1 ;
	group by codmed,fechatur, horatur having count(afiliado)>1 into cursor maslo
browse
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
endif
select codreserva,mwkphorario1.codmed,mwkphorario1.nombre,pre_descriprest,horatur,observa,hhmmHas from mwkphorario1 ;
	left join mwkmedpres on ;
	(mwkphorario1.codmed   = mwkmedpres.codmed and ;
	mwkphorario1.codprest = mwkmedpres.codprest and ;
	mwkphorario1.diasem	 = mwkmedpres.diasem and ;
	mwkphorario1.fechatur >= mwkmedpres.fecvigend and ;
	mwkphorario1.fechatur <  mwkmedpres.fecvigenh and ;
	mwkphorario1.hhmmTur >= mwkmedpres.hhmmDes and  ;
	mwkphorario1.hhmmTur < mwkmedpres.hhmmHas ) into cursor mal1

select * from mal1 where isnull(hhmmHas) into cursor malmal1
browse last
