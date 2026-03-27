parameters mnid,mid

*!* Tablas Neo
SET STEP ON 
*!*	Antecedentes/Parto/Nacimiento:

*!*		ZabNeoAntecApgar
*!*		ZabNeoAntecDatosParto
*!*		ZabNeoAntecMatCom
*!*		ZabNeoAntecMatMed
*!*		ZabNeoAntecMatPlus
*!*		ZabNeoAntecMaterno
*!*		ZabNeoAntecNacimiento

* ZabneoAntecApgar
mnid = "548406-5" 
mid = "548317-2"
mret =  sqlexec(mcon1,"update ZabneoAntecApgar set NAA_admisionrn =  ?mnid  where NAA_admisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar Apgar",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

* ZabNeoAntecDatosParto

mret =  sqlexec(mcon1,"update ZabNeoAntecDatosParto set NDP_admisionrn =  ?mnid  where NDP_nroadmisionRN =?mid")
if mret < 0
	messagebox("ERROR al actualizar Datos del Parto",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

* ZabNeoAntecMatCom

mret =  sqlexec(mcon1,"update ZabNeoAntecMatCom set AMC_admisionrn =  ?mnid  where AMC_admisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar Comorbilidades de la madre (Neonatología)",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

* ZabNeoAntecMatMed

mret =  sqlexec(mcon1,"update ZabNeoAntecMatMed set AMM_admisionrn =  ?mnid  where AMM_admisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar Medicaciones de la madre (Neonatología)",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

* ZabNeoAntecMatPlus

mret =  sqlexec(mcon1,"update ZabNeoAntecMatPlus set AMP_admisionrn =  ?mnid  where AMP_admisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar Enfermedades de la madre (Neonatología)",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

* ZabNeoAntecMaterno

mret =  sqlexec(mcon1,"update ZabNeoAntecMaterno set NAM_admisionrn =  ?mnid  where NAM_admisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar Antecedentes de la madre (Neonatología)",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

* ZabNeoAntecNacimiento

mret =  sqlexec(mcon1,"update ZabNeoAntecNacimiento set NAN_admisionrn =  ?mnid  where NAN_admisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos del nacimiento (Neonatología)",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif


* --------------------------------------------------------------------------------------------------------



*!*	Ingreso/Evolución:

*!*		ZabNeoIEAbdomen

mret =  sqlexec(mcon1,"update ZabNeoIEAbdomen set ABD_nroadmisionrn =  ?mnid  where ABD_nroadmisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Abdomen",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIEAntro

mret =  sqlexec(mcon1,"update ZabNeoIEAntro set ANT_nroadmisionrn =  ?mnid  where ANT_nroadmisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Antropología",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIEAspecto

mret =  sqlexec(mcon1,"update ZabNeoIEAspecto set ASP_nroadmisionrn =  ?mnid  where ASP_nroadmisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Aspecto",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIECardio

mret =  sqlexec(mcon1,"update ZabNeoIECardio set CAR_nroadmisionrn =  ?mnid  where CAR_nroadmisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Cardiología",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIEHemato

mret =  sqlexec(mcon1,"update ZabNeoIEHemato set HEM_nroadmisionrn =  ?mnid  where HEM_nroadmisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Cardiología",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIEInfecto

mret =  sqlexec(mcon1,"update ZabNeoIEInfecto set INF_nroadmisionrn =  ?mnid  where INF_nroadmisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Infectología",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIEMalforma

mret =  sqlexec(mcon1,"update ZabNeoIEMalforma set MAL_nroadmisionrn =  ?mnid  where MAL_nroadmisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Malformaciones",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIEMetabolico

mret =  sqlexec(mcon1,"update ZabNeoIEMetabolico set MET_nroadmisionrn =  ?mnid  where MET_nroadmisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Metabólico",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIENeuro

mret =  sqlexec(mcon1,"update ZabNeoIENeuro set NEU_nroadmisionrn =  ?mnid  where NEU_nroadmisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Neurología",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIENutri

mret =  sqlexec(mcon1,"update ZabNeoIENutri set NUT_nroadmisionrn =  ?mnid  where NUT_nroadmisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Nutrición",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIEOftalmo

mret =  sqlexec(mcon1,"update ZabNeoIEOftalmo set OFT_nroadmisionrn =  ?mnid  where OFT_nroadmisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Oftalmología",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIEOseo

mret =  sqlexec(mcon1,"update ZabNeoIEOseo set OSE_nroadmisionrn =  ?mnid  where OSE_nroadmisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Osteo-Funcional",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIEPiel

mret =  sqlexec(mcon1,"update ZabNeoIEPiel set PIE_nroadmisionrn =  ?mnid  where PIE_nroadmisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Piel",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIEQuiro

mret =  sqlexec(mcon1,"update ZabNeoIEQuiro set QUI_nroadmisionrn =  ?mnid  where QUI_nroadmisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Quirófano",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoIERespira

mret =  sqlexec(mcon1,"update ZabNeoIERespira set RES_nroadmisionrn =  ?mnid  where RES_nroadmisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Respiración",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

*!*		ZabNeoVarios

mret =  sqlexec(mcon1,"update ZabNeoVarios set VAR_nroadmisionrn =  ?mnid  where VAR_nroadmisionrn =?mid")
if mret < 0
	messagebox("ERROR al actualizar datos de Neonatología: Respiración",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif
