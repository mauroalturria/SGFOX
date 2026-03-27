***
*** Generacion de planilla de Turnos mal
***


mfechad=ctod("24/10/2005")
mret = sqlexec(mcon1, 'select turnos.*,nombre,prestadores.codesp ' + ;
	'from turnos , prestadores '+;
	'where turnos.codmed = prestadores.id and ' + ;
	'turnos.tipoturno < 9 and ' + ;
	'turnos.fechatur = ?mfechad and ' + ;
	'turnos.diasem = 2 ' + ;
	'', 'mwkphorario1')
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
endif
select codmed,horatur,padl(codmed,4,"0")+ttoc(horatur) as clave,count(afiliado);
	from 	mwkphorario1 ;
	group by codmed,fechatur, horatur having count(afiliado)>3  ;
	into cursor maslo
select mwkphorario1.*,mwkMedicosall1.nombre as medsol  from mwkphorario1 ;
	left join mwkMedicosall1 on mwkMedicosall1.id = codmed ;
	where alltrim(codesp1)<> "KINE" and padl(codmed,4,"0")+ttoc(horatur) in (select clave from maslo) ;
	into cursor cd2

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
