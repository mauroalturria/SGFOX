***
*** Generacion de planilla de Reprogramaciones
***
parameter mfecdes,mfecrep
mfecr = prg_dtoc(mfecrep)
if mxambito >1
	mccpoamb = "  turnos.codambito = ?mxambito and "
	mccpoambm = " medpresta.codambito = ?mxambito and "
	mccpoambf = " turnos.codambito = ?mxambito and "
	mcjoin = 	" medpresta.codambito = turnos.codambito and "
else
	mccpoamb = ''
	mccpoambm = ''	
	mcjoin = ''
	mccpoambf = ''	
endif

mret = sqlexec(mcon1, "select fechatur, observa ,fechaobserva,ENT_descrient,  " + ;
	" nombre, REG_telefonos, REG_nrohclinica,codreserva, REG_numdocumento, " + ;
	" REG_nombrepac, REG_nroregistrac " + ;
	" from turnos ,registracio, medpresta,entidades,prestadores  " + ;
	" where &mccpoamb &mccpoambf &mccpoambm turnos.codmed = prestadores.id and " + ;
	" turnos.afiliado = REG_nroregistrac and " + ;
	" turnos.codmed = medpresta.codmed and " + ;
	" turnos.codprest = medpresta.codprest and " + ;
	" turnos.codent = entidades.ENT_codent and " + ;
	" turnos.fechatur >= medpresta.fecvigend and " + ;
	" turnos.fechatur < medpresta.fecvigenh and " +mcjoin + ;
	' medpresta.diasem = turnos.diasem and turnos.fechaobserva>= ?mfecr  and ' + ;
	' hhmmtur >= medpresta.hhmmdes and hhmmtur<medpresta.hhmmhas and ' + ;
	" turnos.fechatur >= ?mfecdes  and observa like 'REPR.%' " + ;
	" group by turnos.codmed, turnos.fechatur, afiliado, turnos.codreserva " + ;
	"", "mwkturnorepro1")

if mret < 0
	=aerr(eros)
	messagebox(eros(2))
	messagebox(eros(3))
endif
mret = sqlexec(mcon1, "select fechatur, observa ,ENT_descrient,  " + ;
	" nombre, REG_telefonos, REG_nrohclinica, codreserva,REG_numdocumento, " + ;
	" REG_nombrepac,feccancela, REG_nroregistrac "  + ;
	" from turnoscancel as turnos , prestadores, registracio, medpresta,entidades " + ;
	" where &mccpoamb &mccpoambf &mccpoambm turnos.codmed = prestadores.id and " + ;
	" turnos.afiliado = REG_nroregistrac and " + ;
	" turnos.codmed = medpresta.codmed and " + ;
	" turnos.codprest = medpresta.codprest and " + ;
	" turnos.codent = entidades.ENT_codent and " + ;
	" turnos.fechatur >= medpresta.fecvigend and " + ;
	" turnos.fechatur < medpresta.fecvigenh and " +mcjoin + ;
	' medpresta.diasem = turnos.diasem and turnos.feccancela >= ?mfecr  and ' + ;
	' hhmmtur >= medpresta.hhmmdes and hhmmtur<medpresta.hhmmhas and ' + ;
	" turnos.fechatur = ?mfecdes  and observa like 'CANC.MASIVA%' " + ;
	" group by turnos.codmed, turnos.fechatur, afiliado, turnos.codreserva " + ;
	"", "mwkturnorepro2")

if mret < 0
	=aerr(eros)
	messagebox(eros(2))
	messagebox(eros(3))
endif


select fechaobserva as fecharep;
	,'RP' as ctipo,fechatur, reg_nrohclinica, ;
	reg_numdocumento,reg_nombrepac ,nombre, REG_telefonos,codreserva,left(observa,100) as observa,REG_nroregistrac;
	from mwkturnorepro1 ;
	where substr(observa,6,5) = left(dtoc(mfecdes),5) ;
	and at("->",observa)>0;
	order by fecharep  into cursor mwkturnorepr11a

select feccancela as fecharep,'CM' as ctipo,fechatur, reg_nrohclinica, ;
	reg_numdocumento,reg_nombrepac,nombre, REG_telefonos,codreserva,left(observa,100) as observa,REG_nroregistrac;
	from mwkturnorepro2 ;
	order by fecharep  into cursor mwkturnorepr22

*!*	select * from mwkturnorepr11n ;
*!*		union all
select * from mwkturnorepr11a ;
	union all ;
	select * from mwkturnorepr22  ;
	into cursor mwkturnorepr

if used ('mwkturnorepro1')
	use in mwkturnorepro1
endif
if used ('mwkturnorepr22')
	use in mwkturnorepr22
endif
if used ('mwkturnorepr11')
	use in mwkturnorepr11
endif
