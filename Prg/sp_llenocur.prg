msql =" Select elegido,reg_nrohclinica, pacientes, pac_fechaalta, "+;
							"  pac_nombrepaciente, mte_descripcion, "+;
							"  pac_fechaadmision, pac_motivoalta ,hca_estado "+;
							"  from mwkhistoria Group by reg_nrohclinica, pacientes "+;
							"  order by reg_nrohclinica, pacientes, pac_fechaalta "
							
	mret = sqlexec(mcon1, msql , 'Mwkhist')
	if mret < 0 
  		MESSAGEBOX("ERROR AL CREAR EL CURSOR, REINTENTE", 16, "Validación")
   		do prg_cancelo
	endif 