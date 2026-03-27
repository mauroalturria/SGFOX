*
* Medicamentos Citostáticos, actualización de stk
*
lparameters mrestos,mutiliz,mreutiz,mvalida	

mret = sqlexec(mcon1, "update TabFarmCitosI" + ;
	" set TCI_resto = ?mrestos, TCI_utilizado = ?mutiliz, TCI_reutilizados = ?mreutiz"+;
	" where Id = ?mvalida" )

if mret < 0
	messagebox("EN LA ACTUALIZACION DE STOCK"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
endif
