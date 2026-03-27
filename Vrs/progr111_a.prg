AAAA ASADASD*
*
*
*

select consulta
go top
do sp_conexion

fecaudi   = sp_busco_fecha_serv('DT')
susp
do while !eof('consulta')

	mncodmed	 = consulta.codmed
	mndia		 = consulta.diasem
	mctipostruc  = 'T'
	mfecvigend   = consulta.fecvigend
	mfecvigenh   = consulta.fecvigenh
	mthrdes		 = consulta.horadesde
	mthrhas		 = consulta.horahasta
	mnimparch	 = 1
	mntipofranja = 1
	mntipotur	 = 0

	mret = sqlexec(mcon1," INSERT INTO FranjaHoraria ( codmed,  diasem,  estructura," +;
				       "  fechagraba, fecvigend, fecvigenh,  HoraDesde, HoraHasta,  " +; 
				       "  ImpArchivo, tiposervicio, usuario, tipoturno)             " +;
				       "  values (?mncodmed, ?mndia, ?mctipostruc, ?fecaudi,        " +;
				       "  ?mfecvigend, ?mfecvigenh, ?mthrdes, ?mthrhas, ?mnimparch, " +;
				       "  ?mntipofranja, ?midusu, ?mntipotur )")

	skip 1 in consulta
enddo

=sqldisconnect(mcon1)