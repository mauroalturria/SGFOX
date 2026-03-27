****
** busco prestaciones de un vale
****
lparameters mcodpun
mret = sqlexec(mcon1, "SELECT pia_codprest , pia_cantsolicitada  FROM presinsuvas " + ;
			" where pia_valesasist = ?mcodpun ", "mwkpresin")
if mret < 0
	=aerr(eros)
	messagebox(eros(3)) 
endif	
