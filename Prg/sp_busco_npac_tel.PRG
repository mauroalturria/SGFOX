*
* Busqueda de datos ( Nombre/HC de Pacientes y telefono ) x Cod. Adm.
*
Parameters mcodigo

mret = sqlexec(mcon1,"select PAC_nombrepaciente, PAC_codhci, Pac_CodHce, " +;
		" Nvl(REG_telefonos,'') as REG_telefonos " +;
		"from pacientes " + ;
		"left join Registracio on Registracio.REG_nroregistrac = pacientes.PAC_codhci " + ;
		"where PAC_codadmision = ?mcodigo","mwkpacnom")

If mret <= 0
	Messagebox("ERROR DE LECTURA DE PACIENTES",26,"ERROR")
*	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif 	
 


