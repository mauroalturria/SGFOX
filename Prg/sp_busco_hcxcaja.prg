*********************************************************************************
* BUSCA caja                                                  *
*********************************************************************************
lparameters mHC

mret = sqlexec(mcon1," SELECT pac_nombrepaciente ,caja,digito "+;
	"  FROM pacientes " + ;
	"  left join TabHCIArchivo ON TabHCIArchivo.hci_nroAdm = pacientes.pac_codadmision " +;
	"  inner join TabHCIcajas ON TabHCIcajas.id = TabHCIArchivo.hca_orden " +;
	"  WHERE hca_orden <> 0  and pac_codhce =?mHC and pac_motivoalta = 6 ", "mwkHCCajaBiz" )

if mret < 0
*!*	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	cancel
endif
