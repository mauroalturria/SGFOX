***
***  Informe de Turnos cancelados
***
Parameter mfecdes, mfechas, mbusco, mlista

mfecd = prg_dtoc(mfecdes)
mfech = prg_dtoc(mfechas + 1)

mccpoamb = ''
If mxambito >1
	mccpoamb = " and TurnosCancel.codambito = ?mxambito "
	mbusco = mbusco + mccpoamb 
Endif 


mret = SQLExec(mcon1,"SELECT id, nombre FROM prestadores " , "mwkMed" )
If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_lista_turnos_cancel1'
	Cancel
Endif
	use in select("mwkespecag")
	mret = sqlexec(mcon1,"select TE_codambito, TE_codesp,TE_codespag"+;
				" from Tabespecialid where TE_codambito = ?mxambito ", "mwkespecag")

mret =	SQLExec(mcon1, "select ESP_codesp, ESP_descripcion "+ ;
	"from prestacions , especialid " + ;
	" where trim(pre_especialidad) = trim(ESP_codesp) and PRE_agendaturnos='S' " , "mwkpres")
If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_lista_turnos_cancel1'
	Cancel
Endif

If mlista = 1
	cfec = ' and fechatur>= ?mfecdes and fechatur <= ?mfechas '
	corden = ' fechatur '
Else
	cfec = ' and feccancela >= ?mfecd and feccancela <= ?mfech '
	corden = ' feccancela '
Endif

*fechatur
mret = SQLExec(mcon1, "select fechatur,fechatomado, codesp, observa , feccancela,codmed "  + ;
	" ,reg_nombrepac ,codreserva,usuario, usucancela, descrip,Entidades.ENT_descrient,idturnos ,reg_nrohclinica,REG_numdocumento " +;
	" from turnoscancel, registracio,tabmotivos,entidades " + ;
	" where  turnoscancel.codreserva<>'' and afiliado = REG_nroregistrac " + cfec + mbusco +  ;
	" and codcancela = tabmotivos.id and codcancela<>27 "+;
	" and turnoscancel.codent = Entidades.ENT_codent " , "mwkturnocancel1")

If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_lista_turnos_cancel1'
	Cancel
Endif

*fechatur
mret = SQLExec(mcon1, "select fechatur,fechatomado, codesp, observa , feccancela,codmed "  + ;
	" ,nombre as reg_nombrepac, codreserva,turnoscancel.usuario, usucancela, descrip,Entidades.ENT_descrient,idturnos " +;
	" from turnoscancel, preregistra,tabmotivos,entidades   " + ;
	" where  turnoscancel.codreserva<>'' and  turnoscancel.afiliado >1 and turnoscancel.afiliado = nroregistracio " + cfec + mbusco + ;
	" and codcancela = tabmotivos.id and codcancela<>27 "+;
	" and turnoscancel.codent = Entidades.ENT_codent " , "mwkturnocancel2")

If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_lista_turnos_cancel1'
	Cancel
Endif
mret = SQLExec(mcon1, "select fechatur,fechatomado, codesp, observa , feccancela,codmed "  + ;
	" ,nombre as reg_nombrepac, codreserva,turnoscancel.usuario, usucancela, descrip,Entidades.ENT_descrient,idturnos " +;
	" from turnoscancel, preregistra,tabmotivos,entidades   " + ;
	" where  turnoscancel.codreserva<>'' and turnoscancel.afiliado = preregistra.id " + cfec + mbusco + ;
	" and codcancela = tabmotivos.id and codcancela<>27 " +;
	" and turnoscancel.codent = Entidades.ENT_codent ", "mwkturnocancel3")

If mret < 0
	=aerr(eros)
	Do prg_error with eros,'sp_lista_turnos_cancel3'
	Cancel
endif
Select * from mwkturnocancel1 union all select *,space(10) as reg_nrohclinica,10000000-10000000 as REG_numdocumento ;
	 from mwkturnocancel2 union all select *,space(10) as reg_nrohclinica,10000000-10000000 as REG_numdocumento ;
	 from mwkturnocancel3 into  cursor mwkturnocancel
	 
*!*	Select ttod(feccancela) as feccancela,fechatur, codesp, codmed ;
*!*		,left(observa,100) as observa,reg_nombrepac,codreserva,usuario,usucancela ;
*!*		,ESP_descripcion , nombre , descrip ;
*!*		from mwkturnocancel, mwkMed, mwkpres;
*!*		where codmed = mwkMed.id and ESP_codesp= codesp ;
*!*		group by codmed, fechatur, codreserva;
*!*		order by &corden into cursor mwklista

Select fechatomado,feccancela, fechatur, codesp, codmed ;
	,observa,reg_nombrepac,codreserva,usuario,usucancela ;
	,ESP_descripcion , nombre , descrip, ENT_descrient,idturnos ,reg_nrohclinica,REG_numdocumento;
	from mwkturnocancel, mwkMed, mwkpres;
	where codmed = mwkMed.id and ESP_codesp= codesp ;
	group by codmed, fechatur, codreserva;
	order by &corden into cursor mwklista

*	,left(observa,255) as observa,reg_nombrepac,codreserva,usuario,usucancela 

If used ('mwkturnocancel1')
	Use in mwkturnocancel1
Endif
If used ('mwkturnocancel2')
	Use in mwkturnocancel2
Endif
If used ('mwkturnocancel')
	Use in mwkturnocancel
Endif
If used ('mwkMed')
	Use in mwkMed
Endif
If used ('mwkpres')
	Use in mwkpres
Endif