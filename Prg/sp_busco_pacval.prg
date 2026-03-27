*
* Busco Datos de Vales / Pacientes
*
lParameters mnroval
if mxambito >1
	mbuscov  =  " and pac_codambito=?mxambito " 
else
	mbuscov  = ''
endif

Use in select("mwkvalpac")

mret = sqlexec(mcon1,"select VAL_codadmision, PAC_nombrepaciente, PAC_fecnacimiento, PAC_sexo, PAC_edad"+;
    " ,PAC_codhci, PAC_codhce"+;
	" From VALESASIST"+;
	" Join PACIENTES on PACIENTES.PAC_codadmision = VAL_codadmision"+;
	" Where VAL_codvaleasist = ?mnroval "+mbuscov,"mwkvalpac")

If mret < 0
	MTABLA = "CONSULTA DE DATOS VALES/PACIENTES"
	Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
