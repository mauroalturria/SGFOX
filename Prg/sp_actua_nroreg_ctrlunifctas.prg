****
** Actualizo datos de control de pasaje de cuentas
***
parameter mcuenta,mcuentad,mfecha,mhcdes,mhcori  
mfechaproc	= sp_busco_fecha_serv('DT')
musuario 	= mwkusuario.codigovax
mret = sqlexec(mcon1, "insert into TabCtrlUnifCtas ( CUV_Cuenta , CUV_CuentaD , "+;
	"CUV_Fecha , CUV_FechaProc , CUV_NrohclinicaD , CUV_NrohclinicaO, CUV_Usuario ) values  "+;
	"( ?mcuenta, ?mcuentad, ?mfecha, ?mfechaproc, ?mhcdes, ?mhcori, ?musuario)")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL ACTUALIZAR CONTROL, AVISAR A SISTEMAS",16, "Validacion")
endif
