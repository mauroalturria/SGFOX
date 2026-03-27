*
* Control de cambios x Año, Especialidad, Tipo (CantCont)
*
Lparameters manio, mcodesp

mfecturno = sp_busco_fecha_serv('DD')
mfecha2   = Ctot('01/01/1900')
mcdedonde = 'prestadores.dambula'

If vartype(mcodesp)<>"C"
	mcodesp = ""
Endif

mwhere = ""
If len(alltrim(mcodesp)) > 0
	mwhere = " and prestadores.codesp = ?mcodesp"
Endif

Use in select("mwkctrlca")
mccpoamb = ''
if mxambito >1
	mccpoamb = "  and codambito = ?mxambito "
endif

mret = sqlexec(mcon1,"select prestadores.id as idmed, prestadores.nombre as nommed,prestadores.codesp,"+;
	" sum(nvl(TabMedCbio.cantidad,0)) as cantipo, nvl(CantCont,0) as tipo, nvl(anio,?manio) as anio"+;
	" From prestadores"+;
	" left Join TabMedCbio on TabMedCbio.IdMedico = prestadores.id and TabMedCbio.anio = ?manio"+;
	" Where"+;
	" prestadores.id > 1 and (prestadores.fecpasivap = ?mfecha2 or prestadores.fecpasivap > ?mfecturno) and &mcdedonde = 1"+mwhere+;
	" and  prestadores.id  in (select codmed from medpresta "+;
	" where fecvigend <> fecvigenh and diasem is not Null &mccpoamb ) "+;
	" group by prestadores.id, CantCont, anio"+;
	" order by idmed,tipo,anio","mwkctrlca")

If mret < 0
	Messagebox("CONSULTA MAESTRO DE CAMBIOS",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif
do sp_especialidad

If used("mwkctrlca")
	If reccount("mwkctrlca") > 0

		Select nommed,nvl(ESP_descripcion,space(50)) as especialidad,;
			int(sum(iif(tipo=0 ,cantipo,0))) as c0,;
			int(sum(iif(tipo=1 ,cantipo,0))) as c1,;
			int(sum(iif(tipo=2 ,cantipo,0))) as c2,;
			int(sum(iif(tipo=3 ,cantipo,0))) as c3,;
			int(sum(iif(tipo=4 ,cantipo,0))) as c4,;
			int(sum(iif(tipo=5 ,cantipo,0))) as c5,;
			int(sum(iif(tipo=6 ,cantipo,0))) as c6,;
			int(sum(iif(tipo=7 ,cantipo,0))) as c7,;
			int(sum(iif(tipo=8 ,cantipo,0))) as c8,;
			int(sum(iif(tipo=9 ,cantipo,0))) as c9,;
			int(sum(iif(tipo=10,cantipo,0))) as c10,;
			idmed,anio;
			from mwkctrlca left join MWKespecial on esp_codesp=codesp ;
			group by idmed,anio;
			into cursor mwkctrlcab

	Endif
Endif
Use in select("mwkctrlca")

Return .T.
