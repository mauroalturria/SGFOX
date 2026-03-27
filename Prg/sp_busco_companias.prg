*
* Companías aseguradoras
*

mfnull = ctod("01/01/1900")

If used('mwkaseg')
	Use in mwkaseg
Endif

mret = sqlexec(mcon1,"select *,id as lid from TabLGAseg where "+;
" TLA_fecpasiva = ?mfnull and TLA_tipo2 = 1 order by TLA_tipo","mwkaseg")

If mret < 0
	=aerror(merror)
	Messagebox("EN LA TABLA ASEGURADORAS"+chr(10)+;
		alltrim(merror(3))+chr(10)+;
		", AVISE A SISTEMAS",16,"ERROR")
Endif
