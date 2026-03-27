publiC medi,fecha,consu
SET STEP ON

fecha = ctod("18/10/2011")

select arrglo
scan
	medi = arrglo.codmed
	consu = arrglo.sala
	hora = val(strtran(primerob,":",""))
	requery('fichamb')
	UPDATE fichamb SET TAI_HHMMING = HORA
endscan




*!*	MODIFY PROJECT c:\desaguemes\prj\ambulatorio.pjx
*!*	MODIFY FORM c:\desa_gus\frmambula03.scx
*!*	copy to lanzador type xls
*!*	SELECT 1
*!*	BROWSE LAST
*!*	SELECT 58
*!*	BROWSE LAST
*!*	SELECT 1
*!*	BROWSE LAST
*!*	DO FORM c:\desaguemes\scx\frmambula05.scx
*!*	BROWSE LAST
*!*	select * from cdatosgrid into cursor cosa
*!*	select * from cdatosgrid into table cosa
*!*	?vartype(paso)
*!*	?val(paso)
*!*	?val(strtran(paso,":",","))
*!*	?val(strtran(paso,":","."))
*!*	?val(strtran(paso,":",","))
*!*	select val(strtran(paso,":",",")) as ing,val(strtran(primerob,":",",")) as ini,* from cdatosgrid into table cosa
*!*	select val(strtran(paso,":",",")) as ing,val(strtran(primerob,":",",")) as ini,* from cdatosgrid into cursor cosa
*!*	SELECT 79
*!*	USE
*!*	SELECT 77
*!*	BROWSE LAST
*!*	?vartype(primerob)
*!*	?val(strtran(primerob,":",","))
*!*	select val(strtran(paso,":",",")) as ing,val(strtran(primerob,":",",")) as ini,*;
	 from cdatosgrid into cursor cosa
*!*	BROWSE LAST
*!*	select * from cosa where ing>0 and ing<ini into cursor arrglo
*!*	BROWSE LAST
*!*	select * from cosa where ing>0 and ing>ini into cursor arrglo
*!*	BROWSE LAST
*!*	?ing-ini
*!*	select * from cosa where ing>0 and ing-ini>0.1 into cursor arrglo
*!*	BROWSE LAST
*!*	MODIFY COMMAND
*!*	BROWSE LAST