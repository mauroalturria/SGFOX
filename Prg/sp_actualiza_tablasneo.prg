parameters mnid,mid

*!* Tablas Neo

*!*	Antecedentes/Parto/Nacimiento:

*!*		ZabNeoAntecApgar
*!*		ZabNeoAntecDatosParto
*!*		ZabNeoAntecMatCom
*!*		ZabNeoAntecMatMed
*!*		ZabNeoAntecMatPlus
*!*		ZabNeoAntecMaterno
*!*		ZabNeoAntecNacimiento

* ZabneoAntecApgar

mret =  sqlexec(mcon1,"update ZabneoAntecApgar set NAA_idevol =  ?mnid  where NAA_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar Apgar",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

* ZabNeoAntecDatosParto

mret =  sqlexec(mcon1,"update ZabNeoAntecDatosParto set NDP_idevol =  ?mnid  where NDP_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar Datos del Parto",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

* ZabNeoAntecMatCom

mret =  sqlexec(mcon1,"update ZabNeoAntecMatCom set AMC_idevol =  ?mnid  where AMC_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar Comorbilidades de la madre (Neonatología)",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

* ZabNeoAntecMatMed

mret =  sqlexec(mcon1,"update ZabNeoAntecMatMed set AMM_idevol =  ?mnid  where AMM_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar Medicaciones de la madre (Neonatología)",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

* ZabNeoAntecMatPlus

mret =  sqlexec(mcon1,"update ZabNeoAntecMatPlus set AMP_idevol =  ?mnid  where AMP_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar Enfermedades de la madre (Neonatología)",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

* ZabNeoAntecMaterno

mret =  sqlexec(mcon1,"update ZabNeoAntecMaterno set NAM_idevol =  ?mnid  where NAM_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar Antecedentes de la madre (Neonatología)",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

* ZabNeoAntecNacimiento

mret =  sqlexec(mcon1,"update ZabNeoAntecNacimiento set NAN_idevol =  ?mnid  where NAN_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos del nacimiento (Neonatología)",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif


* --------------------------------------------------------------------------------------------------------



*!*	Ingreso/Evolución:

*!*		ZabNeoIEAbdomen

mret =  sqlexec(mcon1,"update ZabNeoIEAbdomen set ABD_idevol =  ?mnid  where ABD_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Abdomen",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIEAntro

mret =  sqlexec(mcon1,"update ZabNeoIEAntro set ANT_idevol =  ?mnid  where ANT_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Antropología",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIEAspecto

mret =  sqlexec(mcon1,"update ZabNeoIEAspecto set ASP_idevol =  ?mnid  where ASP_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Aspecto",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIECardio

mret =  sqlexec(mcon1,"update ZabNeoIECardio set CAR_idevol =  ?mnid  where CAR_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Cardiología",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIEHemato

mret =  sqlexec(mcon1,"update ZabNeoIEHemato set HEM_idevol =  ?mnid  where HEM_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Cardiología",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIEInfecto

mret =  sqlexec(mcon1,"update ZabNeoIEInfecto set INF_idevol =  ?mnid  where INF_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Infectología",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIEMalforma

mret =  sqlexec(mcon1,"update ZabNeoIEMalforma set MAL_idevol =  ?mnid  where MAL_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Malformaciones",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIEMetabolico

mret =  sqlexec(mcon1,"update ZabNeoIEMetabolico set MET_idevol =  ?mnid  where MET_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Metabólico",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIENeuro

mret =  sqlexec(mcon1,"update ZabNeoIENeuro set NEU_idevol =  ?mnid  where NEU_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Neurología",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIENutri

mret =  sqlexec(mcon1,"update ZabNeoIENutri set NUT_idevol =  ?mnid  where NUT_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Nutrición",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIEOftalmo

mret =  sqlexec(mcon1,"update ZabNeoIEOftalmo set OFT_idevol =  ?mnid  where OFT_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Oftalmología",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIEOseo

mret =  sqlexec(mcon1,"update ZabNeoIEOseo set OSE_idevol =  ?mnid  where OSE_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Osteo-Funcional",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIEPiel

mret =  sqlexec(mcon1,"update ZabNeoIEPiel set PIE_idevol =  ?mnid  where PIE_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Piel",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIEQuiro

mret =  sqlexec(mcon1,"update ZabNeoIEQuiro set QUI_idevol =  ?mnid  where QUI_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Quirófano",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIERespira

mret =  sqlexec(mcon1,"update ZabNeoIERespira set RES_idevol =  ?mnid  where RES_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Respiración",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoVarios

mret =  sqlexec(mcon1,"update ZabNeoVarios set VAR_idevol =  ?mnid  where VAR_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Respiración",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif
