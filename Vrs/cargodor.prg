
public mcon3
do sp_conexion_tablas
USE c:\desaguemes\dbf\concepexc.dbf IN 0 EXCLUSIVE
select concepexc
mfp = dtot(ctod("01/01/1900"))
scan
	mclave = clave
	mconce = concepto 
	mtipo = tipo
	
	mret = sqlexec(mcon3,'insert into TabPConce(PalabraClave,concepto,fechaPas,tipo) values' +;
		' (?mclave, ?mconce ,?mfp, ?mtipo )')
endscan