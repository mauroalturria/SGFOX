****
** busco usuarios en OAUSER
****

Parameter mBuscar

If Vartype(mBuscar)#"C"
	mBuscar = "1=1"
Endif 

mret = sqlexec(mcon1, 'Select * ' + ;
	'from OAUSER ' + ;
	'Where ' + mBuscar + ;
	'order by apeynom', 'mwkoauser')

If mret <= 0
	=aerr(eros)
	Messagebox(eros(2))
	Cancel
Endif

