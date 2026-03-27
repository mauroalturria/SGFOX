*
* Prescripción Medica - Log
*
Parameters mopc,mxbusca,mvfecdes,mhis
*Create Cursor mwkhpresmedA (fh T, detalle M)
*Create Cursor mwkhpresmedB (fh T, detalle M)
*msuspende = .T.
If Vartype(mopc)<>"N"
	mopc=1
Endif
Do sp_busco_pac_internados_red  With ,'mwkpacsel', mxbusca
Do sp_busco_estados With 25,' and tipo = '+Iif(mopc=1,"55","56"),'mwksuple'
Select mwksuple
minsumos =''
Go Top
Scan
	minsumos =minsumos +Alltrim(Descrip)
Endscan
If !Empty(minsumos )
	mfiltrains = " and INS_codpuntero in ("+minsumos +") "
Else
	Return (.F.)
Endif
xfecha = (Vartype(mvfecdes)="D")
If xfecha
	mfecdes = prg_dtoc(mvfecdes)
	mfechas= prg_dtoc(mvfecdes+1)
Endif
If Vartype(mhis)<>"N"
	mhis = 0
Endif
morden = " Desc "
Local mLeyendaEvol
Local mLeyendaBaja

mLeyendaEvol = ''
mLeyendaBaja = ''

mlidguia    = ''
mdetalleins = ''

midtipo = 3

Do Case
Case midtipo = 1
	mleye = "Endovenoso Continuo"
Case midtipo = 2
	mleye = "Endovenoso No continuo"
Case midtipo = 3
	mleye = "Medicación / Insumos"
Endcase

*!*	1 Endovenoso Continuo      : PRINCIPAL c/VIAS + AGREGADOS
*!*	2 Endovenoso No Continuo   : PRINCIPAL c/VIAS + AGREGADOS + PLANIFICA
*!*	3 No Endovenoso            : PRINCIPAL c/VIAS + PLANIFICA

*!* xx_tipo  //  PS PA PP
*!* xx_estadodia // PS PA PP
*!* 1 Activo / 2 dias anteriores
*!* Fecha modificación
*!*	PS_fechormodif
*!*	PA_fechormodif
*!*	PP_fechormodif

Use In Select("mwksolprin")
Use In Select("mwkagregad")
Use In Select("mwkplanifi")
Use In Select("mwkpresd")



If xfecha
	mfiltro = mfiltrains + " and PS_fechormodif >= ?mfecdes and PS_fechormodif <= ?mfechas "
Endif
If mwkusuario.codigovax = 54035
*	Set Step On On

Endif
Do Case
Case mhis = 1
	mret = SQLExec(mcon1,"select TabIntPmSoluLg.*, insumos.INS_descriinsumo,INS_codinsumo ,ih_admision  "+;
		" from TabIntPmSoluLg,tabinthce,pacinternad "+;
		" join insumos on INS_codinsumo = PS_Insumo"+;
		" where PS_idevol =tabinthce.id and tabinthce.ih_admision = pin_codadmision  and PS_tipo = ?midtipo"+mfiltro +;
		" group by PS_fechormodif, PS_Insumo "+;
		" order by PS_fechormodif "+morden ,"mwksolprin")
Case mhis = 0
	mret = SQLExec(mcon1,"select TabIntPmSolu.*, insumos.INS_descriinsumo,INS_codinsumo ,ih_admision   "+;
		" from TabIntPmSolu,tabinthce,pacinternad "+;
		" join insumos on INS_codinsumo = PS_Insumo"+;
		" where PS_idevol =tabinthce.id and tabinthce.ih_admision = pin_codadmision  and PS_tipo = ?midtipo"+mfiltro +;
		" order by PS_fechormodif "+morden ,"mwksolprin")

Case mhis = 2 && PARA la ultima evolucion de HCE

	mret = SQLExec(mcon1,"select TabIntPmSolu.*, insumos.INS_descriinsumo,INS_codinsumo ,ih_admision   "+;
		" from TabIntPmSolu,tabinthce,pacinternad "+;
		" join insumos on INS_codinsumo = PS_Insumo"+;
		" where PS_idevol =tabinthce.id and tabinthce.ih_admision = pin_codadmision  and  PS_tipo = ?midtipo"+mfiltro +;
		" order by PS_fechormodif "+morden ,"mwksolprin")
	If Reccount("mwksolprin")=0
		mret = SQLExec(mcon1,"select TabIntPmSolu.*, insumos.INS_descriinsumo,INS_codinsumo ,ih_admision   "+;
			" from TabIntPmSolu,tabinthce,pacinternad "+;
			" join insumos on INS_codinsumo = PS_Insumo"+;
			" where PS_idevol =tabinthce.id and tabinthce.ih_admision = pin_codadmision  and  PS_tipo = ?midtipo"+;
			" order by PS_fechormodif "+morden ,"mwksolprin")
		If Reccount("mwksolprin")>0
			If morden = " Desc "
				Go Top
			Else
				Go Bott
			Endif
			mfecdes = 	prg_dtoc(Ttod(PS_fechormodif))
			mfiltro = mfiltrains +" and PS_fechormodif >= ?mfecdes and PS_fechormodif <= ?mfechas "
			mret = SQLExec(mcon1,"select TabIntPmSolu.*, insumos.INS_descriinsumo,INS_codinsumo ,ih_admision   "+;
				" from TabIntPmSolu,tabinthce,pacinternad "+;
				" join insumos on INS_codinsumo = PS_Insumo"+;
				" where PS_idevol =tabinthce.id and tabinthce.ih_admision = pin_codadmision  and  PS_tipo = ?midtipo"+mfiltro +;
				" order by PS_fechormodif "+morden ,"mwksolprin")

		Endif
	Endif
Endcase

If mret < 0
	mltabla = "PRESCRIPCION MEDICA - SOLUCIONES PRINCIPALES - " + Upper(mleye)
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA "+mltabla +Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Select mwksolprin.*, mwkguias.Descrip As lguiadescrip,mwkpacsel.*;
	from mwksolprin INNER Join mwkpacsel On ih_admision =PAC_codadmision ;
	left Join mwkguias On mwkguias.estado = mwksolprin.PS_guia ;
	order By PS_fechormodif &morden ;
	into Cursor mwksolprin

mfiltro = ''
If xfecha
	mfiltro = mfiltrains +" and PA_fechoralta >= ?mfecdes and PA_fechoralta <= ?mfechas "
Endif
If mwkusuario.codigovax = 54035
*	MESSAGEBOX(mfiltro )
Endif


Select mwksolprin


Use In Select("mwkplanifi2")
Use In Select("mwkagregad")
Use In Select("mwkplanifi")

Return


