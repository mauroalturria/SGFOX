select * from tabctrsrv where at("FRMTUR",tcs_program)>0 group by tcs_ipaddress into cursor turnos
BROWSE LAST
select * from tabctrsrversion where at("TURNO",tcs_device)>0 group by tcs_ipaddress into cursor turnosver
BROWSE LAST
select * from turnos where tcs_ipaddress not in (select tcs_ipaddress from turnosver)
