****
** Busco prestaciones
****
Parameters midPr,mpasivo
If Vartype(mpasivo)<>"N"
	mpasivo=0
ENDIF
msec=''
mfecnull = Ctod("01/01/1900")
If mpasivo = 0
	msec = " and (tabpdetpresupuesto.fecpasiva is null or tabpdetpresupuesto.fecpasiva = ?mfecnull) "
Endif
mret = SQLExec(mcon1,"SELECT   tabpdetpresupuesto.ID , excluye , idPreOCon , iddetp , idmodulo , "+;
	" incluye , precio , tipopres ,pre_descriprest ,TabPConce.concepto ,INS_descriinsumo,"+;
	" descserv as descrDet,DescripExce "+;
	" FROM tabpdetpresupuesto "+;
	" left join prestacions on tabpdetpresupuesto .idPreOCon = prestacions .pre_codprest  "+;
	" left join TabPConce on tabpdetpresupuesto .idPreOCon = TabPConce.id  "+;
	" left join INSUMOS on tabpdetpresupuesto .idPreOCon = INSUMOS.INS_codPuntero "+;
	" left join TabPExcedente on tabpdetpresupuesto .idPreOCon = TabPExcedente.id  "+;
	" where iddetp = ?midPr "+msec , "mwkDetPres0")

If mret < 0
	Messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
Endif
Select Id , excluye , idPreOCon , iddetp , idmodulo ,incluye , precio , tipopres , ;
	padr(Iif(tipopres = 2,Nvl(pre_descriprest,''),;
	iif(tipopres = 3,Nvl(INS_descriinsumo,''),Iif(tipopres = 4, descrdet,Iif(tipopres = 5, DescripExce ,Left(Nvl(concepto,''),250))))),250);
	as descserv,Iif(tipopres # 4, descrdet,Space(200)) As descrDet,Padr(Iif(tipopres # 1,'', Substr(Nvl(concepto,''),251,250)),250) As descserv1;
	from mwkDetPres0 Into Cursor mwkDetPres
