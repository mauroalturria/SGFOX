*
* Busqueda de telefonos
*
Parameters mregistracio,ltelresp,retcad
If Vartype(ltelresp)#"N"
	ltelresp = 0
Endif
If Vartype(retcad)#"L"
	retcad = .f.
Endif
mfnull = Ctod("01/01/1900")
Do case
Case ltelresp = 0
	mbustel = " and trt_tipo<>9 "
Case ltelresp = 1
	mbustel = " and trt_tipo=9 "
Case ltelresp = 2  &&& todos
	mbustel = "  "
Endcase

Use In Select("mwkbtelefs")

mret = SQLExec(mcon1,"select TabRegTel.*,TT_descrTipo   "+;
	" from TabRegTel left join Zabtipotel on trt_tipo = Zabtipotel.id "+;
	" where TRT_Registracio = ?mregistracio"+;
	" and TRT_Pasiva = ?mfnull "+mbustel+"","mwkbtelefs") && group by TRT_numero

If mret < 0
	Messagebox("EN CONSULTA DE TELEFONOS",16,"ERROR")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif
mret = SQLExec(mcon1,"select TabRegTel.*,TRT_Registracio->REG_telefonos,TRT_Registracio->reg_email,TT_descrTipo  "+;
	" from TabRegTel left join Zabtipotel on trt_tipo = Zabtipotel.id "+;
	" where TRT_Registracio = ?mregistracio"+;
	" and TRT_Pasiva = ?mfnull  "+mbustel+"  ","mwkbtelefINT") &&group by TRT_numero
If !retcad
	Return .T.
Else

	mctelef = ''
	If Reccount('mwkbtelefINT')>0
		mitel = mwkbtelefINT.REG_telefonos
		mctelef = "TE:"+ ALLTRIM(transform(mwkbtelefINT.REG_telefonos))
		Select mwkbtelefINT
		Scan
			If Val(Nvl(mwkbtelefINT.trt_numero,''))>0  And Val(Nvl(mwkbtelefINT.trt_numero,''))#Val(mitel)
				mit =  mwkbtelefINT.TRT_tipo
				mctelef = mctelef + '|'+ALLTRIM(NVL(mwkbtelefINT.TT_descrTipo,'ND'))+":"+;
					ALLTRIM(transform(mwkbtelefINT.trt_numero))+;
					alltrim(Nvl(mwkbtelefINT.TRT_Observacion,''))
			Endif
		Endscan
	Endif
	Return mctelef
Endif
