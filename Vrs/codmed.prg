select distinct idcodmed,nomape from autoriz into cursor medac
BROWSE LAST
select distinct idcodmed,nomape from autoriz order by nomape into cursor medac
BROWSE LAST
select distinct idcodmed,nomape from autoriz order by idcodmed into cursor medac
copy to nobaja type xls
USE
SELECT 1
USE

select left(diagnostico,at("-",diagnostico)-1) as ip, dtoc(tabguardia.fechamod) as dia,tabguardia.* ;
	from tabguardia where codmedcie9>1 and hour(tabguardia.fechamod)>8 and hour(tabguardia.fechamod)<20 order by codmedcie9,dia,fechamod into cursor control
	
BROWSE LAST
select control.*,nombre from control,prestadores where prestadores.id = codmedcie9 ;
	group by ip,dia,codmedcie9 into cursor consultorios
BROWSE LAST
select count(control.id) as cuantos,* from consultorios ;
	group by dia,codmedcie9 having count(control.id)>1 into cursor doscons
BROWSE LAST
