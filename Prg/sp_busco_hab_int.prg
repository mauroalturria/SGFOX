*!*	HABITACIONES DE SECTORES DE INTERNACION
*!*	-----------------------------------------------------------
LPARAMETERS csector
mbus = ''
IF VARTYPE(csector)='C'
mbus = " where Sec_CodSector='"+ALLTRIM(csector)+"' "	
endif
mret = sqlexec(mcon1, "select hab_codhabitacion, hab_codcama, hab_codpaciente, hab_codbloqueo, " + ;
	"hab_habilitada, pac_nombrepaciente, pac_sexo, pac_edad, " + ;
	"pac_descripdiagn, pac_categoria, pin_codentidad, " + ;
	"sec_habitsala, Sec_CodSector, Sec_DescripSec " + ;
	"from habitacions " + ;
	"Inner Join Sectores on habitacions.hab_sectores = Sectores.Sec_CodSector and Sec_Internacion = 1 " + ;
	"left outer join pacientes on habitacions.hab_codpaciente = pacientes.pac_codadmision " + ;
	"left outer join pacinternad on pacinternad.pin_codadmision = pacientes.pac_codadmision " + ;
	"order by hab_codhabitacion, hab_codcama", "mwkcama0")

If mret <= 0 
	MessageBox("ERROR EN LA LECTURA DE LOS DATOS",48,"VALIDACION")
	Return .f.
Endif 
