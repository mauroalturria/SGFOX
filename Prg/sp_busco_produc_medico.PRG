parameters mfechad, mfechah, mbusco, mMatricula, tnAtenPac

If Vartype(tnAtenPac) <> "N"
	tnAtenPac = 2
Endif  	

mfd = prg_dtoc(mfechad)
mfh = prg_dtoc(mfechah + 1)

*!* --------------------------------------------------------------------------- 
mret = sqlexec(mcon1,"select id as codmedt, nombre, matricula, TipoMat, codesp " + ;
	"from tabmedexterno where gerenciadora = 0 ", "mwkmedicoexterno" )
	
If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
 	Return .f.
Endif  	
*!* --------------------------------------------------------------------------- 	
mret = sqlexec(mcon1,"select id as codmedt, nombre, matriculas, MatProv, codesp  " + ;
	"from prestadores ", "mwkmedicoprest" )

If mret <= 0
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("ERROR DE LECTURA",48,"VALIDACION")
 	Return .f.
Endif  
*!* --------------------------------------------------------------------------- 
if mMatricula > 0
*!*		mfiltro2 = " and egm_codmed = ?mcodmed" && 091005

	do sp_busco_1medico With mMatricula

	if reccount("mwk1medico") > 0
		mfiltro2 = " and egm_codmed in ( ?mcodmed "
		select mwk1medico
		scan All
			mfiltro2 = mfiltro2 + ", " + alltrim(str(codmedt))
			select mwk1medico
		endscan 	
		mfiltro2 = mfiltro2 + " )"
	endif 
	
	Select * ;
		from mwk1medico ;
		into cursor mwkmedictodos
	
	use in mwk1medico
	
else
	mfiltro2 = ""

	select codmedt, nombre, matricula, codesp ;
		from mwkmedicoexterno;
	union all ;
		select codmedt,nombre, val(matriculas) as matricula, codesp ;
		from mwkmedicoprest;
		into cursor mwkmedictodos
endif 	
*!* --------------------------------------------------------------------------- 
mret = sqlexec(mcon1,"select egm_proto, fechahoraing, egm_fechah, codprest,"+;
	" fechahoraate, codestado, guardia.id, prioridad,"+;
	" codent, nroregistrac, egm_codmed"+;
	" from tabguaevolmed, guardia, prestacions "+;
	" where egm_fechah >= ?mfd and egm_fechah < ?mfh"+;
	mfiltro2 +;
	" and guardia.protocolo = tabguaevolmed.egm_proto"+;
	" and guardia.codprest = prestacions.pre_codprest"+;
	" and prestacions.pre_codservicio = 8000"+;
	mbusco, "mwkguardia")


if mret<1
	=aerror(eros)
	Messagebox("ERROR " + eros(3) + " EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "VALIDACION")
endif
*!*	------------------------------------------------------------------
mret = sqlexec(mcon1,"select tgf_codmed, tgf_estado, tgf_fichaent, tgf_fichasal "+;
	" from tabguafich where tgf_fichaent >= ?mfd "+;
	" and tgf_fichaent <= ?mfh  ","mwkficha0")

if mret<1
	=aerror(eros)
	Messagebox("ERROR " + eros(3) + " EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS", 16, "VALIDACION")
endif
*!* --------------------------------------------------------------------------- 
select *, ttod(tgf_fichaent) as diae, ttod(tgf_fichasal ) as dias ;
	from mwkficha0 ;
	into cursor mwkficha

If tnAtenPac = 1
	select *, subs(ttoc(egm_fechah,2),1,2) as hora, ttod(egm_fechah) as fecha  ;
		from  mwkguardia ;
		left join mwkmedictodos on mwkmedictodos.codmedt = egm_codmed ;
		into cursor mwkguardia1
Else
	select *, subs(ttoc(egm_fechah,2),1,2) as hora, ttod(egm_fechah) as fecha  ;
		from  mwkguardia ;
		left join mwkmedictodos on mwkmedictodos.codmedt = egm_codmed ;
		group by fecha, egm_codmed, hora, egm_proto ;
		into cursor mwkguardia1
Endif 

select nombre, fecha, hora, egm_codmed as codmed, ;
	count(egm_codmed) as cantidad, matricula, codesp ;
	from mwkguardia1 ;
	group by fecha ,egm_codmed, hora;
	order by nombre ;
	into cursor mwkproducc

select nombre, fecha, hora, codmed, cantidad, tgf_fichaent, tgf_fichasal, matricula, codesp ;
	from mwkproducc ;
	left join mwkficha on (codmed = tgf_codmed and fecha = diae);
	where codmed > 1 and codmed<>350 ;
	group by fecha ,hora, codmed ;
	order by nombre ;
	into cursor mwkproduccfinal
