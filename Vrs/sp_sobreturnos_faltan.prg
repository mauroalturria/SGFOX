*****************************
* Genera Sobre Turnos
* AUTOR:Claudia Antoniow
*****************************
* FECHA:13/02/2002
*****************************

	mdmasx		= ctod('18/03/2003')
	mndiasem	= dow(mdmasX)
	mncanttur	= 1 
	
	mret=sqlexec(mcon1,"SELECT codmed, diasem, horadesde, horahasta, porcentaje, cantidad " + ;
						"FROM tabsobretoA " + ;
     					"WHERE Diasem = ?mndiasem AND porcentaje = 0 and tipoturno = 2 " + ;
     					"AND ?mdmasx between fvigend and fvigenh " + ;
     					"AND Codmed IN (SELECT codmed from turnos " + ;
        						"Where fechatur = ?mdmasX And tipoturno in(0,4,5) " + ;
        						"Group By codmed) " +;
     					"GROUP BY Codmed, diasem, Horadesde, porcentaje " +;
						"ORDER BY Codmed, diasem, Horadesde, porcentaje ", "MWKSobre")
 
 
	sele MWKSobre
	go top
	do while !eof('MWKsobre') 
		
		mncodmed  	= MWKsobre.codmed
		mnporc    	= MWKSobre.cantidad
		mtfechatur	= mdmasX
		thora     	= ttoc(MWKSobre.Horadesde,2)
		thorad      = MWKSobre.Horadesde
		thorah    	= MWKSobre.Horahasta
		
		if mnporc > 0 
		
			mret = sqlexec(mcon1,"SELECT * FROM Turnos WHERE Tipoturno = 2 and " +  ;
					"codmed = ?mncodmed and  fechatur = ?mtfechatur " ,"MWKExisteTurno")

			if eof('MWKExisteTurno') or bof('MWKExisteTurno')
			
				mnporc  =MWKSobre.cantidad
			
				do sp_datos_sobretur.prg	
				sele MwkPorcSOfer
				go top
				if !eof('MwkPorcSOfer') or !bof('MwkPorcSOfer')
			   		if MwkPorcSOfer.Cantur >0
			   			do sp_cargo_sobretur.prg	
			   		endif	
				endif	  
			endif
		endif
		if used('MWKExisteTurno')
			sele MWKExisteTurno
			use
		endif	
		if used('MwkPorcSOfer')
			sele MwkPorcSOfer
			use
		endif
		if USED('MWKHorasTr')
			sele MWKHorasTr
			use
		endif	
		
		skip 1 in MWKsobre	
	enddo