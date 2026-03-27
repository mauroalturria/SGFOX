select * from turnoid,franjape ;
where turnoid.codmed=franjape.codmed and ;
turnoid.diasem =franjape.diasem and ;
turnoid.fechatur >= franjape.fecvigend and ;
turnoid.fechatur <  franjape.fecvigenh and ;
hhmmtur >= franjape.hhmmdes and hhmmtur<franjape.hhmmhas ;
into cursor turnoiddados

select * from tabsobretoa,medpresta ;
where tabsobretoa.codmed=medpresta.codmed and ;
tabsobretoa.diasem =medpresta.diasem and ;
tabsobretoa.fvigend >= medpresta.fecvigend and ;
tabsobretoa.fvigenh <=  medpresta.fecvigenh and ;
tabsobretoa.hhmmdes >= medpresta.hhmmdes and tabsobretoa.hhmmhas<=medpresta.hhmmhas ;
into cursor turnoiddados


select * from medpresta where str(codmed,4)+str(diasem,1)+dtoc(fecvigenh);
+str(hhmmdes,4) not in ( select str(codmed_b,4)+str(diasem_b,1)+dtoc(fecvigenh);
+str(hhmmdes,4) from turnoiddados) into cursor faltas

select faltas.*,nombre from faltas,prestadores ;
where codmed = prestadores.id into cursor noturno

select * from turnoid,medpresta ;
where afiliado<2 and turnoid.codmed=medpresta.codmed and ;
turnoid.diasem =medpresta.diasem and ;
turnoid.fechatur >= medpresta.fecvigend and ;
turnoid.fechatur <  medpresta.fecvigenh and ;
hhmmtur >= medpresta.hhmmdes and hhmmtur<medpresta.hhmmhas ;
into cursor turnoidlibres

select * from turnoidlibres,noturno;
where turnoidlibres.codmed_a=noturno.codmed and ;
turnoidlibres.diasem_a =noturno.diasem and ;
turnoidlibres.fechatur >= noturno.fecvigend and ;
turnoidlibres.fechatur <  noturno.fecvigenh and ;
hhmmtur >= noturno.hhmmdes and hhmmtur<noturno.hhmmhas ;
group by codmed,diasem,noturno.hhmmdes,fechatur;
into cursor prestasin
