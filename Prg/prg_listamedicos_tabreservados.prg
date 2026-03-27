parameter vr_tipoturno, vr_tiposalida,lvigen
mfecha =sp_busco_fecha_serv('DD')
if type('lvigen')#"N"
	lvigen=0
endif
cvigen = iif(lvigen=0,'',' and fecvigenh>= ?mfecha and fvigend <> fvigenh ')
cvigenmp = iif(lvigen=0,'',' and fecvigenh >= ?mfecha and fecvigenh <> fecvigend ')
mfecnul = ctod("01/01/1900")
mfiltro = iif(lvigen=1," and (b.fecpasivap = ?mfecnul or b.fecpasivap >?mfecha) ",'')
if mxambito >1
	mccpoamb = "  a.codambito = ?mxambito and "
else
	mccpoamb = ' a.id>5000 and '	
endif

mret=sqlexec(mcon1,"Select a.codmed,b.nombre, a.diasem, a.horardesde, a.horarhasta, "+;
	 "a.horares1, a.horares2, a.horares3, a.horares4, a.horares5, a.horares6, a.horares7, "+;
	 "a.horares8, a.horares9, a.horares10, a.guardia, a.internado, c.abreviatura, a.fecvigend, "+;
	 "a.fecvigenh, a.horadesde, a.horahasta, a.cantidad, d.descripcion  "+;	
	 "from tabreservado as a, prestadores as b, tabtipoturno as c, tabcriterios as d "+;
 	 "where &mccpoamb centromedico = ?mxcentromedico and  codmed is not null and b.id=a.codmed and a.tipoturno=c.tipoturno "+;
 	 "and a.criterio = d.id "+;
 	 "and a.tipoturno in " + vr_tipoturno + cvigenmp +mfiltro +; 
 	 "","MwkTablaREs")
 	If mxambito = 1
		mccpoamb = ' '
	Endif
		

if mret < 0
	mret = 0
	messagebox("No se pudieron generar los datos",16, "Validacion") 
else	 	 

	select nombre,iif(diasem=2,'Lunes     '  ,iif(diasem=3,'Martes    ',iif(diasem=4,'Miércoles ', ; 
	iif(diasem=5,'Jueves    ' ,iif(diasem=6,'Viernes   ' , iif(diasem=7,'Sabado    ' ,'Domingo   ')))))) as dia, ;
	iif(isnull(horadesde),nvl(ttoc(horadesde,2),'00:00:00 - 00:00:00'), ;
	left(ttoc(horadesde,2),8) +' - ' + left(ttoc(horahasta,2),8))as franja,;
	iif(isnull(horaRdesde),space(8),left(ttoc(horaRdesde,2),8)) as Hora_Desde, ;
	iif(isnull(horaRhasta),space(8),ttoc(horaRhasta,2)) as Hora_Hasta, ;
	iif(isnull(ttoc(horares1,2)),space(8),ttoc(horares1,2)) as Reserva1, ;
	iif(isnull(ttoc(horares2,2)),space(8),ttoc(horares2,2)) as Reserva2, ;
	iif(isnull(ttoc(horares3,2)),space(8),ttoc(horares3,2)) as Reserva3, ;
	iif(isnull(ttoc(horares4,2)),space(8),ttoc(horares4,2)) as Reserva4, ;
	iif(isnull(ttoc(horares5,2)),space(8),ttoc(horares5,2)) as Reserva5, ;
	iif(isnull(ttoc(horares6,2)),space(8),ttoc(horares6,2)) as Reserva6, ;
	iif(isnull(ttoc(horares7,2)),space(8),ttoc(horares7,2)) as Reserva7, ;
	iif(isnull(ttoc(horares8,2)),space(8),ttoc(horares8,2)) as Reserva8, ;
	iif(isnull(ttoc(horares9,2)),space(8),ttoc(horares9,2)) as Reserva9, ;
	iif(isnull(ttoc(horares10,2)),space(8),ttoc(horares10,2)) as Reserva10, ;
	iif(isnull(ttoc(guardia,2)),space(8),ttoc(Guardia,2)) as Guardia, ;
	iif(isnull(ttoc(internado,2)),space(8),ttoc(Internado,2)) as Internado, ;
	iif(isnull(cantidad),space(2),allt(str(cantidad))) as cantidad, ;
	iif(isnull(cantidad),space(20),descripcion) as criterio, ;
	abreviatura as Tipo_turno, fecvigend, fecvigenh  ;
	from  MwkTablaREs order by nombre, diasem into cursor TablaReservados

endif

mfechah = sp_busco_fecha_serv('DT')
sele TablaReservados
go top

if vr_tiposalida ="R"
	report form repturno40.frx preview
endif
if vr_tiposalida ="F"
	if !eof('TablaReservados')
		oleapp = createobject("excel.application")

		oleapp.workbooks.open(alltrim(zzvolumen) + "\qepd1a1\xlt\Tablareservados.xlt")
		oleapp.cells(4,2).value = "Reservados Guardia-Internados, Plan de Salud y Exclusivos y Especiales" 
		i = 6

			do while !eof("TablaReservados")
		
				oleapp.cells(i,2).value   = TablaReservados.nombre
				oleapp.cells(i,3).value   = TablaReservados.dia
				oleapp.cells(i,4).value   = TablaReservados.Franja
				oleapp.cells(i,5).value   = TablaReservados.Tipo_turno
				oleapp.cells(i,6).value   = TablaReservados.fecvigend
				oleapp.cells(i,7).value   = TablaReservados.fecvigenh
				oleapp.cells(i,8).value   = TablaReservados.Hora_desde
				oleapp.cells(i,9).value   = TablaReservados.Hora_hasta
				oleapp.cells(i,10).value   = TablaReservados.Guardia
				oleapp.cells(i,11).value  = TablaReservados.Internado
				oleapp.cells(i,12).value  = TablaReservados.Reserva1
				oleapp.cells(i,13).value  = TablaReservados.Reserva2
				oleapp.cells(i,14).value  = TablaReservados.Reserva3
				oleapp.cells(i,15).value  = TablaReservados.Reserva4
				oleapp.cells(i,16).value  = TablaReservados.Reserva5
				oleapp.cells(i,17).value  = TablaReservados.Reserva6
				oleapp.cells(i,18).value  = TablaReservados.Reserva7
				oleapp.cells(i,19).value  = TablaReservados.Reserva8
				oleapp.cells(i,20).value  = TablaReservados.Reserva9
				oleapp.cells(i,21).value  = TablaReservados.Reserva10
				oleapp.cells(i,22).value  = TablaReservados.Cantidad
				oleapp.cells(i,23).value  = TablaReservados.Criterio
				
				i = i + 1
				skip 1 in TablaReservados
			enddo
		oleapp.visible = .t.

		endif	 
endif
*mret=sqlexec(mcon1,"Select count(codmed) from tabreservado where codmed is not null","MwkCantREs")
 	 
if used('MwkTablaRes')
	use
endif	
if used('TablaReservados')
   use
endif	