*
* Busqueda movimientos x Fecha
*
parameters mcodEnt, mfecha_1, mfecha_2, mtipfec

*!*	mtipfec = 1 && Salida  = hcmfechasal
*!*	mtipfec = 2 && Entrada = hcmfechaingr
if vartype(mtipfec)#"N"
	mtipfec = 1
endif
mfecha_1= prg_dtoc(mfecha_1)
mfecha_2= prg_dtoc(mfecha_2)

&& Traigo Nro. Adm. verdaderas + Pseudo

mret = sqlexec(mcon1," select hcmnrohCli,pac_nombrepaciente,hcmnroadm,hcmfechasal,"+;
	" pac_fechaadmision,hcmretira,hcmdestino,hcmdescmed,Cob_codentidad,ent_descrient,"+;
	" hcmfechaIngr"+;
	" from TabHCIMovst"+;
	" INNER join pacientes On pac_codadmision = hcmnroadm "+;
	" left join coberturas On cob_pacientes = pac_codadmision "+;
	" left join entidades On cob_codentidad = ent_codent "+;
	iif(mtipfec=1," where hcmfechasal  >= ?mfecha_1  AND hcmfechasal <= ?mfecha_2 ",;
	" where hcmfechaingr >= ?mfecha_1  AND hcmfechaingr <= ?mfecha_2 ")+;
	iif(empty(mcodEnt),''," and Cob_codentidad = ?mcodEnt"),"mwksector1")

if mret < 0
	messagebox('Error De Cursor <Sector>, avisar a sistemas',16,'Validacion')
	cancel
	mret=0
endif

&& Traigo Nro. Adm. pseudo con datos faltantes (nombre, fechas, etc.)

mret = sqlexec(mcon1,"select hcmnrohCli,REG_nombrepac as pac_nombrepaciente,hcmnroadm,"+;
	"hcmfechasal, adm_fechaadm as pac_fechaadmision, hcmretira, hcmdestino,hcmdescmed,"+;
	"ENT_codent,ent_descrient,hcmfechaIngr"+;
	" from TabHCIMovst  "+;
	" inner join TabHCIAdm On hcmregistrac = adm_registrac "+;
	" join REGISTRACIO On REG_nroregistrac = hcmregistrac "+;
	" left join entidades  On ENT_codent = adm_codent "+;
	" where trim(adm_nroadm) = trim(hcmnroadm) and "+;
	iif(mtipfec=1," hcmfechasal  >= ?mfecha_1  AND hcmfechasal <= ?mfecha_2 ",;
	" hcmfechaingr >= ?mfecha_1  AND hcmfechaingr <= ?mfecha_2 ")+;
	" ","MwkUSector3")

*   hcmregistrac

if mret < 0
	messagebox('Error De Cursor <Sector2>, avisar a sistemas',16,'Validacion')
	cancel
	mret=0
endif

use in select("MwkUSector")
select * from mwksector1 union select * from MwkUSector3 into cursor mwkusector4
use dbf('mwkusector4') in 0 again alias mwkusector


use in select("MwkUSector1")
use in select("MwkUSector3")
use in select("MwkUSector4")



