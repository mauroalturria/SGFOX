public mcon1
a=e
set step on
do sp_conexion

mret = sqlexec(mcon1, "select id, codmed, diasem, horadesde, horahasta, " + ;
							"hdesde1, hhasta1 from medpresta " + ;
							"where diasem is not null " + ;
							"order by id", "mwkaa")


do while !eof('mwkaa')

	mid	 	= mwkaa.id
	mcodmed	= mwkaa.codmed
	mhdesde = mwkaa.horadesde
	mhhasta = mwkaa.horahasta
	
	mret = sqlexec(mcon1, "update medpresta set hdesde1 = ?mhdesde, hhasta1 = ?mhhasta " + ;
							"where id = ?mid and codmed = ?mcodmed")

	skip 1 in mwkaa
	
enddo