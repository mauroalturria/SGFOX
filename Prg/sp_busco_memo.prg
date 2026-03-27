
* TRAE LOS MEMOS
******************************
parameters vr_codmed, vr_hoy,vr_filtro,vrfechant,vr_cursor

if vartype(vr_cursor)#"C"
	vr_cursor = "mwkmemos"
endif
if vartype(vrfechant )#"N"
	vrfechant = 0
endif

mccpoamb = ''
if mxambito >1
	mccpoamb = "  and codambito = ?mxambito "
endif
mbusmed  = ''
if vr_codmed >0
	mbusmed = " and MEM_codmed = ?vr_codmed "
endif
if vartype(vr_filtro)#"C"
	vr_filtro= ''
ENDIF
do sp_busco_estados with 106, " and tipo>0 order by Descrip", "mwkmestbus"
SELECT mwkmestbus
cbusest = ' MEM_estado in (0'
SCAN
	IF !INLIST(subestado,6,99)
		cbusest = cbusest +","+ TRANSFORM(estado)
	endif		
endscan
cbusest = cbusest +")"
IF vrfechant = 0
	mbuscofecha = cbusest &&' (MEM_estado=31 or MEM_fecvigenH >=?vr_hoy or MEM_estado = 1) '
ELSE
	mbuscofecha = ' (MEM_fecvigenH >?vr_hoy ) '
endif
*!*	if !used('mwkHabmemo')
*!*		do sp_busco_estados with 7,' and tipo = 2 ','mwkHabmemo'&& habilita memo electronico
*!*	endif
*!*	if mwkHabmemo.ESTADO>0
	mret=sqlexec(mcon1," select TabMEMemos.*,TabMEFranja.*,TabMEMedpresta.*,prestadores.nombre "+;
		",PRE_descriprest,PRE_codservicio,PRE_especialidad,PRE_duracion,enreldep,Tabestados.descrip as motivo "+;
		" from TabMEMemos "+;
		" inner join TabMEFranja on TabMEMemos.id = TabMEFranja. MEF_idMemo "+;
		" left join TabMEMedpresta on TabMEFranja.id = TabMEMedpresta. MEP_idFranja "+;
		" inner join prestadores  on TabMEMemos.MEM_codmed = prestadores.id "+;
		" left join PRESTACIONS on TabMEMedpresta.MEP_codprest = PRESTACIONS.PRE_codprest "+;
		" left join Tabestados on Tabestados .id = TabMEMemos . MEM_tipomot "+;
		" where "+mbuscofecha  + mbusmed + mccpoamb + vr_filtro+;
		" Order by nombre,MEF_diasem, MEF_horadesde, MEF_horahasta, MEF_fecvigend, MEF_fecvigenh",vr_cursor)
*!*	ELSE
*!*	*** DEVUELVO UN CURSOR VACIO
*!*		mret=sqlexec(mcon1," select ID from PRESTADORES "+;
*!*			" where 1= 2 ",vr_cursor)
*!*	endif
if mret < 0
	messagebox('ERROR DE CURSOR FRANJAS HORARIAS',64,'VALIDACION')
	mret=0
endif

