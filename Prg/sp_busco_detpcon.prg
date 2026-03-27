*****************************************************
****** Busca conceptos existentes en presupuestos
*****************************************************
lparameters mbusco, mtodo

if vartype(mbusco)#"C"
	mbusco = ''
endif

if vartype(mtodo)#"L"
	mtodo = .f.
endif

if !mtodo
	if  INLIST(mwkexe.nomexe,'PISOS','PRESUPUESTOS','ADMISION')
		msec = " and sectorefec <> 'AMB' "
	else
		msec = " and sectorefec = 'AMB' "
	endif
else
	msec = ""
endif
mfecnull = ctod("01/01/1900")
msec = msec+" and (tabpresupuestos.fecpasiva is null or tabpresupuestos.fecpasiva = ?mfecnull) "
msec= msec+" and (tabpdetpresupuesto.fecpasiva is null or tabpdetpresupuesto.fecpasiva = ?mfecnull) "

mret = sqlexec(mcon1,"SELECT  TabPConce.palabraclave ,iddetp,TabPConce.concepto ,tabpdetpresupuesto.fecpasiva,tabpdetpresupuesto.fecpasiva "+;
	" FROM tabpresupuestos , tabpdetpresupuesto " +;
	" inner join TabPConce on tabpdetpresupuesto .idPreOCon = TabPConce.id  "+;
	" where  iddetp = tabpresupuestos.id "+ msec + mbusco,"mwkdetconcepto")
if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif
 
