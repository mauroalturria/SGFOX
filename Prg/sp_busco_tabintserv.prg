Parameters tnOpcion, tcWhere, tcCursor,tcjoin

If Vartype(tcWhere) # "C"
	tcWhere = ''
Endif
If Vartype(tcjoin) # "C"
	tcjoin = ''
Endif

If Vartype(tcCursor) # "C"
	tcCursor= 'mwktabintserv'
Endif

Do Case
Case tnOpcion = 1
	lcSql = "SELECT Tabintserv.*,Zapservespec.Codesp"+;
	" FROM Tabinthce,Tabintserv "+;
	" INNER JOIN Zapservespec ON  Tabintserv.IS_servicio = Zapservespec.NroServicio "+;
	" WHERE  Tabinthce.ID = Tabintserv.IS_idevol AND  Tabinthce.IH_admision = ?tcWhere "+;
	" ORDER BY Tabintserv.ID "
Case tnOpcion = 2

	lcSql = "SELECT Tabintserv.*,Zapservespec.Codesp"+;
	" FROM Tabinthce,Tabintserv "+;
	" INNER JOIN Zapservespec ON  Tabintserv.IS_servicio = Zapservespec.NroServicio "+;
	" WHERE  Tabinthce.ID = Tabintserv.IS_idevol AND  Tabinthce.IH_admision  = ?tcWhere "+;
	" and is_responsable = 1 and IS_fechaHH> {fn curdate()} "+;
	" ORDER BY Tabinthce.id ,Tabintserv.ID "
Case tnOpcion = 3

	lcSql = "SELECT IH_admision ,Tabintserv.*,Zapservespec.Codesp,ESP_descripcion "+;
	" FROM Tabinthce,Tabintserv,pacinternad,especialid  "+;
	" INNER JOIN Zapservespec ON  Tabintserv.IS_servicio = Zapservespec.NroServicio "+;
	" WHERE Tabinthce.IH_admision = PIN_codadmision and  Tabinthce.ID = Tabintserv.IS_idevol "+;
	" and Zapservespec.Codesp= ESP_codesp and is_responsable = 1 and IS_fechaHH> {fn curdate()} "+;
	" ORDER BY IH_admision ,IH_secuencia "
Endcase

If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
	Return .F.
Endif
