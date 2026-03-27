****
** Busco Detalle de lpresupuesto Ambulatorio
****

Lparameters mfechad ,mfechas, mcwhere, msecefec,mpasivo

If Vartype(msecefec) # "C"
	msecefec = " and sectorefec = 'AMB' "
Endif
If Vartype(mpasivo)<>"N"
	mpasivo = 0
Endif
If Vartype(mfechad )="D"
	mfec = " and fechasolic>=?mfechad and fechasolic<=?mfechas"
Else
	mfec = ''
Endif
If !Used('mwkentidad')
	mret = SQLExec(mcon1,"select ENT_codent, ENT_descrient, ENT_turnoshabilit,ent_capita"+;
	" ,ENT_tipo,ENT_codagrup, ENT_nroprestadorexterno from entidades " + ;
		"where ENT_fecpas is null order by ENT_descrient", "mwkentidad")
Endif
If Vartype(mcwhere) # "C"
	mcwhere = ''
Endif
mfecnull = Ctod("01/01/1900")
mfec = mfec +" and (tabpresupuestos.fecpasiva is null or tabpresupuestos.fecpasiva = ?mfecnull) "
If mpasivo = 0

	mfec = mfec +" and (tabpdetpresupuesto.fecpasiva is null or tabpdetpresupuesto.fecpasiva = ?mfecnull) "
Endif
mret = SQLExec(mcon1,"SELECT tabpresupuestos.id,paciente,nroafiliado,pre_descriprest,sectorsol,"+;
	" observaciones,observa2,cpdetalle,tabpresupuestos.id, estadoActual,"+;
	" descrip as estado,Fechasolic,nroregistrac,"+;
	" Remitente, tabpresupuestos.tarea,entidad, tabpModulo.descripcion as modulo, " + ;
	" tabpresupuestos.idmodulo, moneda, valorfechaprog, "+;
	" tabpresupuestos.estado as papel,diasvto,tabpdetpresupuesto.fecpasiva " + ;
	" FROM tabpdetpresupuesto,tabestados,prestacions,tabpresupuestos"+;
	" left join tabpcpago on tabpcpago.id = tabpresupuestos.CondPago"+;
	" left join tabpMODULO on tabpMODULO.id = tabpresupuestos.IDMODULO "+;
	" where idDetp = tabpresupuestos.id and propietario = 26 and subestado = estadoactual"+;
	msecefec+" and idPreOCon = pre_codprest " + mfec + mcwhere + ;
	" union"+;
	" SELECT tabpresupuestos.id,paciente,nroafiliado,pre_descriprest,sectorsol,"+;
	" observaciones,observa2,cpdetalle,tabpresupuestos.id,estadoActual,"+;
	" tabpestado.descripcion as estado,Fechasolic,nroregistrac,"+;
	" Remitente, tabpresupuestos.tarea,entidad, tabpModulo.descripcion as modulo, tabpresupuestos.idmodulo, moneda, valorfechaprog, "+;
	" tabpresupuestos.estado as papel, diasvto,tabpdetpresupuesto.fecpasiva " + ;
	" FROM tabpdetpresupuesto,tabpestado,prestacions,tabpresupuestos"+;
	" left join tabpcpago on tabpcpago.id = tabpresupuestos.CondPago"+;
	" left join tabpMODULO on tabpMODULO.id = tabpresupuestos.IDMODULO "+;
	" where idDetp = tabpresupuestos.id and tabpestado.id = estadoactual"+;
	msecefec+" and idPreOCon = pre_codprest "+ mfec + mcwhere ,"mwkEstadoPres010")

If mret < 0
*!*		=aerr(eros)
*!*		Messagebox(eros(3)+"ERROR de LECTURA , Reintente", 48, "Validacion")
	Return
Endif

If !Used('mwkentidad')
	Do sp_entidades
Endif

Select mwkEstadoPres010.*,Nvl(mwkentidad.ENT_descrient,Space(45)) As ENT_descrient;
	from mwkEstadoPres010 ;
	Left Join mwkentidad On ENT_codent = Val(entidad) ;
	Group By Id Into Cursor mwkEstadoPres01
