***
** busco valores de Coseguros
***
parameter lbaja,mentidad,mcontrato, mtipopac,mtipoat,mcre,mpla
mfechapas = ctod("01/01/2100")
cbaja = ' 1=1 '
if type('lbaja')#"N"
 	cbaja = ' fechahasta = ?mfechapas '
endif

mbusco = " and TipoPac = ?mTipoPac " 
if mentidad  >0
	mbusco = mbusco + " and entidad  = ?mentidad "
endif
if mcontrato >0
	mbusco = mbusco + " and Contrato = ?mcontrato "
endif
if mtipoat >0
	mbusco = mbusco + " and TipoAten = ?mtipoat "
endif
mbusco = mbusco + " and credencial  = ?mcre "

mbusco = mbusco + " and Plan = ?mpla "
	
mret = sqlexec(mcon1,  "select Bono_Importe , Bono_Obligatorio , Cant_Prestaciones , "+;
	" Contrato , Coseguro , Credencial , Entidad , Fecha , Plan , Porcentaje_Contrato ,"+; 
	" Reintegro , Requiere_Autorizacion , Requiere_Credencial , Requiere_DNI , "+;
	" TipoAten , TipoPac , Ver_Contrato, fechahasta  from Coseguros "+;
	" where "+ cbaja + mbusco  ,'MwkCoseguro')

if mret < 0
	=aerr(eros)
	messagebox("ERROR AL BUSCAR LOS DATOS", 48, "Validacion")

endif

