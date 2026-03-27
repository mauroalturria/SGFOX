****
** busco datos de prestaciones
****

parameter mprest
if type('mprest') = "N"
	mret = sqlexec(mcon1,"select * from TabNutPrest " +;
			"where TNP_codPrest = ?mprest" ,"mwkTNPrest")
else
	mret = sqlexec(mcon1,"select * from TabNutPrest ","mwkTNPrest")
endif	
If mret<1
	=Aerr(eros)
	Messagebox (eros(2))
Endif