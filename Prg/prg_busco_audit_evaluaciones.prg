Lparameters tncodadmision,tncpermiso

mret = SQLExec(mcon1,"select TabAuditEval.*,TabAuditDemoIC.*,TabAuditDemoras.*,"+;
	" TabAuditDetalle.*,TabAuditHis.*,TabAuditIACRel.*,"+;
	" tai_descripcion,TabAuditIACRel.id as num,nomape, "+;
	" pre_descriprest ,tabestados.descrip as estadoeval"+;
	" from TabAuditEval "+;
	" inner join tabusuario on codigovax=tae_codigovax"+;
	" inner join TabAuditDemoras on taud_idTabAuditEval  = TabAuditEval.id "+;
	" inner join TabAuditDetalle on tad_idTabAuditEval   = TabAuditEval.id "+;
	" inner join TabAuditHis     on tah_idTabAuditEval   = TabAuditEval.id "+;
	" inner join tabestados		 on tae_Estado = tabestados.estado and propietario=15 and tipo=8"+;
	" left  join TabAuditIACRel  on tair_idTabAuditEval  = TabAuditEval.id "+;
	" left  join TabAuditDemoIC  on tadi_idTabAuditEval  = TabAuditEval.id "+;
	" left  join TabAuditIACS    on TabAuditIACS.id      = tair_idTabAuditIACS "+;
	" LEFT  join PRESTACIONS     on PRESTACIONS.pre_codprest = TabAuditDemoIC.tadi_codprest "+;
	" where tae_codadmision = ?tncodadmision "+;
	" order by tae_fechahasta desc","mwkevalante")


If mret<1
	=Aerror(eros)
	Messagebox(eros(3))
	*Do Log_errores With Error(), Message(), Message(1)
	Return .F.
Endif

*!*	Endif

lcmedico = Left(mwkusuario.nomape,1)
If Reccount('mwkevalante') <= 0
	Use In mwkevalante
	If !(Type('mfrmautor01') # 'U' And  lcmedico # "*")
		Messagebox("PACIENTE SIN EVALUACÓN",64,"SISTEMAS")
		Return .F.
	Endif

Else
	Select * From mwkevalante;
		group By Id;
		order By tae_fechahasta Desc;
		into Cursor mwkevalante1
Endif