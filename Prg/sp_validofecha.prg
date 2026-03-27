*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
parameters mf1
	mdmasx={  /  /    }
	do while mdmasx <> mf1
	mdmasx = mf1
	do sp_busco_feriado.prg
	if !eof('Mwkferiados') or dow(mf1)=1
		mf1 = mf1 + 1
	endif
enddo
return mf1