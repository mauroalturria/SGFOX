*
* Registro de Admision en Maestro HCI Historias Anteriores
*
Parameters mhclinica, mcodadm, mfecadm, mfecalta, mlcodent, mregistracion, motivoalta
* mnombre, 

mret = sqlexec(mcon1,"insert into TabHciAdm"+;
	" (adm_codhce, adm_nroadm, adm_fechaadm, adm_fechaalta, adm_codent, adm_registrac, adm_motivoalta)"+;
	" values (?mhclinica, ?mcodadm, ?mfecadm, ?mfecalta, ?mlcodent, ?mregistracion, ?motivoalta)")
	
	*adm_nombrepac, 
	*?mnombre, 

If mret < 0
	=aerror(merror)
	Messagebox("EN REGISTRO DE HISTORIAS ANTERIORES"+chr(10)+;
		alltrim(merror(3)),16,"ERROR")
Endif



