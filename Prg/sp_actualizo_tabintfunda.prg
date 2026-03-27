*!*	sp_actualizo_TabIntfunda
parameters tnOpcion, tnId, tnadmision , tncodmed , tnobserva , tnccrp , tnchk1 , tnchk10 , tnchk11 , tnchk12 , tnchk2 , tnchk3 , tnchk4 ,;
	tnchk5 , tnchk6 , tnchk7 , tnchk8 , tnchk9 , tnchk13,tndestino
tnfechah = sp_busco_fecha_serv("DT")
mfecnul= ctod("01/01/1900")
tnpasivado = tnfechah 
do case
	case tnOpcion = 1
		lcSql = "Insert into TabIntFundamenta  " + ;
			" (IF_admision , IF_ccrp , IF_chk1 , IF_chk10 , IF_chk11 , IF_chk12 , IF_chk2 , IF_chk3 , IF_chk4 ,IF_chk5 ,IF_chk6  "+;
			", IF_chk7 , IF_chk8 , IF_chk9 , IF_codmed ,  IF_fechah , IF_observa , IF_pasivado,IF_chk13,if_destino ) " + ;
			" Values " + ;
			" (?tnadmision , ?tnccrp , ?tnchk1 , ?tnchk10 , ?tnchk11 , ?tnchk12 , ?tnchk2 , ?tnchk3 , ?tnchk4 ,?tnchk5 , "+;
			" ?tnchk6 , ?tnchk7 , ?tnchk8 , ?tnchk9 , ?tncodmed , ?tnfechah , ?tnobserva , ?mfecnul, ?tnchk13, ?tndestino) "

	case tnOpcion = 2

		lcSql = "Update TabIntFundamenta  " + ;
			" Set IF_admision = ?tnadmision , IF_codmed = ?tncodmed , IF_observa = ?tnobserva , IF_pasivado  = ?mfecnul" + ;
			"Where id = ?tnId "
	case tnOpcion = 3

		lcSql = "Update TabIntFundamenta  " + ;
			" Set IF_pasivado  = ?tnpasivado " + ;
			" Where  IF_admision = ?tnadmision and  IF_pasivado  = ?mfecnul "

	otherwise

endcase

if !Prg_EjecutoSql(lcSql,'',.f.)
	return .f.
endif

