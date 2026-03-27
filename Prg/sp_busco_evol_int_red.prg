****
** Armo evolucion del paciente
****
parameter mnroadm


mret = sqlexec(mcon1, "SELECT ID, IH_admision, IH_codcie, IH_codestado, IH_codmed, IH_codmedcie,"+;
	" IH_fechaHoraIng, IH_horaCierre, IH_motIngreso, IH_procedencia,  IH_secagrup, IH_secuencia " +;
	" FROM TabintHCE "+;
	" where IH_admision = ?mnroadm ", "mwkEvolIntre")

if mret < 0
	=aerr(eros)
	messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
else
	select * from mwkEvolIntre ;
		group by IH_admision,IH_secuencia;
		order by id ;
		into cursor mwkEvolIntred

endif

