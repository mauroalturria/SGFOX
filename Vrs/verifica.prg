public mcon1
do sp_conexion

mdes = ctot("16/12/2005")
mret = SQLEXEC(mcon1,"SELECT ID,afiliado,codigo,fechatomado,turnoid,usuario FROM TurnosAudit"+;
		" where fechatomado>=?mdes ","audit") 
if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif 
create table audita (fechaha t,fechahs t,dife n(4) )
select audit
mfa= fechatomado 
do while !eof()
	if fechatomado - mfa>600 and fechatomado - mfa<10000 
		wait windows (transf(fechatomado - mfa,"9999")+"--"+ttoc(fechatomado)+" - "+ttoc(mfa)) nowait
		insert into audita(fechaha ,fechahs ,dife) ;
			values ( audit.fechatomado,mfa,round((audit.fechatomado - mfa)/60,0) )
	endif			
	mfa= fechatomado 
	skip
enddo
=sqldiscon(mcon1)
