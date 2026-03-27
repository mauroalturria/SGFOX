*
* Cuidados Domiciliarios
*
lparameters  madmis,midap

mfnull = ctod("01/01/1900")
use in select("mwkcuidomPre")
mret = sqlexec(mcon1,"select * "+;
	" from TabAutCDP "+;
	" where ACP_admision = ?madmis and ACP_idautprevia>= ?midap and ACP_pasivado = ?mfnull","mwkcuidomPre")

if mret < 0
	MTABLA = "CUIDADOS DOMICILIARIOS PRESTACIONES"
	do LOG_ERRORES with error(), message(), message(1), program(), lineno()
	messagebox("EN LA TABLA " + MTABLA + chr(10)+"AVISE A SISTEMAS",16,"ERROR")
endif
use in select("mwkcuidomEqp")
mret = sqlexec(mcon1,"select * "+;
	" from TabAutCDE "+;
	" Where ACE_admision  = ?madmis and ACE_idautprevia>= ?midap and ACE_pasivado = ?mfnull ","mwkcuidomEqp")

if mret < 0
	MTABLA = "CUIDADOS DOMICILIARIOS EQUIPAMIENTO"
	do LOG_ERRORES with error(), message(), message(1), program(), lineno()
	messagebox("EN LA TABLA " + MTABLA + chr(10)+"AVISE A SISTEMAS",16,"ERROR")

endif

use in select("mwkcuidomInd")
mret = sqlexec(mcon1,"select TabAutCDI.*, insumos.ins_descriinsumo, insumos.ins_medsensi "+;
	" from TabAutCDI "+;
	" left join insumos on insumos.INS_codpuntero = TabAutCDI.ACI_codpuntero "+;
	" Where ACI_admision  = ?madmis and ACI_idautprevia>= ?midap and ACI_pasivado = ?mfnull","mwkcuidomInd")

if mret < 0
	MTABLA = "CUIDADOS DOMICILIARIOS INDICACIONES"
	do LOG_ERRORES with error(), message(), message(1), program(), lineno()
	messagebox("EN LA TABLA " + MTABLA + chr(10)+"AVISE A SISTEMAS",16,"ERROR")
endif
use in select("mwkestpre")
use in select("mwkesteqp")
do sp_busco_estados with 5,' and estado=1 and tipo in (0,2) order by descrip','mwkestpre'
do sp_busco_estados with 5,' and estado=2 and tipo in (0,2) order by descrip','mwkesteqp'

