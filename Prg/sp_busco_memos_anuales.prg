*
* Busqueda cantidad de memos por medico
*
Lparameters mmedi,manio

If used('mwkmemosac')
	Use in mwkmemosac
Endif

mret = sqlexec(mcon1,"select  Anio , CantCont , Cantidad , IdMedico "+;
	" FROM TabMedCbio where idmedico = ?mmedi and anio >= ?manio ","mwkmemos")

If mret < 0
	=Aerror(merror)
	Messagebox("EN BUSQUEDA DE MEMOS "+CHR(10)+;
		merror(3)+CHR(10)+;
		"NOTIFIQUE EL ERROR",16,"ERROR")
else
	select Anio , sum(Cantidad) as Cantidad ;
		from mwkmemos group by IdMedico,Anio  ;
		where inlist(cantcont,1,2) ;
		order by anio into cursor mwkmemosac
Endif

