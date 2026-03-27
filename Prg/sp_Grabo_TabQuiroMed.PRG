Parameters tnOpcion, tcCurUpd

tcCursor = "" && actualiza no hace falta


Do Case
Case tnOpcion = 1
	lnHoraInQX = Int(Val(Substr(Ttoc(&tcCurUpd..TQC_HoraIngQX,1),9,4)))
	lnHoraIndAnes = Int(Val(Substr(Ttoc(&tcCurUpd..TQC_HoraIniAnesMed,1),9,4)))
	lnHoraFinAnes = Int(Val(Substr(Ttoc(&tcCurUpd..TQC_HoraFinAnesMed,1),9,4)))
	lnHoraSalida  = Int(Val(Substr(Ttoc(&tcCurUpd..TQC_HoraSalida,1),9,4)))



	lcSql = "Update TabQuirofano Set " + ;
		"TQC_HoraLlega = ?&tcCurUpd..TQC_HoraLlega, " + ;
		"TQC_HoraIngQX = ?&tcCurUpd..TQC_HoraIngQX , " + ;
		"TQC_HoraSalida = ?&tcCurUpd..TQC_HoraSalida, " + ;
		"TQC_HoraIniAnesMed = ?&tcCurUpd..TQC_HoraIniAnesMed, " + ;
		"TQC_HoraFinAnesMed = ?&tcCurUpd..TQC_HoraFinAnesMed, " + ;
		"TQC_NroQuiro = ?&tcCurUpd..TQC_NroQuiro,horaingQuirof =?lnHoraInQX   , " + ;
		"HoraIndAnes = ?lnHoraIndAnes , HoraFinAnes = ?lnHoraFinAnes, HoraEgre = ?lnHoraSalida " + ;
		"Where Id = ?&tcCurUpd..Id "

Otherwise

Endcase

If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
	Return .F.
Endif


