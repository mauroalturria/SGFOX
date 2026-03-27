****
** grabo datos de turnos no otorgados
****
lparameters vafiliado, vcodent, vcodmed, vcodprest ,vmotivo, vfecha

mfech = sp_busco_fecha_serv("DT")
vfecha = iif(vartype(vfecha)#"T",ctot("01/01/2100"),vfecha)
select mwkusuario
go top
midu = mwkusuario.idusuario

if used('mwkbuscotexto')

	if !used('mwkprestgua')
		do sp_busco_prestacion_gua with " and nivel = 2 and pre_codservicio = 8000 group by pre_especialidad "
	endif
	select mwkprestgua
	locate for pre_especialidad = mwkbuscotexto.pre_especialidad
	mresp = 7
	if found() and mwkbuscotexto.pre_codservicio = 2200
		mresp = 2
		do while mresp = 2
			mresp = messagebox(chr(10)+"Recuerdele al paciente que el Sanatorio dispone de profesionales "+;
				chr(10)+chr(10)+"del mismo equipo médico en demanda espontanea las 24 hs "+;
				chr(10)+chr(10)+"Indique si se lo comunicó al paciente.. ",3+512+64,"Avisos al Paciente")
		enddo
	endif
*mresp = messagebox("PASA LA LLAMADA AL CENTRO DERIVADOR?",4+256+32,"Seguimiento de Derivaciones")
	mderiva = iif(mresp=7,9,iif(mresp=6,8,0))
	mret = sqlexec(mcon1, "insert into TurnosInsatis (afiliado , codent , codmed "+;
		", codprest , fechasol , hora1erTurno , motivo , usuario,derivado  )"+;
		" values ( ?vafiliado, ?vcodent, ?vcodmed, ?vcodprest ,?mfech, "+;
		"?vfecha , ?vmotivo, ?midu,?mderiva )" )
	if mret < 0
		=aerr(eros)
		messagebox(eros(3), 64,'Validacion')
	endif
endif
select id from mwkusuario into cursor mkwctrlrechazo
