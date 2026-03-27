*
* Busca datos anexos de padron
*
Parameters  mcodigoent,mnumdoc,mtipo

*mnroafil = alltrim(CHRTRAN(prg_saca_char(mwkbuspacie1.AFI_nroafiliado)," ",""))
If Vartype(mtipo)#"C"
	mtipo = 'OBRASOC'
Endif
If mcodigoent=948
	mret = SQLExec(mcon1,"select * from SQLUser.PadCabe "+;
	" left join padotrosdatos on padotrosdatos.idpadcabe=padcabe.id "+;
	" where Padcabe.documento = ?mnumdoc and Padcabe.entidad = ?mcodigoent and campo = ?mtipo "+;
	" order by padotrosdatos.FechaDesde desc","mwkctrlpad")
	If mret < 0
		=Aerror(merror)
		Messagebox("EN CONSULTA PADRONES"+Chr(10)+;
		alltrim(merror(3)),16,"ERROR")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
		mcodigoent = 'GASTRO'
	Else
		mplan = Transform(Nvl(plan,151))
		mplan = IIF(mplan = '0','151',mplan )
		menttipo = Val(mwkctrlpad.contenido)
		If menttipo >0
			mcodigoent = menttipo
		Else
			mcodigoent = Alltrim(mwkctrlpad.contenido)
		Endif
	Endif
Endif
Return mplan
