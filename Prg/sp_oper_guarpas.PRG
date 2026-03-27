*
* Guardias Pasivas Usuarios
*
mfnull  = ctod("01/01/1900")

Use in select("mwkbase2")
Use in select("mwkbase2b")
Use in select("mwkbase2c")

*!* PRESTADORES
mret = sqlexec(mcon1,"Select prestadores.id as iDmedico,prestadores.nombre as lnombre,"+;
	" tabcargo.descrip as lcargo,"+;
	" prestadores.codesp as lespe1,"+;
	" TabProfEsp.codiEsp as lespe2,"+;
	" prestadores.domicilio,prestadores.email,prestadores.telcelular,prestadores.telefono,"+;
	" tabusuario.idusuario,tabusuario.password, tabcargo.id as lidcargo, tabprofesp.codcargo,"+;
	" tabusuario.id as idtuser"+;
	" From prestadores"+;
	" Left join TabProfEsp on TabProfEsp.codprof = prestadores.id"+;
	" Left join tabcargo on tabcargo.id = TabProfEsp.codcargo "+;
	" Left join tabusuario on tabusuario.IDCodMed = prestadores.ID"+;
	" Where prestadores.id > 1 and"+;
	" ((dambula = 1 and (prestadores.fecpasiva='1900-01-01' or"+;
	" prestadores.fecpasiva > current_date)"+;
	" And (prestadores.fecalta <= current_date )) or"+;
	" (dguardia = 1 and (prestadores.fecpasivag='1900-01-01' or"+;
	" prestadores.fecpasivag > current_date)"+;
	" And (prestadores.fecaltag <= current_date )) or"+;
	" (dinterna = 1 and (prestadores.fecpasivai='1900-01-01' or"+;
	" prestadores.fecpasivai > current_date)"+;
	" And (prestadores.fecaltai <= current_date )) or"+;
	" (prestadores.fecaltap <= current_date ))"+;
	" And (prestadores.fecpasivap='1900-01-01' or  prestadores.fecpasivap > current_date)"+;
	" And codiesp is not null and codcargo is not null"+;
	" Group by prestadores.id, tabprofesp.codcargo"+;
	" Order by TabProfEsp.codcargo,prestadores.id,nombre","mwkbase2")


SET STEP ON

If mret < 0
	=sqldisconnect(MsqlCon)
	MTABLA = "CONSULTA PRESTADORES & USUARIOS"
	Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Select nvl(IDMEDICO,0) as IDMEDICO,;
	nvl(LNOMBRE   , space(40)) as LNOMBRE   ,;
	nvl(LCARGO    , space(50)) as LCARGO    ,;
	nvl(LESPE1    , space(04)) as LESPE1    ,;
	nvl(LESPE2    , space(04)) as LESPE2    ,;
	nvl(DOMICILIO , space(40)) as DOMICILIO ,;
	nvl(EMAIL     , space(50)) as EMAIL     ,;
	nvl(TELCELULAR, space(20)) as TELCELULAR,;
	nvl(TELEFONO  , space(20)) as TELEFONO  ,;
	nvl(IDUSUARIO , space(20)) as IDUSUARIO ,;
	nvl(PASSWORD  , space(15)) as PASSWORD  ,;
	nvl(LIDCARGO  ,0) as LIDCARGO  ,;
	nvl(CODCARGO  ,0) as CODCARGO  ,;
	nvl(IDTUSER   ,0) as IDTUSER ;
	from mwkbase2 into cursor mwkbase2

*!* ENFERMERIA
mvalor1 = 'ENFERMERIA'
mvalor2 = 'ENFE'
mvalor3 = space(1)
mvalor4 = -1
mvalor5 = 0

mret = sqlexec(mcon1,"Select cast(0 as int) as iDmedico,"+;
	" TabUsuario.nomape as lnombre,"+;
	" cast(?mvalor1 as varchar(50)) as lcargo,"+;
	" cast(?mvalor2 as varchar(04)) as lespe1,"+;
	" cast(?mvalor2 as varchar(04)) as lespe2,"+;
	" cast(?mvalor3 as varchar(40)) as domicilio,"+;
	" TabUsuario.email as email,"+;
	" cast(?mvalor3 as varchar(20)) as telcelular,"+;
	" cast(?mvalor3 as varchar(20)) as telefono,"+;
	" tabusuario.idusuario,"+;
	" tabusuario.password,"+;
	" cast(?mvalor4 as int) as lidcargo,"+;
	" cast(?mvalor5 as int) as codcargo,"+;
	" tabusuario.id as idtuser"+;
	" From TabUsuario "+;
	" where TabUsuario.descrip like '%ENFER%' "+;
	" And TabUsuario.fecpasiva = ?mfnull","mwkbase2b")

If mret < 0
	=sqldisconnect(MsqlCon)
	MTABLA = "CONSULTA USUARIOS ENFERMERIA"
	Do LOG_ERRORES WITH ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Messagebox("EN LA TABLA " + MTABLA + CHR(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Create cursor mwkbase2c (IDMEDICO N(9), LNOMBRE C(40), LCARGO C(50),LESPE1 C(4), LESPE2 C(4), ;
	DOMICILIO C(40), EMAIL C(50), TELCELULAR C(20), TELEFONO C(20), ;
	IDUSUARIO C(20), PASSWORD C(15), LIDCARGO N(9),;
	CODCARGO N(9), IDTUSER N(9))

Select mwkbase2
Go top
Scan all
	Scatter memvar
	Select mwkbase2c
	Append blank
	Gather memvar
	Select mwkbase2
Endscan

Select IDMEDICO,;
	LNOMBRE,LCARGO,LESPE1,LESPE2,DOMICILIO,nvl(EMAIL,space(50)) as EMAIL, ;
	TELCELULAR,TELEFONO,IDUSUARIO,password,LIDCARGO,CODCARGO,IDTUSER ;
	from mwkbase2b where left(alltrim(LNOMBRE),1) <> '*' ;
	into cursor mwkbase2b

Select mwkbase2b
Go top
Scan all
	Scatter memvar
	Select mwkbase2c
	Append blank
	Gather memvar
	Select mwkbase2b
Endscan

*!*  Excluyo residentes
*Select * from mwkbase2c where LIDCARGO not in (30,31,32,33,34) into cursor mwkbase2

*!* 2019-05-21 Se deshabilita
*!* Select * from mwkbase2c where LIDCARGO not in (31,32,33,34,47,48,49,50) into cursor mwkbase2

Use in select("mwkbase2b")
Use in select("mwkbase2c")

Return .T.
