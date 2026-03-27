****
** busco prestaciones incluidas en un vector
****

Parameter mingred,mtipo,nsinorden
If Type ('mtipo')#"N"
	mtipo=0
Endif
If Vartype(norden)<>"N"
	norden = 0
Endif
corden = ''
If norden = 0
	corden = ' pre_alimenticio, '
Endif
mfecnul = Ctod("01/01/1900")
mret = SQLExec(mcon1,"select PRE_descriprest, PRE_codprest ,pre_alimenticio " + ;
	" FROM prestacions "+;
	" left join TabNutPrest on prestacions.PRE_codprest = TabNutPrest.TNP_codPrest " + ;
	" where TNP_dieta < 9 and PRE_codservicio=9400  and PRE_fechapasiva is null and not  pre_alimenticio is null "+;
	" and pre_especialidad in ('NUTR','DIAB') and PRE_codprest not in (select TNC_codprest from TabNutComp " +;
	" where TNC_idIngr = ?mingred and TNC_fecPasiva = ?mfecnul and TNC_tipo = ?mtipo) order by &corden PRE_descriprest " , "mwkprestSC")

If mret<1
	=Aerr(eros)
	Messagebox(eros(3))
Endif

mret = SQLExec(mcon1,"select PRE_descriprest, PRE_codprest,pre_alimenticio " + ;
	" FROM prestacions "+;
	" left join TabNutPrest on prestacions.PRE_codprest = TabNutPrest.TNP_codPrest " + ;
	" where TNP_dieta < 9 and PRE_codservicio=9400 and PRE_fechapasiva is null and not  pre_alimenticio is null "+;
	" and pre_especialidad in ('NUTR','DIAB') and PRE_codprest in (select TNC_codprest from TabNutComp " +;
	" where TNC_idIngr = ?mingred and TNC_fecPasiva = ?mfecnul and TNC_tipo = ?mtipo) order by  &corden PRE_descriprest " , "mwkprestNC")

If mret<1
	=Aerr(eros)
	Messagebox(eros(3))
Endif
