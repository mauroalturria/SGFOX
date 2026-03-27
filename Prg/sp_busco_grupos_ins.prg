****
** busco grupos
****

mret = sqlexec(mcon1, "select stg_grupo , stg_grudesc from stockgral " +;
	" ", "mwkgrupos")

if mret < 0
	messagebox('NO ENCONTRO GRUPOS. REINTENTE LUEGO', 16, 'Validacion')
	mret = 0
endif
mret = sqlexec(mcon1, "select descripcion , grupo  from STGRUATC " , "mwkgrupoAtc")
if mret < 0
*!*		messagebox('NO ENCONTRO GRUPOS. REINTENTE LUEGO', 16, 'Validacion')
*!*		mret = 0
endif
