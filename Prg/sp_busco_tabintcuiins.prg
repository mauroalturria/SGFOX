parameters tnOpcion, tcWhere, tcCursor

if vartype(tcWhere) # "C"
	tcWhere = ''
endif

if vartype(tcCursor) # "C"
	tcCursor= 'mwkIntcuiins'
endif
IF USED('mwkpacint1')
	miadmision =  mwkpacint1.pac_codadmision
ENDIF
do case
	case tnOpcion = 1
		lcSql= "SELECT Tabintcuiins.*,insa.INS_descriinsumo as medinsu "+;
			"FROM Tabintcuiins"+;
			" left join Insumos insa ON "+;
			" Tabintcuiins.ICI_insumo = insa.INS_codpuntero "+;
			tcWhere
	otherwise

endcase

if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
	return .f.
endif

use in select('mwkmedaplic')

create cursor mwkmedaplic(medicamento c(250),h08 n (1),h09 n (1),h10 n (1),h11 n (1),h12 n (1);
	,h13 n (1),h14 n (1),h15 n (1),h16 n (1),h17 n (1),h18 n (1),h19 n (1),h20 n (1),h21 n (1);
	,h22 n (1),h23  n (1),h00 n (1),h01 n (1),h02 n (1),h03 n (1);
	,h04 n (1),h05 n (1),h06 n (1),h07 n (1),idmed n (10), idsol n(10), guia n(10) , baxter C(10), idevol n(10))

select &tcCursor
scan all
	Nidsol  = 0&&nvl(ICI_idSol,0)
	Nidmed  = nvl(ICI_insumo,0)
	mimed   = alltrim(nvl(medinsu,'')) + " - " + alltrim(ICI_detalle)
	mhora   = nvl(ICI_horaIndica,hour(ICI_fechaHora))

	mguia   = 0&&nvl(PS_guia,0)
	mbaxter = space(10)&&nvl(PS_baxter,space(10))
	midevol = ICI_idevol

	mcpo    = "h" + transform(mhora,"@L 99")

	select mwkmedaplic

	if Nidsol > 0
		locate for idsol = Nidsol
		if !found()
			insert into mwkmedaplic (medicamento, &mcpo, idsol, guia, baxter, idevol) values (mimed, 1, Nidsol, mguia, alltrim(mbaxter), midevol)
		else
			replace &mcpo with 1
		endif
	else
		if Nidmed > 0
			locate for idmed = Nidmed
		endif
		if !found()
			insert into mwkmedaplic (medicamento, &mcpo, idmed) values (mimed, 1, Nidmed)
		else
			replace &mcpo with 1
		endif
	endif
	select &tcCursor

endscan
*!*	parameters tnOpcion, tcWhere, tcCursor

*!*	if vartype(tcWhere) # "C"
*!*		tcWhere = ''
*!*	endif

*!*	if vartype(tcCursor) # "C"
*!*		tcCursor= 'mwkIntcuiins'
*!*	endif
*!*	miadmision =  mwkpacint1.pac_codadmision
*!*	do case
*!*		case tnOpcion = 1
*!*			lcSql= "SELECT Tabintcuiins.*,insa.INS_descriinsumo as medinsu,Tabintpmsolu.*,Insb.INS_descriinsumo as soluc "+;
*!*				"FROM Tabintcuiins"+;
*!*				" left join Tabintpmsolu ON "+;
*!*				" Tabintcuiins.ici_idsol = Tabintpmsolu.id  "+;
*!*				" left join Insumos insa ON "+;
*!*				" Tabintcuiins.ICI_insumo = insa.INS_codpuntero "+;
*!*				" left join Insumos insb ON "+;
*!*				" (Tabintpmsolu.PS_insumo = Insb.INS_codinsumo ) "+;
*!*				tcWhere
*!*		otherwise

*!*	endcase

*!*	if !Prg_EjecutoSql(lcSql,tcCursor,.f.)
*!*		return .f.
*!*	endif

*!*	use in select('mwkmedaplic')

*!*	create cursor mwkmedaplic(medicamento c(250),h08 n (1),h09 n (1),h10 n (1),h11 n (1),h12 n (1);
*!*		,h13 n (1),h14 n (1),h15 n (1),h16 n (1),h17 n (1),h18 n (1),h19 n (1),h20 n (1),h21 n (1);
*!*		,h22 n (1),h23  n (1),h00 n (1),h01 n (1),h02 n (1),h03 n (1);
*!*		,h04 n (1),h05 n (1),h06 n (1),h07 n (1),idmed n (10), idsol n(10), guia n(10) , baxter C(10), idevol n(10))

*!*	select &tcCursor
*!*	scan all
*!*		if nvl(PS_admision,miadmision ) = miadmision
*!*			Nidsol  = nvl(ICI_idSol,0)
*!*			Nidmed  = nvl(ICI_insumo,0)
*!*			mimed   = alltrim(nvl(medinsu,'')) + alltrim(nvl(soluc ,'')) + " - " + alltrim(ICI_detalle)
*!*			mhora   = nvl(ICI_horaIndica,hour(ICI_fechaHora))

*!*			mguia   = nvl(PS_guia,0)
*!*			mbaxter = nvl(PS_baxter,space(10))
*!*			midevol = ICI_idevol

*!*			mcpo    = "h" + transform(mhora,"@L 99")

*!*			select mwkmedaplic

*!*			if Nidsol > 0
*!*				locate for idsol = Nidsol
*!*				if !found()
*!*					insert into mwkmedaplic (medicamento, &mcpo, idsol, guia, baxter, idevol) values (mimed, 1, Nidsol, mguia, alltrim(mbaxter), midevol)
*!*				else
*!*					replace &mcpo with 1
*!*				endif
*!*			else
*!*				if Nidmed > 0
*!*					locate for idmed = Nidmed
*!*				endif
*!*				if !found()
*!*					insert into mwkmedaplic (medicamento, &mcpo, idmed) values (mimed, 1, Nidmed)
*!*				else
*!*					replace &mcpo with 1
*!*				endif
*!*			endif
*!*		endif
*!*		select &tcCursor

*!*	endscan
