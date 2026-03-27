*
* Listado ATM Kinesio
*
LPARAMETERS mfecha
use in select("mwkatm")

mret = sqlexec(mcon1,"SELECT Pacientes.PAC_codadmision, Pacientes.PAC_nombrepaciente,"+;
	" Pacientes.PAC_habitacion, Pacientes.PAC_cama,PAC_descripdiagn,"+;
	" Valesasist.VAL_fechasolicitud, Pacientes.PAC_sectorinternac,"+;
	" Sectores.SEC_habitsala,pre_descriprest,val_observaciones,val_codpun "+;
	" FROM Pacinternad,Pacientes, "+;
	" Valesasist, Presinsuvas, Sectores, Prestacions"+;
	" WHERE Pacientes.PAC_codadmision = Pacinternad.PIN_codadmision"+;
	" AND Pacientes.PAC_codadmision = Valesasist.VAL_codadmision"+;
	" and Presinsuvas.PIA_VALESASIST = Valesasist.VALESASIST "+;
	" and Presinsuvas.PIA_codprest = Prestacions.PRE_codprest "+;
	" AND Pacientes.PAC_sectorinternac = Sectores.SEC_codsector"+;
	" AND Valesasist.VAL_codservvale = 7600 and VAL_fechasolicitud>=?mfecha " +;
	" order by Valesasist.VALESASIST ","mwkatm01")

if mret < 0
	do log_errores with error(), message(), message(1), program(), lineno()
	return .f.
endif
mret = sqlexec(mcon1,"SELECT Pacientes.PAC_codadmision, Pacientes.PAC_nombrepaciente,"+;
	" Pacientes.PAC_habitacion, Pacientes.PAC_cama,PAC_descripdiagn,"+;
	" EIK_fechaHora , EIK_idevol , EIK_tipo , Pacientes.PAC_sectorinternac,"+;
	" Sectores.SEC_habitsala "+;
	" FROM Pacientes "+;
	" inner join Pacinternad on pin_codadmision  = Pacientes.PAC_codadmision " + ;
	" inner join TabintHCE on pin_codadmision  = tabintHCE.IH_admision " + ;
	" inner join TabIntEvolKine on TabIntEvolKine.EIK_idevol  = tabintHCE.id " + ;
	" inner join Sectores  on Pacientes.PAC_sectorinternac = Sectores.SEC_codsector " + ;
	" WHERE  EIK_fechaHora >=?mfecha " +;
	" group by PAC_codadmision,EIK_tipo  ","mwkatm02")

return .t.
