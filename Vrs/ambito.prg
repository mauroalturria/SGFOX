	if !used("mwktabambito")
		do sp_busco_tabla_id with 'tabambito', ' id>0  order by ambito ','mwktabambito'
		select mwktabambito
		locate for id = mxambito
		thisform.txtambito.value = mwktabambito.ambito
		
	endif	
	if used("mwksuperamb")
		thisform.txtambito.value = mwksuperamb.descrip
	endif	
