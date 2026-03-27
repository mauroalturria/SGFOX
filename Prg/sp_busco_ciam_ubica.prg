*
* Busqueda de ubicaciones, centros asistenciales, etc. TabCiamUbica
*
Lparameters mbusca, mfiltro, mfiltro2

*,mbristol
*If vartype(mbristol) <> "N"
*	mbristol = 0
*Endif

If vartype(mbusca) = "N"
	mwhere = " tcu_tipifica=?mbusca "
Else
	mwhere = " 1=1 "
Endif

If vartype(mfiltro) <> "C"
	mfiltro = " TCU_idprovincia in (1,2) "
Endif

If vartype(mfiltro2) <> "C"
	mfiltro2 = ""
Endif

If used('mwkubicacion')
	Use in mwkubicacion
Endif

mfecnull = ctod("01/01/1900")

mwhere2 = mwhere + iif( len(alltrim(mfiltro))>0, " and " + mfiltro, "") +;
 iif( len(alltrim(mfiltro2))>0, " and " + mfiltro2, "")

mret = sqlexec(mcon1,"select tcu_nombre,tcu_localdes,descrip,tcu_direccion,tcu_telef,"+;
	"tcu_idprovincia,tcu_idcodpostal,tcu_idlocal,tabciamubica.id as lid,tcu_usofrec,"+;
	" tcu_tipifica, tcu_tipou, tcu_tipop, tcu_tipob, tcu_tipot,tcu_bristol "+;
	" from tabciamubica left join tabpcia1 on tabpcia1.id= tabciamubica.tcu_idprovincia "+;
	" where " + mwhere2 +;
	" and tcu_fecpasiva = ?mfecnull" +;
	" order by tcu_usofrec,tcu_nombre","mwkubicacion")

* iif(mbristol=1," and tcu_bristol=1 ","")+;

If mret < 0
	Messagebox("EN CONSULTA DE CENTROS ASISTENCIALES" + chr(10) +;
		"AVISE A SISTEMAS",16,"ERROR")
Endif
