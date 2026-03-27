do sp_conexion
mfecdes = ctod("01/11/2012")
mfechas = ctod("30/11/2012")
Create cursor dias (fechatur D,diasem n,mes n(2) )
For i = 0 to mfechas - mfecdes
	mdias = mfecdes + i
	mret=sqlexec(mcon1,"SELECT dia FROM feriaturnosA WHERE dia =?mdias",'MWKFeriados')
	If reccount('MWKFeriados')=0 and dow(mdias) > 1
		Insert into dias ( fechatur,diasem,mes  ) values ( mdias, dow(mdias),month(mdias) )
	Endif
Next
select count(*),* from dias group by diasem,mes into cursor cantdia
copy to dias3 type xls

do sp_desconexion