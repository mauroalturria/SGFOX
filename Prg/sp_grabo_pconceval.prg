****
** Grabo Conceptos
****
Lparameters mdesc,nvalor,mabm,mid  &&,mclave,mclase,mtipo
If mabm = 1
	mid=0
Endif


mfpasiva = Ctot("01/01/1900")
Do Case
Case mabm = 1   		&& Alta
	mret = SQLExec(mcon1, "SELECT id FROM TabPExcedente  where DescripExce = ?mdesc " , "mwkcontrol")
	If Reccount()>0
		Messagebox('CONCEPTO EXISTENTE',48,'Validacion')
	Else
		mret = SQLExec(mcon1, "insert into TabPExcedente (DescripExce ,ValorExcede)"+;
			" values(  ?mdesc, ?nvalor)")
	Endif
Case mabm = 2
	mret = SQLExec(mcon1, "SELECT id FROM TabPExcedente  where DescripExce = ?mdesc "+;
		"and id <> ?mid " , "mwkcontrol")
	If Reccount() >0
		Messagebox('CONCEPTO EXISTENTE',48,'Validacion')
	Else
		mret = SQLExec(mcon1, "update TabPExcedente  set DescripExce = ?mdesc, ValorExcede = ?nvalor "+;
			" where id=?mid ")
	Endif
Case mabm = 3
	mfpasiva 	= sp_busco_fecha_serv('DD')
	mret = SQLExec(mcon1, "update TabPExcedente  set fechapas = ?mfpasiva where id=?mid ")
Endcase
If mret < 0
	=Aerr(eros)
	Messagebox(eros(3))
	Messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
Endif

