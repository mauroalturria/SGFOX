lparameters lcIpServer

mfecnull = ctod("01/01/1900")

mret = sqlexec(mcon1,"select Top 1 Tabllamador.*, " + ;
	"Reg_nombrepac as LLA_nombrepac " + ;
	"from Tabllamador " + ;
	"Left Join Registracio on Registracio.Reg_NroRegistrac = Tabllamador.LLA_nroregistrac " + ;
	"where LLA_IpServer = ?lcIpServer " + ;
	"and LLA_fechapant = ?mfecnull " + ;
	"", "mwkllamado")

if mret <= 0
	aerror(eros)
	Do prg_error_SQL("ERROR DE LECTURA")
	return .F.
endif 

miresp = ''
do sp_busco_datos_registracio with mwkllamado.LLA_nroregistrac
if empty(miresp)
*!*		miresp = "c:\DesaGuemes\Bmp\sin_imagen.jpg" && si hay una imagen cuando no tenga
endif 

select *, miresp as LLA_Imagen ;
	from mwkllamado ;
	into cursor mwkllamado

