select properties from launcher03 where class="container" into cursor conts

select conts
scan
	nlineas = alines(mima,conts.properties)
	lind = ascan(mima,"Picture")
	if lind>0
		mico = alltrim(mima(lind))
		mico = substr(mico,17)
		mico = substr(mico,1,len(mico)-2)
		select acce
		replace icono with mico
	else
		lind = ascan(mima,"Name = ")
		if lind>0
			mname = alltrim(strtran(mima(lind),'Name = "',""))
			mname = substr(mname ,1,len(mname )-1)
			insert into acce (nombre,icono) values(mname,'')
		endif
	endif
	select conts
endscan
select acce
scan
 miexe = upper(nombre)
 mico = icono
 update tabexe350 set icono = mico where nomexe = miexe
endscan