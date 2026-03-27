****
*** busca las especialidades  del profesional
****
lparameters mid

Do Case 
	Case mid > 0
		mret = SQLExec(mcon1,' SELECT ID , CodAmbito, CodArea, CodProf , CodiEsp, CodiEsp->esp_descripcion '+;
			' , CodCargo, CodCargo->descrip,CodAmbito->ambito, CodArea->area FROM TabProfEsp ' + ;
			' where CodProf = ?mid ' + ;
			'Group By CodAmbito, CodArea, CodCargo, CodProf, codiEsp ' + ;
			'' , 'mwkprofesp' )


	Case mid = 0
		mret = SQLExec(mcon1,' SELECT ID , CodAmbito, CodArea, CodProf , CodiEsp, CodiEsp->esp_descripcion '+;
			' , CodCargo, CodCargo->descrip,CodAmbito->ambito, CodArea->area FROM TabProfEsp '  , 'mwkprofesp' )

	Case mid < 0 && SOLO ESTRUCTURA
		mret = SQLExec(mcon1,' SELECT ID , CodAmbito, CodArea, CodProf , CodiEsp, CodiEsp->esp_descripcion '+;
			' , CodCargo, CodCargo->descrip,CodAmbito->ambito, CodArea->area FROM TabProfEsp WHERE 1=2'  , 'mwkprofesp' )
		
Endcase 
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
endif
