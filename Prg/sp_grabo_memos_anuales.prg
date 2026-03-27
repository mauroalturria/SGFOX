*
* Busqueda cantidad de memos por medico
*
Lparameters mmedi,manio,mtipo

If used('mwkmemosac')
	Use in mwkmemosac
Endif

mret = sqlexec(mcon1,"select  id,Anio , CantCont , Cantidad , IdMedico "+;
	" FROM TabMedCbio "+;
	"where idmedico = ?mmedi and anio = ?manio and CantCont = ?mtipo","mwkmemosctrl")

If mret < 0
	=Aerror(merror)
	Messagebox("EN BUSQUEDA DE MEMOS "+CHR(10)+;
		merror(3)+CHR(10)+;
		"NOTIFIQUE EL ERROR",16,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
go top
mcant = mwkmemosctrl.cantidad+1
mid = mwkmemosctrl.id
if reccount('mwkmemosctrl')>0
	mret = sqlexec(mcon1,"update TabMedCbio set Cantidad = ?mcant "+;
		" where id = ?mid")
else
	mret = sqlexec(mcon1,"insert into TabMedCbio "+;
	"(Anio, CantCont, Cantidad, IdMedico) "+;
	" values (?manio,?mtipo,1,?mmedi)")

endif
If mret < 0
	=Aerror(merror)
	Messagebox("EN BUSQUEDA DE MEMOS "+CHR(10)+;
		merror(3)+CHR(10)+;
		"NOTIFIQUE EL ERROR",16,"ERROR")
		
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
