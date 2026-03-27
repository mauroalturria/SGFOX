do sp_conexion
select len(nvl(ea_evolucion,'')) as cara,* from tabambula where len(nvl(ea_evolucion,''))>1000 order by cara into cursor arreglar
 
select arreglar
scan
mid = id
mipos = at("/2017",ea_evolucion,2)
if mipos>8
	miprot = left(ea_evolucion,mipos)
	if messagebox(miprot,4)=6
		miprot = left(ea_evolucion,mipos-7)
		mret = SQLExec(mcon1, "update TabambEvol set EA_evolucion = ?miprot  where id = ?mid ")
	endif 
endif
endscan
do sp_desconexion