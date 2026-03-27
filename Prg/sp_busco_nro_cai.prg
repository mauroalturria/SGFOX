****
** Busco nro de cai y fecha de vto del cai para facturas
****

parameter mptovta,mtipo,mletra,mfecha


if type('mptovta')#"C"
	mptovta = transf(mptovta,"@L 9999")
endif
if mptovta="0005"
	mptovta="0004"
endif
if type('mtipo')#"C"
	mtipo = 'FC'
endif

if type('mletra')#"C"
	mletra = 'B'
endif
if type('mfecha')#"D"
	mfecha = sp_busco_fecha_serv('DD')
endif
mret = sqlexec(mcon1, "select nrocai, fecvigh as fecvto , ptovta from NroCAI " + ;
	" where ptovta = ?mptovta and tipocte = ?mtipo " +;
	" and fecvigd <= ?mfecha  and fecvigh >= ?mfecha " +;
	" and letra = ?mletra ", "mwkcai")

if mret < 0
*!*		messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE", 16,"Validacion")
*!*		do prg_cancelo
endif
if reccount('mwkcai')=0
*!*		messagebox("NO SE PUDO OBTENER EL CAI. AVISAR A SISTEMAS", 16,"Validacion")
*!*			=sqldisconnect(mcon1)
*!*			cancel
endif

