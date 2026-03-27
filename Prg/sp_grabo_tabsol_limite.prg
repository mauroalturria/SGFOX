Parameters mabm,tnreg,tncodesp,tnlimite,nmedi,mid,mlimitenuevo

If Vartype(mid)<>"N"
	mid = 0
Endif
If Vartype(mlimitenuevo)<>"N"
	mlimitenuevo= 0
Endif
tnfec = sp_busco_fecha_serv("DD")

Do Case
Case mabm = 1 &&&alta
	lcSql = " SELECT  id,SL_cantidad,SL_limite "+;
		" FROM ZabSolLimite where SL_nroregistrac = ?tnreg and SL_codesp =?tncodesp "+;
		" and SL_cantidad <SL_limite  "

	If !Prg_EjecutoSql(lcSql,"Mwksollimite",.F.)
*Return 0
	Endif
	If Reccount('Mwksollimite')=0
		lcSql = " insert into ZabSolLimite (SL_cantidad , SL_codesp , SL_codmedSol , SL_fechasol , SL_limite , SL_nroregistrac) "+;
			" values (0,?tncodesp, ?nmedi,?tnfec , ?tnlimite, ?tnreg ) "

		If !Prg_EjecutoSql(lcSql,"",.F.)
			Messagebox("no se pudo grabar el limite por especialidad",16,"Informe a SISTEMAS")
			Return 0
		Endif
	Else
		mid = Mwksollimite.Id
		milim = Mwksollimite.SL_limite
		If tnlimite>milim &&si autoriza un MF anula anterior e inicia uno nuevo

			lcSql = " update  ZabSolLimite set SL_cantidad = ?tnlimite  where id = ?mid "

			If !Prg_EjecutoSql(lcSql,"",.F.)
*	Return 0
			Endif
			lcSql = " insert into ZabSolLimite (SL_cantidad , SL_codesp , SL_codmedSol , SL_fechasol , SL_limite , SL_nroregistrac) "+;
				" values (0,?tncodesp, ?nmedi,?tnfec , ?tnlimite, ?tnreg ) "

			If !Prg_EjecutoSql(lcSql,"",.F.)
				Messagebox("no se pudo grabar el limite por especialidad",16,"Informe a SISTEMAS")
				Return 0
			Endif
		Endif
	Endif
Case mabm = 2 &&& modif
	If mid = 0
		lcSql = " SELECT  id,SL_cantidad,SL_limite  "+;
			" FROM ZabSolLimite where SL_nroregistrac = ?tnreg and SL_codesp =?tncodesp "+;
			" and  SL_limite>SL_cantidad  "
	Else
		lcSql = " SELECT  id,SL_cantidad,SL_limite  "+;
			" FROM ZabSolLimite where id = ?mid "
	Endif
	If !Prg_EjecutoSql(lcSql,"Mwksollimite",.F.)
		Messagebox("no se pudo grabar el limite por especialidad",16,"Informe a SISTEMAS")
		RETURN 0
	Endif
	mid = Mwksollimite.Id
	mcant = SL_cantidad +1

	If mid >0
		lcSql = " update  ZabSolLimite set SL_cantidad = ?mcant  where id = ?mid "

		If !Prg_EjecutoSql(lcSql,"",.F.)
			Messagebox("no se pudo grabar el limite por especialidad",16,"Informe a SISTEMAS")

		Endif
*!*		Else
*!*			If tnlimite= 3 And SL_cantidad<tnlimite

*!*			Endif
	Endif
Endcase
