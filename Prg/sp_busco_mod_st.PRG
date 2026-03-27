*
* Busqueda de Modelo
*
Parameters mid

lcWhere = IIF(EMPTY(mid ),''," where id =?mid ")

mret =	sqlexec(mcon1,"select * from tabstmod  " +lcWhere +" order by descr  ","mwkMod")

If mret<1
	=aerror(merror)
	Messagebox("EN BUSQUEDA DE MODELOS DE PUESTOS"+chr(10)+;
	merror(3)+chr(10)+;
	"AVISE A SISTEMAS",16,"ERROR")
Else
	If len(alltrim(lcWhere))>0
		Select mwkmod
		mlmodelo = mwkmod.descr
		return mlmodelo
	Endif
Endif
