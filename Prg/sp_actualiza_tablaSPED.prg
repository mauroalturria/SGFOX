parameters mnid,mid

*!* Tablas PED


*!*		ZabIntAdjunto
*!*		ZabIntPedTto 
*!*		ZabIntPed
*!*		ZabIntPedAnam 
*!*		ZabIntPedEvolm 
*!*		ZabIntPedExFis 
*!*		ZabIntPedNut 

* ZabIntAdjunto 

mret =  sqlexec(mcon1,"update ZabIntAdjunto set IDA_idevol =  ?mnid  where IDA_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar Adjuntos",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

* ZabIntPedTto 

mret =  sqlexec(mcon1,"update ZabIntPedTto set IPT_idevol =  ?mnid  where IPT_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar ZabIntPedTto ",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

* ZabIntPed

mret =  sqlexec(mcon1,"update ZabIntPed set IPT_idevol =  ?mnid  where IPT_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar ZabIntPed",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

* ZabIntPedAnam 

mret =  sqlexec(mcon1,"update ZabIntPedAnam  set IPA_idevol =  ?mnid  where IPA_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar ZabIntPedAnam ",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

* ZabIntPedEvolm 

mret =  sqlexec(mcon1,"update ZabIntPedEvolm set IPA_idevol =  ?mnid  where IPA_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar ZabIntPedEvolm ",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

* ZabIntPedExFis 

mret =  sqlexec(mcon1,"update ZabIntPedExFis set IPEF_idevol =  ?mnid  where IPEF_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar ZabIntPedExFis ",16,"ERROR")
	do log_errores with error(), message(), message(1), program(), lineno()
endif

* ZabIntPedNut 

mret =  sqlexec(mcon1,"update ZabIntPedNut set IPN_idevol =  ?mnid  where IPN_idevol =?mid")
if mret < 0
	messagebox("ERROR al actualizar ZabIntPedNut ",16,"ERROR")
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
