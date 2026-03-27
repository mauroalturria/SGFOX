*****************************************************
****** Busca prestaciones existentes en presupuestos
*****************************************************
Lparameters mbusco, mtodo,mpasivo

If Vartype(mbusco)#"C"
	mbusco = ''
Endif
If Vartype(mpasivo)#"N"
	mpasivo = 0
Endif

If Vartype(mtodo)#"L"
	mtodo = .F.
Endif

If !mtodo
	If  Inlist(mwkexe.nomexe,'PISOS','PRESUPUESTOS','ADMISION')
		msec = " and sectorefec <> 'AMB' "
	Else
		msec = " and sectorefec = 'AMB' "
	Endif
Else
	msec = ""
Endif

mfecnull = Ctod("01/01/1900")
msec = msec+" and (tabpresupuestos.fecpasiva is null or tabpresupuestos.fecpasiva = ?mfecnull) "
If mpasivo =0
	msec= msec+" and (tabpdetpresupuesto.fecpasiva is null or tabpdetpresupuesto.fecpasiva = ?mfecnull) "
Endif
mret = SQLExec(mcon1,"SELECT  pre_codprest,iddetp,pre_descriprest,tabpdetpresupuesto.fecpasiva "+;
	" FROM tabpresupuestos , tabpdetpresupuesto " +;
	" left join prestacions on tabpdetpresupuesto.idpreocon = prestacions.pre_codprest " +;
	" where tipopres = 2 and iddetp = tabpresupuestos.id "+ msec + mbusco,"mwkdetprestacion")
If mret < 0
	Messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
Endif

