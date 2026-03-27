*
* Busqueda de Etiquetas Citostáticos Emitidas
*
Lparameters mdesde

mret=sqlexec(mcon1,"select TCE_fechaemite, TCE_partida, TCP_registracio,TCE_nropof "+;
	"from TabFarmCitosE left join TabFarmCitosP on TCE_partida=TCP_partida "+;
	"where TCE_fechaemite >= ?mdesde "+;
	"and TCE_fechapasiva is null"+;
	" group by TCE_nropof order by TCE_fechaemite","mwketiq")
	
*	" group by TCE_partida order by TCE_fechaemite","mwketiq")

If mret<0
	=aerror(merror)
	Messagebox("ERROR EN BUSQUEDA DE ETIQUETAS EMITIDAS"+chr(10)+merror(3),0,"Validacion")
	Return
Endif
