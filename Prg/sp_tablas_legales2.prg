*
* Tablas legales
*
Use in select("mwkestados")
mret = sqlexec(mcon1,"select descrip as lestado, subestado as lidestado, tipo"+;
	" from TabEstados where propietario=37 "+;
	" and estado=8 order by subestado","mwkestados")

If mret < 0
	Messagebox("EN CONSULTA, LEGALES ESTADOS DE H.C.E. SOLICITUD DE IMPRESION"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Use in select("mwkCiap2e")
mret = sqlexec(mcon1, "select  ID , Codigo , Componente , Criterio , "+;
	"DescrAbrev , Descripcion , Excluye , Incluye "+;
	" from  TabCiap2E  ", "mwkCiap2e")

If mret < 0
	Messagebox("EN CONSULTA, TABLAS CIAP"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Use in select("mwkentexg")
mret = sqlexec(mcon1, "select fecpasiva,codent as codentexc,tpopac  from entidexclu "+;
	"where tpopac = 'GUA' union select fecpasiva,codent as codentexc,tpopac  from entidexclu "+;
	"where tpopac = 'INT' and codent not in ( select codent from entidexclu "+;
	"where tpopac = 'GUA')","mwkentexg")

If mret < 0
	Messagebox("EN CONSULTA ENTIDADES EXCLUSIVAS"+chr(10)+;
		"AVISE A SISTEMAS",16, "ERROR")
	Do log_errores with error(), message(), message(1), program(), lineno()
	Return .F.
Endif

Return .T.


