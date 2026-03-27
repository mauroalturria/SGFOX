****
** Busco nro de cai y fecha de vto del cai para facturas
****

	
	mret = sqlexec(mcon1, "insert into tabcai "+; 
	"(fecvigend,fecvigenh,fecvto,nrocai,ptovta,tipocte,letra ) "+; 
	" values"+; 
	" (to_date('22/01/2004','dd/mm/yyyy'),to_date('22/01/2006','dd/mm/yyyy')"+; 
	" ,to_date('22/01/2006','dd/mm/yyyy'),24006140247554,4,'NC','B')" )
	
	if mret < 0
		=AERR(EROS)
		messagebox(EROS(2))
	endif

