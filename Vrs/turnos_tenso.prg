****
** listado de ausentismo de foniatria
****

do sp_conexion
 mfechades= ctod("01/04/2008")
 mfechacorte = ctod("01/07/2008")   &&&ctod("01/02/2007")
mret = sqlexec(mcon1, "select fechatur, horatur, confirmado,tipoturno,turnos.codprest, " + ;
		" afiliado,turnos.codmed,CODENT,fechatomado,fechaconfirma,medpresta.codprest,hhmmtur " + ;
		" from turnos, medpresta " + ;
		" where medpresta.codmed = turnos.codmed  and fechatur >=?mfechades  and " + ;
		" fechatur <= ?mfechacorte  and " +;
		" fechatur >= fecVigenD and medpresta.diasem = turnos.diasem and " +;
		" fechatur <= fecVigenH and Medpresta.codprest IN (30010900,30010901) and " + ;
		" hhmmtur< hhmmhas and hhmmtur>= hhmmdes  " + ;
		" ", "mwktodos1")

if mret<0
	=aerr(eros)
	messagebox(eros(3))
	set step on
endif
do sp_desconexion



select count(*) as turnos_fut,afiliado,reg_nombrepac ,reg_nrohclinica from futuro group by afiliado into cursor cuantoshay
select count(*) as turnos_pres,afiliado,reg_nrohclinica from anteriores group by afiliado into cursor cuantoshubo
select * from cuantoshay left join cuantoshubo ;
on cuantoshubo.afiliado = cuantoshay .afiliado ;
into cursor turnos_foni

 