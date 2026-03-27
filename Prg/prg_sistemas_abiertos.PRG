Lparameters tcTitle, tcNomeExe

mcantexe = 0
Do prg_exes_activos With ALLTRIM(tcTitle)&& + Space(6) + "P.Id:"

Do Case
	Case tcNomeExe = 'TURNOS'
		If (mcantexe > 3 And mwkusuario.sector # "SISTEMAS"  And mxambito=1) Or (mcantexe > 6 And mxambito > 1)
			Messagebox("EXCEDIO EL LIMITE DE APLICACIONES DE TURNOS ABIERTAS..." +;
				chr(13) + "DISCULPE LAS MOLESTIAS...", 48,"Control Sistemas")
			Return .f.

		Endif

	Otherwise

Endcase