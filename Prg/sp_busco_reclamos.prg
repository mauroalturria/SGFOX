*****
***** busco reclamos
*****
Lparameters mpend, mbusco, mactivar

If type ('mbusco') # "C"
	mbusco = ""
Endif

If type ('mactivar') # "C"
	mactivar = "N"
Endif
if mpend<2
	mbusco = mbusco + iif(mpend=1, iif(empty(mbusco),'',' and ')+' estado in ( 0, 1, 5 ) ', ' ')
	If !empty(mbusco)
		mbusco = iif(at("Where",mbusco)=0," Where ","") + mbusco
	Endif

	mret = sqlexec(mcon1,"select TabReclamos.*,tabreclest.descrip,"+;
		"tabmotivos.descrip as desmotivo "+;
		"from TabReclamos " + ;
		"left join tabreclest on TabReclamos.estado = tabreclest.codest " + ;
		"left join tabmotivos on TabReclamos.motivo = tabmotivos.id " + mbusco, "mwkrecla")
	If mactivar = "S"
	
		mhoy = sp_busco_fecha_serv("DT")

		Select *,nvl(FechaActiva,ctot('1900-01-01 00:00:00')) as factiva,;
			iif(nvl(PrevCorrec,1)=1 ,"Correctivo","Preventivo") as PCorrec,;
			nvl(PrevCorrec,1) as PCorrec2;
  		     from mwkrecla ;
			where nvl(FechaActiva,ctot('1900-01-01 00:00:00')) <= mhoy ;
			into cursor mwkrecla
	Else
		
		Select *,nvl(FechaActiva,ctot('1900-01-01 00:00:00')) as factiva,;
			iif(nvl(PrevCorrec,1)=1 ,"Correctivo","Preventivo") as PCorrec,;
			nvl(PrevCorrec,1) as PCorrec2;
  		     from mwkrecla ;
			 into cursor mwkrecla		
			
	Endif
	

else
	If !empty(mbusco)
		mbusco = iif(at("Where",mbusco)=0," Where ","") + mbusco
	Endif

	mret = sqlexec(mcon1,"select id "+;
		"from TabReclamos " + mbusco, "mwkrecla")
endif

If mret < 0
	Messagebox("ERROR AL CREAR EL CURSOR, AVISAR A SISTEMAS", 16, "Validación")

Endif
