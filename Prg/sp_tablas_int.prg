****
** Tablas para Admision
****
Use In Select("mwkdocent")
mret = SQLExec(mcon1," SELECT TDE_CodigoDoc , TDE_CodEnt , TDE_DescripEnt , "+;
	"TDE_IdTabDocumentos,abrevio,descrip FROM TabDocEnt,tabdocumentos "+;
	" where TDE_IdTabDocumentos = tabdocumentos.id ","mwkdocent")

Use In Select("mwkdocu")
mret = SQLExec(mcon1,"select abrevio, descrip, codigovax, id " + ;
	"from tabdocumentos order by id", "mwkdocu")

If mret > 0
	mfecturno	= sp_busco_fecha_serv('DD')

	Use In Select("mwkentidad1")
	mret = SQLExec(mcon1,"select ENT_codent, ENT_descrient,ENT_nroprestadorexterno from entidades " + ;
		"where ENT_fecpas is null and (ENT_capita is null or ENT_capita <> 'S') and " + ;
		"(ENT_turnoshabilit is null or ENT_turnoshabilit <> 'S') " + ;
		"order by ENT_descrient", "mwkentidad1")
Endif

Use In Select("mwkentidad")
mret = SQLExec(mcon1,"select ENT_codent, ENT_descrient,ENT_nroprestadorexterno, ENT_turnoshabilit,ent_capita from entidades " + ;
	"where ENT_fecpas is null order by ENT_descrient", "mwkentidad")

Use In Select("mwkentidad2")
mret = SQLExec(mcon1,"select ENT_codent, ENT_descrient,ENT_capita,ENT_tipo,ENT_nroprestadorexterno,ENT_codagrup from entidades " + ;
	"where ENT_fecpas is null and (ENT_turnoshabilit is null or ENT_turnoshabilit <> 'S') " + ;
	"order by ENT_descrient", "mwkentidad2")

mfecnul = Ctod("01/01/1900")
If mret > 0
	Use In Select("mwkmedicos")
	mret = SQLExec(mcon1,"SELECT Prestadores.id, nombre ,TPF_filtro,matriculas " + ;
		" FROM Prestadores " + ;
		" Left join TabProfFiltro on Prestadores.id = TabProfFiltro.TPF_codmed " + ;
		"WHERE (fecpasivap = ?mfecnul or fecpasivap > ?mfecturno)  " + ;
		"ORDER BY nombre", "mwkmedicos" )   &&&and (estado = 1 or fecpasiva > ?mfecturno)
Endif

If mret > 0
	Use In Select("mwkserv")
	mret = SQLExec(mcon1, "select ser_codserv, ser_descripserv,scv_mnemonico from servicios, servcargval " + ;
		"where ser_guardia = 'S' and ser_codserv = servcargval.scv_codservicio " + ;
		"and scv_mnemonico is not null order by ser_descripserv", "mwkserv")
Endif
If !Used('mwkcodpostal')
	mret = SQLExec(mcon1,"SELECT codpostal,Tabloca1.descrip,idprovincia , Tabpcia1.descrip as desprov FROM Tabloca1 "+;
		"  INNER JOIN Tabpcia1 ON Tabloca1.idprovincia = Tabpcia1.ID GROUP BY codpostal"+;
		" ","mwkcodpostal")
Endif
*!*	if mret > 0
*!*		mret = sqlexec(mcon1, "select * from  tabcie10 where id =  15614 ", "mwkCiectrl")
*!*	endif
If mret > 0
	Use In Select("mwkCorcama")
	mret = SQLExec(mcon1, "select * from  TabHabcolor ", "mwkCorcama")
Endif
nSet=SQLSetprop(mcon1, "displogin", 3 )
If !Used("mwkCie9aa")
	mret = SQLExec(mcon1, "select * from  tabcie10 ", "mwkCie9aa")
Endif
Select * From mwkCie9aa Where tipo = 3 Into Cursor mwkCie9
Use In Select("mwkCie9C")
Select * From mwkCie9aa Where tipo = 2 Into Cursor mwkCie9C
Use In Select("mwkCie9a")
Select * From mwkCie9aa Where tipo = 1 Into Cursor mwkCie9a


mret = SQLExec(mcon1, "select codent, tipoturno, tpopac,tpopamb, tpopgua, tpopint from entidexclu  " + ;
	"where fecpasiva = '1900-01-01' and tpopac = 'TRA' " , "mwktraditum")

