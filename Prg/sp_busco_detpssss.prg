*****************************************************
****** Busca prestaciones existentes en presupuestos
*****************************************************
lparameters mbusco

if vartype(mbusco)#"C"
	mbusco = ''
endif
msec = " and sectorefec = '"+iif(mwkexe.nomexe='PRESUPUESTOS','FAC','AMB')+"' "

mret = sqlexec(mcon1,"SELECT  pre_codprest,iddetp,pre_descriprest "+;
	" FROM tabpresupuestos , tabpdetpresupuesto " +;
	" left join prestacions on tabpdetpresupuesto.idpreocon = prestacions.pre_codprest " +;
	" where tipopres = 2 and iddetp = tabpresupuestos.id "+ msec + mbusco,"mwkdetprestacion")

if mret < 0
	messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
endif
