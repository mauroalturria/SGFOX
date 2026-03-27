*********
* Grabo  Materiales para Cirugia
*********
Lparameters mabm, mid, midquiro, mpar1,mpar2,mpar3,mpar4,mpar5,mpar6,mpar7,mpar8,mpar9,mpar10,tcCurDat
If Vartype(tcCurDat)<>"C"
	tcCurDat=''
Endif
mfecnul = Ctod("01/01/1900")
mfechoy = sp_busco_fecha_serv("DT")
musuario = mwkusuario.Id
Do Case
Case mabm = 1 && alta
	mret = SQLExec(mcon1,"insert into TabQuiroMaterial "+;
		" (QM_insumo,QM_cantidad,QM_codinsumo,QM_fechaCompras,QM_fechaFarma,QM_fechaQuiro"+;
		",QM_fecpasiva,QM_idquiro,QM_usuarioCompras,QM_usuarioFarma"+;
		",QM_usuarioQuiro,QM_stockFarma,QM_stockCompras ,QM_usuarioAudit,QM_aprobAudit "+;
		",QM_dispoAudit ,QM_solicAudit,QM_transAudit,QM_observAudit "+;
		",QM_solicFechaAud,QM_transFechaAud,QM_aprobFechaAud ,QM_dispoFechaAud   )"+;
		"values (?mpar1,?mpar2,0,?mfecnul,?mfecnul ,?mfechoy "+ ;
		",?mfecnul ,?midquiro,0,0,?musuario ,0,0,0,0,0,0,0,'',?mfecnul,?mfecnul ,?mfecnul,?mfecnul )")
Case mabm = 2 && baja
	mret = SQLExec(mcon1,"update TabQuiroMaterial "+;
		" set QM_fecpasiva = ?mfechoy, QM_usuarioQuiro = ?musuario where id = ?mid ")

Case mabm = 3 && modific quirofano
	mret = SQLExec(mcon1,"update TabQuiroMaterial "+;
		" set QM_insumo = ?mpar1, QM_cantidad = ?mpar2, QM_fechaQuiro = ?mfechoy, QM_usuarioQuiro = ?musuario "+;
		" where id = ?mid ")
Case mabm = 4  && modif Farmacia
	mret = SQLExec(mcon1,"update TabQuiroMaterial "+;
		" set QM_stockFarma= ?mpar1, QM_usuarioFarma= ?mpar2, QM_fechaFarma = ?mfechoy "+;
		" where id = ?mid ")
Case mabm = 5 && modif compras
	mret = SQLExec(mcon1,"update TabQuiroMaterial "+;
		" set QM_stockCompras = ?mpar1, QM_usuarioCompras= ?mpar2, QM_fechaCompras= ?mfechoy "+;
		" where id = ?mid ")
Case mabm = 6 && modif AUDIT
	mret = SQLExec(mcon1,"update TabQuiroMaterial "+;
		" set QM_usuarioAudit= ?mpar1, QM_aprobAudit = ?mpar2, QM_dispoAudit = ?mpar3, QM_solicAudit = ?mpar4,"+;
		" QM_transAudit = ?mpar5, QM_observAudit = ?mpar6, QM_fechaCompras= ?mfechoy "+;
		",QM_solicFechaAud = ?mpar7,QM_transFechaAud = ?mpar8,QM_aprobFechaAud = ?mpar9,QM_dispoFechaAud = ?mpar10"+;
		" where id = ?mid ")

Endcase
If mret < 1
	=Aerr(eros)
	Messagebox(eros(3)+'AVISE A SISTEMAS', 64,'Validacion')
Endif