Use In Select("mwkTCiapCap")
mret = SQLExec(mcon1, "select ID , Capitulo , Letra from TabCiapCap ", "mwkTCiapCap")

Use In Select("mwkTCiapCom")
mret = SQLExec(mcon1, "select ID , Nombre  from TabCiapCom ", "mwkTCiapCom")
If !Used("mwkCiap2ea")
	mret = SQLExec(mcon1, "select  ID , Codigo , Componente , Criterio , "+;
		"DescrAbrev , Descripcion , Excluye , Incluye,fecanula "+;
		" from  TabCiap2E  where id>=1 ", "mwkCiap2ea")
Endif
If Used("mwkCiap2e")
	Use In mwkCiap2e
Endif

Select  Id , Codigo , Componente , Criterio , DescrAbrev , Descripcion , Excluye , Incluye,fecanula;
	from  mwkCiap2ea Where fecanula = Ctod('01/01/1900') Order By DescrAbrev  Into Cursor mwkCiap2e
*!*	endif

If mret > 0
	Use In Select("mwkautoriza")
	mret = SQLExec(mcon1, "select * from tabautoriza where codsector = 16 order by descrip", "mwkautoriza")
Endif
Do sp_busco_estados With 57," and tipo = 53  order by subestado ","mwkhabcmsec"
mwcm = ''
If mwkhabcmsec.estado = 1
	mwcm = 	" and TSA_Sector  in (select sec_codsector from sectores where sec_centromedico = ?mxcentromedico) " 
Endif
If mret > 0
	Use In Select("mwkSecagrup")
	mret = SQLExec(mcon1, "select TSA_Sector as sector,AGS_descripcion as descripcion, AGS_secagrup as SectorAgrup,TSA_Agrupa "+ ;
		",TSA_FechaDesde,TSA_FechaHasta "+;
		" FROM Tabagrup, Tabsecagrup WHERE TSA_Agrupa = Tabagrup.ID"+mwcm+;
		" AND TSA_Tipo = 3 ORDER BY sector, TSA_FechaHasta ", "mwkSecagrup")
	Use In Select("mwkSecagrpan")
	mret = SQLExec(mcon1, "select TSA_Sector as sector,AGS_descripcion as descripcion, AGS_secagrup as SectorAgrup,TSA_Agrupa "+ ;
		",TSA_FechaDesde,TSA_FechaHasta "+;
		" FROM Tabagrup, Tabsecagrup WHERE TSA_Agrupa = Tabagrup.ID"+mwcm+;
		" AND TSA_Tipo = 4 ", "mwkSecagrpan")
	Use In Select("mwkSecagrdc")
	mret = SQLExec(mcon1, "select TSA_Sector as sector,AGS_descripcion as descripcion, AGS_secagrup as SectorAgrup,TSA_Agrupa "+ ;
		",TSA_FechaDesde,TSA_FechaHasta "+;
		" FROM Tabagrup, Tabsecagrup WHERE TSA_Agrupa = Tabagrup.ID"+mwcm+;
		" AND TSA_Tipo = 1 ", "mwkSecagrdc")
	Use In Select("mwktabagrupacion")
	mret = SQLExec(mcon1, "select * FROM Tabagrup "+;
		" order by AGS_descripcion ", "mwktabagrupacion")
	Use In Select("mwkSecagrupnew")
	mret = SQLExec(mcon1, "select TSA_Sector as sector,AGS_descripcion as descripcion, AGS_secagrup as SectorAgrup,TSA_Agrupa "+ ;
		",TSA_FechaDesde,TSA_FechaHasta "+;
		" FROM Tabagrup, Tabsecagrup WHERE TSA_Agrupa = Tabagrup.ID"+mwcm+;
		" AND TSA_Tipo = 5 ORDER BY sector, TSA_FechaHasta ", "mwkSecagrupnew")
	Use In Select("mwkSecagruprel")
	mret = SQLExec(mcon1, "select TSA_Sector as sector,AGS_descripcion as descripcion, AGS_secagrup as SectorAgrup"+ ;
		",TSA_FechaDesde,TSA_FechaHasta "+;
		" FROM Tabagrup, Tabsecagrup WHERE TSA_Agrupa = Tabagrup.ID"+mwcm+;
		" AND TSA_Tipo = 10  ORDER BY sector, TSA_FechaHasta  ", "mwkSecagruprel")

	Use In Select("mwkSecagrupsol")
	mret = SQLExec(mcon1, "select TSA_Sector as sector,AGS_descripcion as descripcion, AGS_secagrup as SectorAgrup,SEC_codsector,tsa_fechahasta "+ ;
		" FROM Tabagrup, Tabsecagrup, Sectores "+;
		" WHERE SEC_codsector = TSA_Sector and TSA_Agrupa = Tabagrup.ID"+mwcm+;
		" AND TSA_Tipo = 11 AND SEC_internacion = 1 order by descripcion ", "mwkSecagrupsol")
