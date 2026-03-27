*
* Busqueda de Observaciones CIAM x ID - Nropedido
*

Parameters mbusca

If used('mwkciamobs')
	Use in mwkciamobs
Endif

mret = sqlexec(mcon1,"select TCD_pacobs,TCD_observ,TCD_gesobs,TCD_gesobst"+;
	" from Tabciamderiva where id = ?mbusca","mwkciamobs")

If mret < 0
	Messagebox("EN CONSULTA DE OBSERVACIONES DE LA DERIVACION",16,"ERROR")
Endif
