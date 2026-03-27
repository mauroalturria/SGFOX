****
** inserto datos de insumos
****
parameter mcodigo
if empty(mcodigo)
	mret = sqlexec(mcon1, "select INS_codinsumo,INS_descriinsumo,INS_grupo,INS_tipo,INS_unidadmedida,INS_fechapasivo,"+;
		" INSAPARATO1,INSACCION1 from INSUMOS GROUP BY  INS_codinsumo ", "mwkinsumo")
	If mret <= 0
		Messagebox("ERROR DE LECTURA. EVOLUCION ",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif
endif
select mwkinsumo
scan
	descri 	= alltrim(INS_descriinsumo )
	GRUPO 	= INS_grupo
	TIPO	= INS_tipo
	UNIDAD	= alltrim(INS_unidadmedida)
	FECPASI	= INS_fechapasivo
	mcodigo = alltrim(INS_codinsumo)
	APARATO1= iif(nvl(INSAPARATO1,0) = 0,'',transf(nvl(INSAPARATO1,0)))
	actera = alltrim(APARATO1)+alltrim(nvl(INSACCION1,''))
	mfechapas = nvl(FECPASI,ctod("01/01/1900"))
	cactfec = ''
	if !isnull(INS_fechapasivo)
		mFECPASI	= left(prg_dtoc(INS_fechapasivo),10)
		cactfec = " ART_FECHPAS = ?mFECPASI,"
	else
		cactfec = " ART_FECHPAS = NULL,"
	endif
	mret = sqlexec(mcon1, "SELECT ART_ID,ART_NOMBRE,RAR_ID,PRT_ID,UNM_ID FROM ARTICULO "+;
		" WHERE ART_ID = ?mCODIGO ","mwkarticulo")
	If mret <= 0
		Messagebox("ERROR DE LECTURA. EVOLUCION ",16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	else
		if reccount("mwkarticulo")=0 and mfechapas = ctod("01/01/1900")
			mret = sqlexec(mcon1, "insert into ARTICULO (ART_ID, ART_NOMBRE, RAR_ID, PRT_ID, UNM_ID, ACT_ID, DRO_ID)"+;
				" values(?mCODIGO, ?DESCRI, ?GRUPO, ?TIPO, ?UNIDAD, ?ACTERA, 0)")
		else
			if reccount("mwkarticulo")>0
				mret = sqlexec(mcon1, "UPDATE ARTICULO SET  ART_NOMBRE = ?DESCRI,"+;
					cactfec +"ACT_ID = ?ACTERA WHERE ART_ID = ?mCODIGO")
			endif
		endif
		If mret <= 0
			Messagebox("ERROR DE LECTURA. EVOLUCION ",16,"ERROR")
			Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Endif
	endif
endscan
