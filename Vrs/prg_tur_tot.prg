public mcon1
do sp_conexion
cf1 = prg_dtoc(ctod("01/01/2004")) 
cf2 = prg_dtoc(ctod("01/12/2004"))

mret = sqlexec(mcon1,'select { fn MONTH ( turnos . fechatomado ) } as mes , upper ( turnos . usuario ) as usuario , count ( fechatomado ) as total '+;
		'from turnos , tabusuario  '+;
		'left join tabsectorusuario on tabusuario . id = tabsectorusuario . codusuario  '+;
		'left join tabsectores on tabsectorusuario . codsector = tabsectores . id  '+;
		'where upper ( turnos . usuario ) = tabusuario . idusuario  '+;
		'and preferido = 1  '+;
		'and turnos . fechatomado >= ?cf1  '+;
		'and turnos . fechatomado < ?cf2  '+;
		'AND tabsectores . id = 1  '+;
		'group by upper ( usuario ) , { fn MONTH ( turnos . fechatomado ) }' , 'mwktomadosa')
