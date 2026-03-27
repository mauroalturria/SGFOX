*
* Cuidados Domiciliarios Tablas
*

Use In Select("mwkFamiliar")
mret = SQLExec(mcon1,"select * from TabFamiliar where TFM_relacion = 0", "mwkFamiliar")

If mret < 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA PARENTESCOS"+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

*If !Used("mwkCiap2e")

Wait "Códigos CIAP" Window Timeout 1

Use In Select("mwkTCiapCap")
Use In Select("mwkTCiapCom")
**Use In Select("mwkCiap2e")

mret = SQLExec(mcon1, "select ID , Capitulo , Letra from TabCiapCap", "mwkTCiapCap")

If mret < 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA CODIGOS CIAP"+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

mret = SQLExec(mcon1, "select ID , Nombre  from TabCiapCom", "mwkTCiapCom")

If mret < 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA CIAPCOM"+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

If !Used("mwkCiap2e")
	mret = SQLExec(mcon1, "select  ID , Codigo , Componente , Criterio , "+;
		"DescrAbrev , Descripcion , Excluye , Incluye "+;
		" from TabCiap2E order by DescrAbrev", "mwkCiap2e")
Endif

If mret < 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA CIAP"+Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

*Endif

Return .T.
