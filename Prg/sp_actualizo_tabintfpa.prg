*!*	sp_actualizo_TabIntFPA
Parameters tnOpcion, tnId, tnadmision , tncodmed , tnfechaPA , tnobserva , tnpasivado 

mfecnul = CTOD("01/01/1900")
Do Case
	Case tnOpcion = 1
		lcSql = "Insert into TabIntFPA " + ;
			" (IFA_admision , IFA_codmed , IFA_fechaPA , IFA_observa , IFA_pasivado  ) " + ;
			" Values " + ;
			" (?tnadmision , ?tncodmed , ?tnfechaPA , ?tnobserva , ?mfecnul ) "

	Case tnOpcion = 2

		lcSql = "Update TabIntFPA " + ;
			" Set IFA_admision = ?tnadmision , IFA_codmed = ?tncodmed , IFA_fechaPA = ?tnfechaPA ,IFA_observa = ?tnobserva , IFA_pasivado  = ?tnpasivado " + ;
			"Where id = ?tnId " 
	Case tnOpcion = 3

		lcSql = "Update TabIntFPA " + ;
			" Set IFA_pasivado  = ?tnpasivado " + ;
			" Where  IFA_admision = ?tnadmision and  IFA_pasivado  = ?mfecnul " 

	Otherwise

Endcase

if !Prg_EjecutoSql(lcSql,'',.f.)
	Return .f.
Endif 

