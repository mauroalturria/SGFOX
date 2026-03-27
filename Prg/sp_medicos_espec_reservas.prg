*******************************
* AUTOR:Claudia Antoniow
* FECHA:21/01/2002
*******************************
*****************************************************************
* Trae nombre y codigo de los médicos que se encuentran activos *
* y recibe un parametro que indica si lo quiero de ambulatorio, *
* internacion o guardia - el nombre del campo. Y la especialidad*
*****************************************************************
*do sp_conexion.prg
mfecnul = ctod("01/01/1900")
mfechas= sp_busco_fecha_serv('DD')+ 1
if mxambito >1
	mccpoamb = "  m.codambito = ?mxambito and "
else
	mccpoamb = ''	
endif

mret=sqlexec(mcon1,"select p.id, p.nombre,estado, bloquedesde,bloquehasta, TPF_filtro " + ;
	" FROM  medpresta as m,prestadores as p " + ;
	" Left join TabProfFiltro on p.id = TabProfFiltro.TPF_codmed " + ;
	" WHERE &mccpoamb (fecpasivap = ?mfecnul or fecpasivap > ?mfechas) and p.id = m.codmed "+;
	" AND m.codesp =?mccodesp AND p.estado=1 AND &mcdedonde=1 And m.diasem=?mddiasem" + ;
	" GROUP BY p.id" + ;
	" ORDER BY nombre","mwkMedico" )
*AND &mcdedonde=1

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR MEDICOS, REINTENTE",16, "Validacion")
	mret=0

endif
