*
* Busca ID Profesional del maestro C.D. Asignación de Progesionales
*
Lparameters mlidpro, mlidcdo

Use In Select("mwkidapro")

mret = SQLExec(mcon1,"SELECT id as lid"+;
	" FROM TabCuiDomPasig"+;
	" where TCA_idsolic = ?mlidcdo"+;
	" and TCA_idprofe = ?mlidpro","mwkidapro")

If mret  < 0
	MTABLA = "C.D. CONSULTA PROFESIONALES ASIGNADOS AGENDA"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Return .T.
