*********************************************************************************
* BUSCA PACIENTES                                            *
*********************************************************************************
do sp_conexion
	mret = sqlexec(mcon1,"select  REG_nrohclinica , REG_nombrepac , REG_domicilio , REG_numdocumento " + ;
		"FROM registracio "+ ;
		" where REG_nroregistrac >=  3139752 " , "altas")

select altas
scan
	ndoc = REG_numdocumento
	mret = sqlexec(mcon1,"select  REG_nrohclinica , REG_nombrepac , REG_domicilio , REG_numdocumento " + ;
		"FROM registracio "+ ;
		" where REG_numdocumento =  ?ndoc " ,"mwkbuspacie")
	if reccount( "mwkbuspacie")>1
		if used('malitos')
			select malitos
			append from dbf("mwkbuspacie")
		else
			select * from mwkbuspacie into cursor malos 
			use dbf('malos') in 0 again alias malitos
		endif	
	endif
endscan
do sp_desconexion