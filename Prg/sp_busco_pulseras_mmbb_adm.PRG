Parameters tnOpcion, tcAdmOrig, tcCurName
IF VARTYPE(tcCurName)<>"C"
tcCurName = 'mwkRelRegG'
endif
Local lcsql

Do Case
	Case tnOpcion = 1
		TEXT To lcsql Textmerge Noshow Pretext 7
				Select TabRelReg.id, TRR_ADMDEST, B.PAC_NombrePaciente,
				 R2.Reg_NombrePac,
				 TRR_FecHorAdd, u.NomApe, R2.Reg_NrohClinica
				 From TabRelReg
				 left JOIN PACIENTES B ON B.PAC_CODADMISION = TabRelReg.TRR_ADMDEST
				 left JOIN REGISTRACIO R2 ON R2.REG_NROREGISTRAC = TabRelReg.TRR_RegDest
				 left JOIN TabUsuario u ON u.CodigoVax = TabRelReg.TRR_CodVaxAdd
				 where TabRelReg.TRR_ADMORIG = ?tcAdmOrig

		ENDTEXT
	Case tnOpcion = 2  &&& busca por BB 
		TEXT To lcsql Textmerge Noshow Pretext 7
				Select TabRelReg.id, TRR_ADMDEST,TRR_ADMORIG ,TRR_RegOrig, B.PAC_NombrePaciente,
				 R2.Reg_NombrePac,r2.REG_numdocumento,
				 TRR_FecHorAdd, u.NomApe, R2.Reg_NrohClinica,TRR_FechorNac,TRR_InternaEn 
				 From TabRelReg
				 left JOIN PACIENTES B ON B.PAC_CODADMISION = TabRelReg.TRR_ADMORIG
				 left JOIN REGISTRACIO R2 ON R2.REG_NROREGISTRAC = TabRelReg.TRR_RegOrig
				 left JOIN TabUsuario u ON u.CodigoVax = TabRelReg.TRR_CodVaxAdd
				 where TabRelReg.TRR_ADMDEST = ?tcAdmOrig

		ENDTEXT

	Otherwise

Endcase

If !Prg_EjecutoSql(lcsql,tcCurName)
	Return .F.
Endif
