****
** lista ps vigentes
****
*do sp_conexion

parameter vr_tiposalida, vr_tipotur,vr_vigentes
if mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
else
	mccpoamb = ''	
endif
if vartype(vr_vigentes)#"N"
	vr_vigentes = 0
endif
mfiltro = iif(vr_vigentes=1," and (prestadores.fecpasivap = ?mfecnul or prestadores.fecpasivap >?mfecha) ",'')

mfechah = sp_busco_fecha_serv("DT")
mfecha =ttod(mfechah)
mfecnul = ctod("01/01/1900")
mret = sqlexec(mcon1, "select codmed,diasem,horadesde,horahasta,porcentaje, "+;
	" cantidad, fvigend, fvigenh, nombre " + ;
	" from tabsobretoa, prestadores " + ;
	" where &mccpoamb codmed = prestadores.id and fvigenh > ?mfecha " + vr_tipotur + mfiltro +;
	" group by nombre, cantidad ", "mwksobreto")

if mret < 0
	mret = 0
	messagebox('No se puede acceder a los datos',16,'Validacion')
else
	select codmed,  iif(diasem=2,'Lunes     ', iif(diasem=3,'Martes    ',+;
		iif(diasem=4,'Miércoles ', iif(diasem=5,'Jueves    ',+;
		iif(diasem=6,'Viernes   ', iif(diasem=7,'Sabado    ','Domingo   ')))))) as dia,+;
		iif(isnull(horadesde),nvl(ttoc(horadesde,2),'00:00:00 - 00:00:00'),+;
		left(ttoc(horadesde,2),8) +' - ' + left(ttoc(horahasta,2),8))as franja,+;
		cantidad, porcentaje, fvigend, fvigenh, nombre from mwksobreto order by nombre, diasem into cursor mwktso

	if vr_tiposalida ="R"
		report form replistasobreto preview
	endif
	if vr_tiposalida ="F"
		if !eof('mwktso')
			oleapp = createobject("excel.application")

			oleapp.workbooks.open(alltrim(zzvolumen) + "\qepd1a1\xlt\Tablasobreto.xlt")
			oleapp.cells(4,2).value = "SobreOferta - SobreTurno  al   " + dtoc(mfecha)

			i = 6

			do while !eof("mwktso")

				oleapp.cells(i,2).value   = mwktso.nombre
				oleapp.cells(i,3).value   = mwktso.dia
				oleapp.cells(i,4).value   = mwktso.Franja
				oleapp.cells(i,5).value   = mwktso.fvigend
				oleapp.cells(i,6).value   = mwktso.fvigenh
				oleapp.cells(i,7).value   = mwktso.cantidad
				oleapp.cells(i,8).value   = mwktso.porcentaje
				i = i + 1
				skip 1 in mwktso
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

*=sqldisconnect(mcon1)
