
*
* Graba movimiento enviado a baja en TabHCIAbaja
*

Lparameters mcadm,mfalt,mcbar,mesta,mmotf,morde,mregi,mreim,muser

mret = sqlexec(mcon1,"insert into TabHCIAbaja (hca_fechaAlta,hca_codBarra,hca_estado,"+;
	"hca_motFalta,hca_orden,hca_registrac,hca_reimprime,hca_usuario,hci_nroAdm)"+;
	" values (?mfalt,?mcbar,?mesta,?mmotf,?morde,?mregi,?mreim,?muser,?mcadm)")

If mret < 0
	Messagebox("EN REGISTRO DEL MOVIMIENTO EN MAESTRO DE BAJAS"+chr(10)+;
		"AVISE A SISTEMAS",16,"Validación")
		
	=aerror(merror)
	
	Messagebox(merror(3),16,"ERROR")
		
		
		
Endif
