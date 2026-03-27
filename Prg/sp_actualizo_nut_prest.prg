****
** actualizo datos de prestaciones
****

parameter  mabm, mdieta, mcodfact, mtipo,mfactura

do case
case mabm = 1		&& Alta
	mret= sqlexec(mcon1," insert into TabNutPrest"+;
		"(TNP_codPrest ,TNP_codFactu ,TNP_Dieta ,TNP_factura  ) " + ;
		" values ( ?mdieta, ?mcodfact, ?mtipo,?mfactura )" )

case mabm = 2		&&& Modifica

	mret= sqlexec(mcon1," Update TabNutPrest set TNP_codFactu = ?mcodfact"+;
		", TNP_Dieta  = ?mtipo, TNP_factura = ?mfactura " + ;
		" where TNP_codPrest = ?mdieta ")

endcase

if mret < 0
	messagebox('NO SE ACTUALIZO.  REINTENTE', 16, 'Validacion')
	mret = 0
endif