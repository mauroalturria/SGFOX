public mcon1,mcon3
		do sp_conexion
		mcon3=mcon1
create table dbf_tablas (tabla c(50))
append from tablas.txt type sdf
create table dbf_produ (produ c(50))
append from PRODUREAL.TXT type sdf
select dbf_tablas
update dbf_tablas set tabla = upper(strtran(tabla,"User.",""))
update dbf_produ set produ = upper(strtran(produ ,"User.",""))

select * from dbf_tablas where tabla not in (select produ from dbf_produ) into cursor solo_tablas
select * from dbf_produ where produ not in (select tabla from dbf_tablas) into cursor solo_produreal

select * from dbf_tablas where tabla in (select produ from dbf_produ) into cursor tab_pro
select * from dbf_produ where produ in (select tabla from dbf_tablas) into cursor pro_tab
select pro_tab
set safety off
scan
	mtab = pro_tab.produ
	mret = sqlexec(mcon1, 'select top 1 *  from ' + mtab  ,"controla")
	if mret<1
		=aerr(eros)
		messagebox(eros(3))
	endif	
	select controla
	copy struct extend to ctrl_produ
	mret = sqlexec(mcon3, 'select top 1 *  from ' + mtab  ,"controla")
	if mret<1
		=aerr(eros)
		messagebox(eros(3))
	endif	
	select controla
	copy struct extend to ctrl_tabla
	
	use in 0 ctrl_produ 
	copy to array aprodu
	use in ctrl_produ 

	use in 0 ctrl_tabla
	copy to array atabla
	use in ctrl_tabla
	
	ntab = alen(atabla) 
	npro = alen(aprodu)
	if ntab # npro
		messagebox(mtab + " Difiere tablas " + transf(ntab)+ "  produreal " + transf(npro))
		set step on
	endif
	for i= 1 to ntab
		if atabla(i) # aprodu(i)
			messagebox(mtab + " tablas " + transf(atabla(i))+ "  produreal " + transf(aprodu(i)))
			set step on
		endif
	next 			
endscan

=sqldiscon(mcon1)
=sqldiscon(mcon3)
