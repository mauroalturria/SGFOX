****
** lista ps vigentes
****
parameter vr_tiposalida,vr_vigentes
mfechah = sp_busco_fecha_serv("DT")
mfecha  =ttod(mfechah)
if vartype(vr_vigentes)#"N"
	vr_vigentes = 0
endif
mfiltro = iif(vr_vigentes=1," and (prestadores.fecpasivap = ?mfecnul or prestadores.fecpasivap >?mfecha) ",'')
mfecnul = CTOD("01/01/1900")
mret = sqlexec(mcon1, "select codmed,diasem,horadesde,horahasta, "+;
						"cantidadps, fecvigend, fecvigenh, nombre " + ;
						"from tabprepaga, prestadores " + ;
						"where codmed = prestadores.id and fecvigenh > ?mfecha " +mfiltro + ;
						"group by nombre, cantidadps ", "mwkps1")
if mret < 0			
	mret = 0
	messagebox('No se puede acceder a los datos',16,'Validacion')
else	
	select codmed,  iif(diasem=2,'Lunes     ', iif(diasem=3,'Martes    ',+;
					iif(diasem=4,'Miércoles ', iif(diasem=5,'Jueves    ',+;
					iif(diasem=6,'Viernes   ', iif(diasem=7,'Sabado    ','Domingo   ')))))) as dia,+;
					iif(isnull(horadesde),nvl(ttoc(horadesde,2),'00:00:00 - 00:00:00'),+;
					left(ttoc(horadesde,2),8) +' - ' + left(ttoc(horahasta,2),8))as franja,+;
					cantidadps, fecvigend, fecvigenh, nombre from mwkps1 order by nombre, diasem into cursor mwkps
	
	if vr_tiposalida ="R"
		report form replistaps preview
	endif
	if vr_tiposalida ="F"
		if !eof('mwkps')
			oleapp = createobject("excel.application")

			oleapp.workbooks.open(alltrim(zzvolumen) + "\qepd1a1\xlt\Tablaps.xlt")
			oleapp.cells(4,2).value = "Plan de Salud al  " + dtoc(mfecha) 
			i = 6

				do while !eof("mwkps")
			
					oleapp.cells(i,2).value   = mwkps.nombre
					oleapp.cells(i,3).value   = mwkps.dia
					oleapp.cells(i,4).value   = mwkps.Franja
					oleapp.cells(i,5).value   = mwkps.fecvigend
					oleapp.cells(i,6).value   = mwkps.fecvigenh
					oleapp.cells(i,7).value   = mwkps.cantidadps
										
					i = i + 1
					skip 1 in mwkps
				enddo
			oleapp.visible = .t.

			endif	 
	  endif
	
endif	
						
*mret = sqlexec(mcon1, "select codmed, horardesde, horarhasta, nombre, diasem " + ;
*						"from tabreservado, prestadores " + ;
*						"where codmed = prestadores.id and tipoturno = 5 " + ;
*						"order by nombre", "mwkps")

*report form replistaps_res preview

