*
* Localiza ultimo reclamo cargado para una printer
*
Lparameters mlmaquina, mconsulta

if vartype(mconsulta) # "C"
  mconsulta = 'N'
endif  

If used('mwkultfec')
	Use in mwkultfec
Endif

mret = sqlexec(mcon1,"select "+iif(mconsulta="N"," top 1 ","")+" TSP_copias,TSP_fechamov"+;
	" from TabStPrinter "+;
	" where TSP_IdPuesto = ?mlmaquina"+;
	" order by TSP_fechamov desc ","mwkultfec")

If mret < 0
	Messagebox("EN CONSULTA DE FECHAS DE RECLAMOS DE IMPRESORAS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
