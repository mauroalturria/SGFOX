****
** Busco todas las camas del paciente
****

parameter mcodadm, msql_hab


mret = sqlexec(mcon1, "select *, {fn hour(lug_horaingreso)}  as horaingreso from lugarintern " + ;
	"where lug_pacientes = ?mcodadm " + ;
	"order by lug_fechaingreso", "mwkcamas")
mret = sqlexec(mcon1, "select * from tabverC" + ;
	" where codadmision = ?mcodadm and prg = 20 " + ;
	"", "mwkverc")
select usuario, habcama, ttod(fecha ) as fechacbio, hour(fecha ) as horacbio, ;
	left(habcama,len(alltrim(habcama))-2)+"   " as Hab,right(alltrim(habcama),2) as cama ;
	from mwkverc into cursor mwkvercama
select * from mwkcamas left join mwkvercama on (fechacbio = Lug_fechaingreso and ;
	hab = lug_habitacion and val(cama) = val(lug_cama) and ;
	between (horaingreso ,horacbio-1,horacbio+1 ) );
	into cursor mwkcamas
msql_hab = "select lug_fechaingreso, left(ttoc(lug_horaingreso, 2), 5) as hora, "+;
	"lug_categoria, lug_codsector, lug_habitacion, lug_cama,nvl(usuario,space(20)) as usuario  "+;
	" from mwkcamas into cursor mwkcamas1"

