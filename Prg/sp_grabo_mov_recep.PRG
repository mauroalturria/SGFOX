*
* Grabo Cabecera / Detalle (Recepción de Materiales
*
Lparameters mtipo, mmaes, mdepo, mestad, mrpvid, morcp, mrpvnro, marti, mPRVID,;
	mcan, mpen, mnomart, mreqid, mtipocte, mlidcabe
	

mfeci = sp_busco_fecha_serv('DT')
mfech = TTOD(mfeci)
muser = mwkusuario.idusuario

If mmaes = "CAB" && Cabecera

	mcvax = mwkusuario.codigovax
	mlnip = mwkserver1.ipaddress

	mret = sqlexec(mcon1,"insert into TabMovCab"+;
		" (TMC_tipo, TMC_remitopro, TMC_idusuario, TMC_codigovax, TMC_fecha, TMC_estado, TMC_deposito,"+;
		" TMC_fecini, TMC_fechas, TMC_cerror, TMC_errds, TMC_transacc, TMC_ipadress)"+;
		" values "+;
		" (?mtipo, ?mrpvid, ?muser, ?mcvax, ?mfech, ?mestad, ?mdepo, ?mfeci, ?mfeci, 0, 0,'',?mlnip)")

	If mret < 0
		Messagebox("ERROR EN REGISTRO DE MOVIMIENTO DE RECEPCION CABECERA",26,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

	Use in select("mwkidcab")

	mret = sqlexec(mcon1,"select id as lidcab from TabMovCab"+;
		" where TMC_idusuario = ?muser and TMC_ipadress = ?mlnip and TMC_fecini = ?mfeci","mwkidcab")

	If mret < 0
		Messagebox("ERROR EN CONSULTA ID REGISTRO DE MOVIMIENTO DE RECEPCION CABECERA",26,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

Else

	mret = sqlexec(mcon1,"insert into TabMovDet"+;
		"(TMD_idmcab,TMD_orcp,TMD_remitoid,TMD_remitonro,TMD_fecha,TMD_artid,TMD_provid,TMD_cantidad,"+;
		"TMD_pendiente,TMD_artnom,TMD_fecini,TMD_fechas,TMD_cerror,TMD_errds,TMD_idusuario,TMD_reqid,"+;
		"TMD_tipocte)"+;
		" values "+;
		"(?mlidcabe,?morcp,?mrpvid,?mrpvnro,?mfech,?marti,?mPRVID,?mcan,?mpen,"+;
		"?mnomart,?mfeci,?mfeci,0,'',?muser,?mreqid,?mtipocte)")

	If mret < 0
		Messagebox("ERROR EN REGISTRO DE MOVIMIENTO DE RECEPCION DETALLE",26,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

Endif

Return .T.

