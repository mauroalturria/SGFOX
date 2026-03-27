****
****

mfecdes = ctod("01/09/2005")

mfechas = ctod("30/09/2005")
mbusco1  = " and codmed = 3 "

mret = sqlexec(mcon3, "select afiliado, fechatur, horatur, codmed, codent, " + ;
	"tipoturno, confirmado, diasem,hhmmtur,nrovale as vale " + ;
	', VAL_medicosolicit, VAL_NroProtocolo, VAL_circuitoorigen, VAL_prestador  '+;
	', REG_nrohclinica, REG_numdocumento,REG_nombrepac,ent_descrient '+;
	"from turnos " + ;
	" left join registracio on afiliado = registracio " + ;
	" left join entidades on codent = ent_codent " + ;
	"left join valesasist on valesasist = turnos . nrovale "+;
	"where turnos.fechatur >= ?mfecdes and turnos.fechatur <= ?mfechas " + ;
	" and tipoturno < 9 and confirmado=1 and afiliado>0 " + mbusco1 , "mwktodosc1")

mret = sqlexec(mcon3, "select afiliado, fechatur, horatur, codmed, codent, " + ;
	"tipoturno, confirmado, diasem,hhmmtur,nrovale as vale " + ;
	', VAL_medicosolicit, VAL_NroProtocolo, VAL_circuitoorigen, VAL_prestador  '+;
	', REG_nrohclinica, REG_numdocumento,REG_nombrepac,ent_descrient '+;
	"from turnoshis " + ;
	" left join registracio on afiliado = registracio " + ;
	" left join entidades on codent = ent_codent " + ;
	"left join valesasist on valesasist = turnoshis . nrovale "+;
	"where fechatur >= ?mfecdes and fechatur <= ?mfechas " + ;
	" and tipoturno < 9 and confirmado=1 and afiliado>0 " + mbusco1 , "mwktodosc2")
select * from mwktodosc1 union select * from mwktodosc2 into cursor mwktodosc

if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	set step on	
endif
mret = sqlexec(mcon3, "select fechacte,importe,letracte," + ;
	" nrocte,nroregistracio,nrovale,ptovta,tpocte,tpopac,usuario " + ;
	" from tabfacturas " + ;
	"where fechacte >= ?mfecdes and fechacte<= ?mfechas and ptovta=1 and importe>20 " , "mwkfact")
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	
endif
*select * from mwktodosc left join mwkfact on afiliado = nroregistracio into cursor facturasafi
select fechatur, codmed, codent,ent_descrient, tipoturno, hhmmtur,vale;
		, VAL_circuitoorigen, REG_nrohclinica, REG_numdocumento,REG_nombrepac;
	,iif(isnull(tpocte),"  ",iif(tpocte=1,"FC","NC")) as tc,letracte,nrocte,importe;
	from mwktodosc left join mwkfact on vale = nrovale ;
	where vale>0 into cursor facturasvale

