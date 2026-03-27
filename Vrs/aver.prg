mret = sqlexec(mcon1,"SELECT ID,afiliado,codigo,fechatomado,observa,turnoid,usuario "+;
			" FROM SQLUser.TurnosAudit" +;
			' where fechatomado>="2005-10-19 00:00:00" and fechatomado<"2005-10-20 00:00:00" '+;
			" order by fechatomado" , "qtomo")
if mret<1
		=aerr(eros)
		messagebox(eros(3))
endif
select *,hour(fechatomado) as hora, int(minute(fechatomado)/10) as nutito from qtomo into cursor cursi			

select hora,nutito*10 as minutos,count(hora) as cuantos from cursi group by hora,nutito into cursor rankingh
select hora,nutito*10 as minutos,count(hora) as cuantos from cursi group by hora,nutito into cursor rankingm		
select hora,usuario,count(hora) as cuantos from cursi order by hora,cuantos desc group by hora,usuario into cursor rankinguh			
browse