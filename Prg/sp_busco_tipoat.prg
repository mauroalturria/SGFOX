****
** Busco tipo de Atencion para coseguro
****

mret = sqlexec(mcon1, "SELECT ID,Descripcion,TipoAten "+;
		"FROM CosegurosTipoAtencion", "mwkcosetipoa")

if !used("mwkentcose")
	mret = sqlexec(mcon1, "select entidad from coseguros  " + ;
		" group by entidad " , "mwkentcose")
endif
if mret<0
	=aerr(eros)
	messagebox(eros(3))
endif
