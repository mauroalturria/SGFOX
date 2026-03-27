****
** Busco prestaciones
****
if !used('mwkprestpres')
	do sp_busco_prestapres
endif 
mret = sqlexec(mcon1, "SELECT * FROM TabPrPrest " , "mwkprpr1")
if mret < 0
	=aerr(eros)
	messagebox(eros(3))
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
else
	select mwkprpr1.*,pre_descriprest as descripcion from mwkprpr1 ;
		left join mwkprestpres on mwkprpr1.CodPrest= pre_codprest;
		order by descripcion into cursor mwkprprest
*!*		if used('mwkprprest')
*!*			use in mwkprprest
*!*		endif
*!*		use dbf('mwkprpr') in 0 again alias mwkprprest
endif