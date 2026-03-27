****
** Busco todas las camas del paciente
****

parameter mcodadm, mihora,misec


mret = sqlexec(mcon1, "select *, {fn hour(lug_horaingreso)}  as horaingreso from lugarintern " + ;
	"where lug_pacientes = ?mcodadm " + ;
	"order by lug_fechaingreso,lug_horaingreso", "mwkcamas")
select mwkcamas	

do while !eof()
	if mihora>= ctot(dtoc(lug_fechaingreso) + " " + ttoc(lug_horaingreso,2))
		misec = lug_codsector
		skip
	else 
		exit
	endif
enddo
return (misec)