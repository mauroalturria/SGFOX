do sp_conexion
select tabintobsenf 
scan
	if at("hermosa",	eim_indicacion)>0
		mid = id
		mindicacion = strtran(eim_indicacion,"Esta es una hermosa obswervacion",'')
		mret =sqlexec(mcon1, "update Tabintevolmed set EIM_indicacion = ?mindicacion "+;
					" where id=?mid" )
	endif
endscan
do sp_desconexion