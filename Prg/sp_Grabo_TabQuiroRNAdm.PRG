Parameters tnOpcion, tnId, tcCurDat


Do Case
	Case tnOpcion = 1
		If tnId = 0
			lcSql = " Insert into TabQuiroRNAdm( " + ;
				"RNA_AdmisionM, RNA_AdmisionRN, RNA_Caracteristica, " + ;
				"RNA_Sexo, RNA_Peso, RNA_Deriva, RNA_Apgar, " + ;
				"RNA_Capurro, RNA_FecPasiva, RNA_HoraParto, " + ;
				"RNA_VaxPasiva, RNA_Nombre, RNA_IdQuiroProto, RNA_Apgar2)" + ;
				" Values (Trim(?&tcCurDat..RNA_AdmisionM), Trim(?&tcCurDat..RNA_AdmisionRN), Trim(?&tcCurDat..RNA_Caracteristica), " + ;
				"trim(?&tcCurDat..RNA_Sexo), ?&tcCurDat..RNA_Peso, ?&tcCurDat..RNA_Deriva, ?&tcCurDat..RNA_Apgar, " + ;
				"?&tcCurDat..RNA_Capurro, ?&tcCurDat..RNA_FecPasiva, ?&tcCurDat..RNA_HoraParto, " + ;
				"?&tcCurDat..RNA_VaxPasiva, Trim(?&tcCurDat..Pac_NombrePaciente), ?&tcCurDat..RNA_IdQuiroProto, ?&tcCurDat..RNA_Apgar2)"
		Else
			lcSql = " Update TabQuiroRNAdm " + ;
				"Set RNA_AdmisionM = Trim(?&tcCurDat..RNA_AdmisionM), RNA_AdmisionRN = Trim(?&tcCurDat..RNA_AdmisionRN), " + ;
				"RNA_Caracteristica = Trim(?&tcCurDat..RNA_Caracteristica), " + ;
				"RNA_Sexo = trim(?&tcCurDat..RNA_Sexo), RNA_Peso = ?&tcCurDat..RNA_Peso, RNA_Deriva = ?&tcCurDat..RNA_Deriva, " + ;
				"RNA_Apgar = ?&tcCurDat..RNA_Apgar, " + ;
				"RNA_Capurro = ?&tcCurDat..RNA_Capurro, RNA_FecPasiva = ?&tcCurDat..RNA_FecPasiva, " + ;
				"RNA_HoraParto = ?&tcCurDat..RNA_HoraParto, RNA_Nombre = Trim(?&tcCurDat..Pac_NombrePaciente),  " + ;
				"RNA_Apgar2 = ?&tcCurDat..RNA_Apgar2 " + ;
				"Where Id = ?tnId "
		Endif 
	Case tnOpcion = 2
			lcSql = " Update TabQuiroRNAdm " + ;
				"Set " + ;
				"RNA_FecPasiva = ?&tcCurDat..RNA_FecPasiva, " + ;
				"RNA_VaxPasiva = ?&tcCurDat..RNA_VaxPasiva " + ;
				"Where Id = ?tnId "


	Otherwise
	
Endcase 

if !Prg_EjecutoSql(lcSql,"",.f.)
	Return .f.
Endif
