****
** Actualizo nro de registracio por unificacion en datos generales
***

parameter nroregistra, newregistra
mret = prg_ejecutosql1("update TabRegDatos set TRDA_Registracio = ?newregistra " + ;
	"where TRDA_Registracio = ?nroregistra")

mret = prg_ejecutosql1("update TabRegDocu set TRD_Registracio = ?newregistra " + ;
	"where TRD_Registracio = ?nroregistra")

mret = prg_ejecutosql1("update TabRegFoto set TRF_Registracio = ?newregistra " + ;
	"where TRF_Registracio = ?nroregistra")

mret = prg_ejecutosql1("update TabRegTel set TRT_Registracio = ?newregistra " + ;
	"where TRT_Registracio = ?nroregistra")
*
*   Vip
*
if used('mwktpvn')
	use in mwktpvn
endif
mret = prg_ejecutosql1("select * from TabPacVip Where TPV_NroReg = ?newregistra","mwktpvn")
if mret < 0
	messagebox('LOCALIZACION DE REGISTROS EN CURSOR - Unificacion -',0,'ERROR')
	return
endif
if reccount('mwktpvn') = 0
mret = prg_ejecutosql1("update TabPacVip set TPV_NroReg = ?newregistra "+;
		"where TPV_NroReg = ?nroregistra")
	if mret < 0
		messagebox('ACTUALIZACION DE REGISTROS - Unificacion -',0,'ERROR')
		return
	endif
endif

mret = prg_ejecutosql1("update Tabambonco set TAO_registracio = ?newregistra " + ;
	"where TAO_registracio = ?nroregistra")

mret = prg_ejecutosql1( "update Tabderivasal set nroregistrac = ?newregistra " + ;
	"where nroregistrac = ?nroregistra")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR FACTURAS, AVISAR A SISTEMAS",16, "Validacion")
endif
mret = prg_ejecutosql1( "update Tabderivacion set nroregistrac = ?newregistra " + ;
	"where nroregistrac = ?nroregistra")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR FACTURAS, AVISAR A SISTEMAS",16, "Validacion")
endif

mret = prg_ejecutosql1( "update TabProtocolo set tpregistrac = ?newregistra " + ;
	"where tpregistrac= ?nroregistra")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR FACTURAS, AVISAR A SISTEMAS",16, "Validacion")
endif
mret = prg_ejecutosql1("update Tabaccesodatos set Registro = ?newregistra " + ;
	"where Registro = ?nroregistra")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR FACTURAS, AVISAR A SISTEMAS",16, "Validacion")
endif

mret = prg_ejecutosql1( "update Tablgdema set TLD_nroregistrac = ?newregistra " + ;
	"where TLD_nroregistrac = ?nroregistra")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR FACTURAS, AVISAR A SISTEMAS",16, "Validacion")
endif
mret = prg_ejecutosql1("update Tablghce set TLH_nroregis = ?newregistra " + ;
	"where TLH_nroregis = ?nroregistra")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR FACTURAS, AVISAR A SISTEMAS",16, "Validacion")
endif
mret = prg_ejecutosql1("update Tablgincadp set TIP_nroregistrac = ?newregistra " + ;
	"where TIP_nroregistrac = ?nroregistra")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR FACTURAS, AVISAR A SISTEMAS",16, "Validacion")
endif
mret = prg_ejecutosql1("update Tabquirofano set Nroregistrac = ?newregistra " + ;
	"where Nroregistrac = ?nroregistra")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR FACTURAS, AVISAR A SISTEMAS",16, "Validacion")
endif
mret = prg_ejecutosql1("update Tabquirofanolog set Nroregistrac = ?newregistra " + ;
	"where Nroregistrac = ?nroregistra")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR FACTURAS, AVISAR A SISTEMAS",16, "Validacion")
endif
mret = prg_ejecutosql1("update Tabregadvmed set TRAM_registracio = ?newregistra " + ;
	"where TRAM_registracio = ?nroregistra")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR FACTURAS, AVISAR A SISTEMAS",16, "Validacion")
endif
mret = prg_ejecutosql1("update Tabregobs set TRO_Registracio = ?newregistra " + ;
	"where TRO_Registracio = ?nroregistra")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR FACTURAS, AVISAR A SISTEMAS",16, "Validacion")
endif
mret = prg_ejecutosql1("update TabFarmCitosP set TCP_registracio = ?newregistra " + ;
	"where TCP_registracio = ?nroregistra")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR FACTURAS, AVISAR A SISTEMAS",16, "Validacion")
endif
mret = prg_ejecutosql1("update TabFarmPlan set TFP_registracio = ?newregistra " + ;
	"where TFP_registracio = ?nroregistra")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR TURNOS, AVISAR A SISTEMAS",16, "Validacion")
endif
mret = prg_ejecutosql1("update TabFarmApto set TFA_registracio = ?newregistra " + ;
	"where TFA_registracio = ?nroregistra")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR TURNOS, AVISAR A SISTEMAS",16, "Validacion")
endif
mret = prg_ejecutosql1("update TabRegRCV  set TRR_registracio = ?newregistra " + ;
	"where TRR_registracio = ?nroregistra")

if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR REGISTRO RCV, AVISAR A SISTEMAS",16, "Validacion")
endif
mret = prg_ejecutosql1("update Tabcuidomsoli set TCS_nroregistrac = ?newregistra " + ;
	"where TCS_nroregistrac = ?nroregistra")

if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR Cuidados domiciliarios AVISAR A SISTEMAS",16, "Validacion")
endif
mret = prg_ejecutosql1("update Tabpqx set PQ_registracio = ?newregistra " + ;
	"where PQ_registracio = ?nroregistra")

if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR preqx, AVISAR A SISTEMAS",16, "Validacion")
endif
mret = prg_ejecutosql1("update Tabsolpract set ASP_nroregistrac = ?newregistra " + ;
	"where ASP_nroregistrac = ?nroregistra")

if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR preqx, AVISAR A SISTEMAS",16, "Validacion")
endif
*TabAutPrevias 