****
** Busco medicos guardia + reemplazantes
****
Lparameters mquien, mcodesp, mfecha, mfecturno, mtipomed,mcursor
If Vartype(mcursor)<>"C"
	mcursor = 'mwkMedicogua'
Endif
If !Inlist(Vartype(mfecturno),"D","T")
	mfecturno=sp_busco_fecha_serv("DD")+1
Endif
mquien    = Iif(Type('mquien')#"N",1,mquien)
mquebusco = " codprof<>5 and " && ya no se buscan enfermeros aqui  iif(mquien=3," codprof=5 and "," codprof<>5 and ")
mbusco    = ""
mreempl   = ""
mgeren = ''
If Vartype(mtipomed) # "C"
	mtipomed = "GUA"
Endif
ccodesp = " '    ' as codesp,"
Do Case
	Case mtipomed = "AMB"
		mwhere = "dambula = 1 and "
		mwfecha = "(fecpasiva = ?mfecnul  or fecpasiva > ?mfecturno) "
		mgeren = " and gerenciadora = 0 "
	Case mtipomed = "GUA"
		mwhere = "dguardia = 1 and "
		mwfecha = "(fecpasivag = ?mfecnul  or fecpasivag > ?mfecturno) "
		mgeren = " and gerenciadora = 0 "
	Case mtipomed = "INT"
		mfecturno = Iif(mfecturno=Ctod("01/01/1900"),mfecturno,sp_busco_fecha_serv("DD")+1)
		mbusco    = " 1 = 1 "
		mwhere = '' &&"dinterna = 1 and "
		mwfecha = '' &&"(fecpasivai = ?mfecnul  or fecpasivai > ?mfecturno) "
	Case mtipomed = "QUI"
		mgeren = " and gerenciadora = 222 "
		ccodesp =  " codesp,"
		mwhere = " "
		mwfecha = "(fecpasivap = ?mfecnul  or fecpasivap > ?mfecturno) "
	Case mtipomed = "AUD"
		mfecturno = mfecha - 24*3600
		mgeren = " and gerenciadora = 200 "
		ccodesp =  " codesp,"
		mwhere = " "
		mwfecha =  "(fecpasivap < ?mfecturno or fecpasivap > ?mfecturno) "
Endcase


If Type('mcodesp')="C"
	mreempl = " union SELECT prestadores.id, nombre,codesp,codespe,cast(matriculas as float) as matricula,TPF_filtro,dni  " + ;
		" FROM Prestadores " + ;
		" inner join TabProfFiltro on (Prestadores.id = TabProfFiltro.TPF_codmed and TabProfFiltro.tpf_filtro = 2) "
	Do Case
		Case mcodesp = 'GINE' Or mcodesp = 'OBST'
			mbusco = " and codesp in('GINE', 'OBST') "
		Case mcodesp = 'CLIN'
			mbusco = " and codesp in('CLIN', 'EMER') "
		Otherwise
			mbusco = " and codesp = ?mcodesp "
	Endcase

Endif

mret = SQLExec(mcon1, "SELECT horas_medre FROM TabDatos ", "mwkhorasmedre")

If mret<0 Or !Used("mwkhorasmedre")
	msegundos = 12 * 3600 && 12 horas por default
Else
	msegundos = mwkhorasmedre.horas_medre * 3600
Endif

If Vartype(mfecha)#"T"
	mfeclim = MWKFecServ.fechaHora - msegundos
Else
	mfeclim = mfecha - msegundos
	If mfeclim <Ctod("01/01/2000")
		mfeclim =Ctod("01/01/1900")
	Endif
Endif

If Vartype(mfecturno)#"D"
	mfecturno = Ttod(MWKFecServ.fechaHora )
Endif

mfecreemp	= Ttod(MWKFecServ.fechaHora )	+ 1
mfecnul = Ctod("01/01/1900")

If 	mtipomed = "AUD"
	Use In Select("mwkMedicoaud" )
	mret = SQLExec(mcon1,"SELECT ID , nombre,&ccodesp gerenciadora  as codespe,matricula,cast(0 as integer) as TPF_filtro,matricula as dni  "+;
		" FROM TabMedExterno " + ;
		" where fechaIngreso <= ?mfecreemp "+mgeren + mreempl +;
		"ORDER BY nombre", "mwkMedicoaud" )
Else
	Use In Select(mcursor )

	mret = SQLExec(mcon1,'select CodAmbito , CodMed from tabprofambito '+;
		'where codambito = ?mxambito group by codmed ','mwkprofambito')
	mwheres = ''
	If mxambito=1
		mret = SQLExec(mcon1,'select CodAmbito , CodMed from tabprofambito '+;
			'where codambito <> ?mxambito group by codmed ','mwkprofambitootros')
		mwheres = '	where mwkMedicogua0.id not in(select codmed from mwkprofambitootros) '
	Endif

	mret = SQLExec(mcon1,"SELECT prestadores.id, nombre,codesp,codespe,cast(matriculas as float) as matricula ,TPF_filtro,dni " + ;
		" FROM prestadores  " + ;
		" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
		"WHERE (fecpasivap = ?mfecnul or fecpasivap > ?mfecturno) and "+mwhere +;
		mquebusco +	mwfecha + mbusco +;
		" union  SELECT ID , nombre,&ccodesp gerenciadora  as codespe,matricula,cast(0 as integer) as TPF_filtro,matricula as dni "+;
		" FROM TabMedExterno " + ;
		" where fechaIngreso >= ?mfeclim and fechaIngreso <= ?mfecreemp "+mgeren + mreempl +;
		"ORDER BY nombre, id desc ", "mwkMedicogua0" )

	If mret<0
		mret = SQLExec(mcon1,"SELECT prestadores.id, nombre,codesp,codespe,cast(matriculas as float) as matricula ,TPF_filtro,dni " + ;
			" FROM prestadores  " + ;
			" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
			"WHERE (fecpasivap = ?mfecnul or fecpasivap > ?mfecturno) and "+mwhere+" and " + mquebusco + ;
			mwfecha + mbusco +mreempl+;
			"ORDER BY nombre,id desc", "mwkMedicogua0" )
	Endif

	If mret < 0
		=Aerr(eros)
		Messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
	Endif

	Select mwkMedicogua0.*,mwkprofambito.CodAmbito As codambitomed From mwkMedicogua0 ;
		left Join mwkprofambito On mwkMedicogua0.Id = mwkprofambito.codmed;
		&mwheres ORDER BY nombre,id DESC Into Cursor &mcursor
Endif
