Parameters tcAdmision, tcCursor

If Vartype(tcCursor) # "C"
	tcCursor= 'mwktabintdiag'
Endif

lcSql = "SELECT Tabinthce.IH_motIngreso, Pacientes.PAC_descripdiagn,Tabcie10.descrip "+;
" FROM Tabinthce,Pacientes left join Tabcie10  ON  IH_motIngreso = Tabcie10.ID "+;
" WHERE Pacientes.PAC_codadmision = Tabinthce.IH_admision AND PAC_codadmision = ?tcAdmision "+;
" ORDER BY Tabinthce.ID "

If !Prg_EjecutoSql(lcSql,tcCursor,.F.)
	Return ''
Endif
If Empty(Nvl(mwktabintdiag.Descrip,'')) OR INLIST(IH_motIngreso,16311, 41045,41047)
	Return PAC_descripdiagn
Else
	Return Descrip
Endif
