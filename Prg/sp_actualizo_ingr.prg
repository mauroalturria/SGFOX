****
** actualizo ingredientes no compatibles con dietas
****

parameter  mabm, mdesc, magrup, mtipo, mid

if mabm=1
	mret = sqlexec(mcon1, "insert into TabNutIngr (TN_Ingrediente, TN_CodAgr,TN_Tipo ) "+;
	" values( ?mdesc, ?magrup, ?mtipo )")
else
	mret = sqlexec(mcon1, "update TabNutIngr set TN_Ingrediente=?mdesc "+;
		",TN_CodAgr = ?magrup,TN_Tipo= ?mtipo  where id= ?mid ")
endif


if mret < 0
	=aerr(eros)
	messagebox('NO SE ACTUALIZO.  REINTENTE', 16, 'Validacion')
	Messagebox(eros(3))
	mret = 0
endif