Use In Select("mwkSecagruppanel")
mret = SQLExec(mcon1, "select TSA_Sector as sector,AGS_descripcion as descripcion, AGS_secagrup as SectorAgrup,SEC_codsector,tsa_fechahasta "+ ;
" FROM Tabagrup, Tabsecagrup, Sectores "+;
" WHERE SEC_codsector = TSA_Sector and TSA_Agrupa = Tabagrup.ID"+mwcm+;
 " AND TSA_Tipo = 4 AND SEC_internacion = 1 order by descripcion ", "mwkSecagruppanel")

Endif

If mret > 0
	Use In Select("mwkecivil")
	mret = SQLExec(mcon1, "select * from tabecivil where id <100000 order by descrip", "mwkecivil")
Endif

If mret > 0
	Use In Select("mwkcategoria")
	mret = SQLExec(mcon1, "select * from tabcategoria where id <100000 order by descrip", "mwkcategoria")
Endif

If mret > 0
	Use In Select("mwksecint")
	mret = SQLExec(mcon1, "select * from tabsectorint where grupo = 0 and id <100000 order by descrip", "mwksecint")
Endif
If mret > 0
	Use In Select("mwksecintd")
	mret = SQLExec(mcon1, "select * from tabsectorint where grupo <2 and id<100000  order by descrip", "mwksecintd")
Endif

If mret > 0
	Use In Select("mwktmotalta")
	mret = SQLExec(mcon1, "select * from motivoegreso where id <100000 order by mte_descripcion", "mwktmotalta")
Endif
Use In Select("mwksectorint")
If mret > 0
mwcm = STRTRAN(mwcm,"TSA_Sector","sec_codsector ")
	mret = SQLExec(mcon1, "select sec_codsector, sec_descripsec, sec_habitsala"+;
		",SEC_secquirur,SEC_internacion from sectores " + ;
		" where sec_internacion = 1 "+mwcm+;
		" order by sec_descripsec", "mwksectorint")
Endif

If mret >0
	Use In Select("mwkmotivoint")
	mret = SQLExec(mcon1, "select * from motivointernac where mti_fechabaja is null and id <100000 " + ;
		"order by mti_descripcion", "mwkmotivoint")
Endif

If mret > 0
	Use In Select("mwktipoint")
	mret = SQLExec(mcon1, "select * from tabtipoint where id <100000 order by descrip", "mwktipoint")
Endif

If mret > 0
	Use In Select("mwkMotivoBloq")
	mret = SQLExec(mcon1, "select * from tabMotivoBloq where id <100000 order by descrip", "mwkMotivoBloq")
Endif

If mret > 0
	Use In Select("mwkentexc_int")
	mret = SQLExec(mcon1, "select fecpasiva,codent from entidexclu where tpopac='INT'  and tipoturno = 0 ","mwkentexc_int")
Else
	Messagebox("ERROR EN LA GENERACION DEL CURSOR DE TABLAS, AVISAR A SISTEMAS",16, "Validacion")
	Do sp_desconexion With "error"
	Cancel
Endif

Use In Select("mwkplanpre")
mret = SQLExec(mcon1, "select * from planes where fecpasivaplan  = '1900-01-01' ", "mwkplanpre")

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR", 48, "Validacion")
	Cancel
Endif
Use In Select("mwkMfamEnt")
mret = SQLExec(mcon1," SELECT ID , EMF_CodEntidad , EMF_DuracPrescripcio , EMF_FechaVigDesde "+;
	" FROM ZabEntMedFamilia " + ;
	" where {fn curdate()} between  EMF_FechaVigDesde and  EMF_FechaVigHasta  ", "mwkMfamEnt")
If mret<0
	=Aerr(eros)
	Messagebox(eros(3))
Endif
Use In Select("mwktipotel")

mret = SQLExec(mcon1,"SELECT ID, TT_categoria, TT_descrTipo FROM Zabtipotel " + ;
	" where TT_fecpasiva ='1900-01-01' ", "mwktipotel")
If mret<0
	=Aerr(eros)
	Messagebox(eros(3))
Endif
