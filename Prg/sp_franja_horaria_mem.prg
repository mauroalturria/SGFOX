
* TRAE LAS FRANJAS SIN AGRUPAR
******************************
Parameters vr_codmed, vr_hoy

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and codambito = ?mxambito "
Endif
mret=SQLExec(mcon1," select MEF_diasem as diasem,MEF_fecvigend as fecvigend,MEF_fecvigenh as fecvigenh, MEF_horadesde as horadesde, MEF_horahasta as horahasta"+;
	" ,MEF_tiposervicio as tiposervicio,MEF_estructura as estructura,MEF_tipoturno as tipoturno,TabMEFranja.id,MEF_hhmmdes as hhmmdes,MEF_hhmmhas as hhmmhas "+;
	" ,datediff('mi',MEF_horadesde, MEF_horahasta)  as minfran ,MEM_codesp,Tabestados.descrip as motivo  "+;
	" ,MEF_duracion , MEF_fecpasiva , MEF_idFranjaActiva , MEF_idMemo , MEF_reservados ,  MEF_sala , MEF_tipoAgenda "+;
	" from TabMEFranja " +;
	" inner join TabMEMemos on TabMEMemos.id = TabMEFranja. MEF_idMemo  "+;
	" left join Tabestados on Tabestados .id = TabMEMemos . MEM_tipomot "+;
	" where MEF_fecvigenH >=?vr_hoy and MEF_codmed=?vr_codmed " +;
	" and MEF_fecvigenD < MEF_fecvigenH "+ mccpoamb +;
	" Order by fecvigend desc, diasem, horadesde, horahasta","mwkfranjaHm")
If mret < 0
	Messagebox('ERROR DE CURSOR FRANJAS HORARIAS',64,'VALIDACION')
	mret=0
Endif

Select Iif(diasem = 2,'Lun',Iif(diasem = 3,'Mar',;
	iif(diasem = 4,'Mie',Iif(diasem = 5,'Jue',;
	iif(diasem = 6,'Vie',Iif(diasem = 7, 'Sab', 'Dom')))))) As semana,Ttoc(horadesde,2) As horad,;
	ttoc(horahasta,2) As horah, fecvigend,fecvigenh, diasem,tiposervicio,;
	estructura,1 as imparchivo,tipoturno,Id,hhmmdes,hhmmhas,minfran,MEM_codesp,motivo   ;
	from mwkfranjahm Into Cursor mwkfranjahorariamem
