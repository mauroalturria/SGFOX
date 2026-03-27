****
** Busco pacientes de alta por nombre y fecha_alta desde
****
if used('datos')
	use in datos
endif	
create table datos (codadm c (8),aa c(1),paciente c (50),motivo c (50),fechaalta d )
append from c:\ale\datos type sdf
select datos
scan
	mcodadm = codadm
	mret = sqlexec(mcon3, "select PAC_codadmision, PAC_fechaalta,mte_descripcion " + ;
		"from pacientes " + ;
		" left join motivoegreso on PAC_motivoalta = mte_codmotivo " +;
		"where PAC_codadmision 	= ?mcodadm and " + ;
		"PAC_tipopaciente not in ('GUA', 'AMB') " + ;
		"group by PAC_codadmision " +;
		"order by PAC_codadmision ", "mwkpacalta1")
	if mret < 0
		=aerr(eros)
		messagebox(eros(3))
		set step on
	endif
	select datos
	replace motivo with mwkpacalta1.mte_descripcion, fechaalta with mwkpacalta1.PAC_fechaalta
endscan
