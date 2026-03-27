****
*** busca las altas y bajas  del profesional
****
lparameters mid

mret = SQLExec(mcon1,' SELECT bloquedesde, bloquehasta,fecalta, fecaltag,'+;
	' fecaltai, fecaltap, fechamod,fechamodant, fecpasiva, fecpasivag,'+;
	' fecpasivai, usuario FROM Tabmedlog ' + ;
	'where codmed = ?mid order by fechamod ' , 'mwkprofper' )

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
endif
