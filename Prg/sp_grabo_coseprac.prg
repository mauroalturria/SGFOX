***
** busco valores de Coseguros
***
parameter mopcion,mtipopac,mentidad,mcontrato,mpla,mcre, mprest ,mtipo
mfechapas = ctod("01/01/2100")
mfecha = ttod(mwkfecserv.fechahora)
mifecha = date(year(mfecha ),month(mfecha ),1)
mbusco = " TipoPac = ?mTipoPac " 
mbusco = mbusco + " and entidad  = ?mentidad "
mbusco = mbusco + " and Contrato = ?mcontrato "
mbusco = mbusco + " and credencial  = ?mcre "
mbusco = mbusco + " and Plan = ?mpla "
mbusco = mbusco + " and Prestacion = ?mprest "
mret = sqlexec(mcon1,  "insert into Coseprac ( Contrato , Credencial , Entidad , Fecha , "+;
	" Plan , Prestacion , TipoAtenAmb) values (?mcontrato ,?mcre, ?mentidad, ?mfecha, "+;
	" ?mpla, ?mprest,?mtipo )")
if mret < 0
	=aerr(eros)
	messagebox("ERROR AL BUSCAR LOS DATOS", 48, "Validacion")

endif

