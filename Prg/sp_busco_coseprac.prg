***
** busco valores de Coseguros
***
parameter lbaja,mtipopac,mentidad,mcontrato,mpla,mcre, mprest 
mfechapas = ctod("01/01/2100")
cbaja = ' 1=1 '
if type('lbaja')#"N"
	*cbaja = ' Fecha = ?mfechapas '
endif
*mbusco = " and TipoPac = ?mTipoPac " 
mbusco = ''
mbusco = mbusco + " and entidad  = ?mentidad "
mbusco = mbusco + " and Contrato = ?mcontrato "
mbusco = mbusco + " and credencial  = ?mcre "
mbusco = mbusco + " and Plan = ?mpla "
mbusco = mbusco + " and Prestacion = ?mprest "

mret = sqlexec(mcon1,  "select Contrato , Credencial , Entidad , Fecha , Plan , "+;
	" Prestacion , TipoAtenAmb"+;
	" from Coseprac "+;
	" where "+ cbaja + mbusco  ,'MwkCoseprac')

if mret < 0
	=aerr(eros)
	messagebox("ERROR AL BUSCAR LOS DATOS", 48, "Validacion")

endif

