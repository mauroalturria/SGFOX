LPARAMETERS nCodAdm

LOCAL lResultado

lResultado = .f.

mret = SQLEXEC(mcon1,"select a.* " +;
 "from tabintpmplan as a " +;
 "where a.pp_idevol = (select max(b.ps_idevol) from tabintpmsolu as b where b.ps_admision = ?nCodAdm) " +;
 "and a.pp_idopt = 7 and a.pp_fecpasiva = '1900-01-01'","mwkMedAlta")
 
If mRet<=0
	Messagebox("ERROR EN LA LECTURA DE INSUMOS PARA ALTA",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif 
 
SELECT mwkMedAlta
GO top

IF RECCOUNT() > 0
   lResultado = .t.
ENDIF 

USE IN SELECT("mwkMedAlta")

RETURN lResultado