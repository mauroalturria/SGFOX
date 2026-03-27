****
** Tablas para Admision
****
Lparameters xnECG
If Vartype(xnECG)#"N"
	xnECG = 0
Endif


Use In Select("mwkserv")
mret = SQLExec(mcon1, "select ser_codserv, ser_descripserv,scv_mnemonico from servicios, servcargval " + ;
	"where ser_guardia = 'S' and ser_codserv = servcargval.scv_codservicio " + ;
	"and scv_mnemonico is not null order by ser_descripserv", "mwkserv")

If xnECG = 0
	If !Used("mwkCie9aa")
		mret = SQLExec(mcon1, "select * from  tabcie10 ", "mwkCie9aa")
	Endif
	Select * From mwkCie9aa Where tipo = 3 Into Cursor mwkCie9
	Use In Select("mwkCie9S")
	Select * From mwkCie9aa Where tipo = 3 Into Cursor mwkCie9s
	Use In Select("mwkCie9i")
	Select * From mwkCie9aa Where tipo = 3 Into Cursor mwkCie9i

	Select * From mwkCie9aa Where tipo = 3 Into Cursor mwkCie9
	Use In Select("mwkCie9C")
	Select * From mwkCie9aa Where tipo = 2 Into Cursor mwkCie9C
	Use In Select("mwkCie9a")
	Select * From mwkCie9aa Where tipo = 1 Into Cursor mwkCie9a

	Use In Select("mwkCie9Sa")
	Select * From mwkCie9a Into Cursor mwkCie9sa
	Use In Select("mwkCie9ia")
	Select * From mwkCie9a Into Cursor mwkCie9ia

	If !Used("mwkCiap2ea")
		mret = SQLExec(mcon1, "select  ID , Codigo , Componente , Criterio , "+;
			"DescrAbrev , Descripcion , Excluye , Incluye,fecanula "+;
			" from  TabCiap2E  where id>=1 ", "mwkCiap2ea")
	Endif

	Select  Id , Codigo , Componente , Criterio , DescrAbrev , Descripcion , Excluye , Incluye,fecanula;
		from  mwkCiap2ea Where fecanula = Ctod('01/01/1900')Order By DescrAbrev  Into Cursor mwkCiap2e
	mret = SQLExec(mcon1, "select ID , Capitulo , Letra from TabCiapCap ", "mwkTCiapCap")

	mret = SQLExec(mcon1, "select ID , Nombre  from TabCiapCom ", "mwkTCiapCom")

Endif
If mret > 0
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
Use In Select("mwkSecagruppanel")
mret = SQLExec(mcon1, "select TSA_Sector as sector,AGS_descripcion as descripcion, AGS_secagrup as SectorAgrup,SEC_codsector,tsa_fechahasta "+ ;
" FROM Tabagrup, Tabsecagrup, Sectores "+;
" WHERE SEC_codsector = TSA_Sector and TSA_Agrupa = Tabagrup.ID"+mwcm+;
 " AND TSA_Tipo = 4 AND SEC_internacion = 1 order by descripcion ", "mwkSecagruppanel")
		Use In Select("mwkSecagrupsol")
		mret = SQLExec(mcon1, "select TSA_Sector as sector,AGS_descripcion as descripcion, AGS_secagrup as SectorAgrup,SEC_codsector,tsa_fechahasta "+ ;
			" FROM Tabagrup, Tabsecagrup, Sectores "+;
			" WHERE SEC_codsector = TSA_Sector and TSA_Agrupa = Tabagrup.ID"+mwcm+;
			" AND TSA_Tipo = 11 AND SEC_internacion = 1 order by descripcion ", "mwkSecagrupsol")


	Endif
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
If mret > 0
	Use In Select("mwksectorint")

	mwcm = Strtran(mwcm,"TSA_Sector","sec_codsector ")
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
	Use In Select("mwkentexc_int")
	mret = SQLExec(mcon1, "select fecpasiva,codent from entidexclu where tpopac='INT'  and tipoturno = 0","mwkentexc_int")
Else
	Messagebox("ERROR EN LA GENERACION DEL CURSOR DE TABLAS, AVISAR A SISTEMAS",16, "Validacion")
	Do sp_desconexion With "error"
	Cancel
Endif

Use In Select("mwkplanpre")
mret = SQLExec(mcon1, "select * from planes where fecpasivaplan = '1900-01-01' ", "mwkplanpre")

Use In Select("mwktaltasint")
Use In Select("mwkmotalta")
Use In Select("mwkmotivoalta")

Do sp_busco_estados With 8,' and tipo = 4 order by subestado,estado','mwkmotalta'
Select estado  As Id, Descrip, subestado As tipoest, 0 As sector From mwkmotalta Into Cursor mwkmotivoalta
Use Dbf('mwkmotivoalta') In 0 Again Alias mwktaltasint


If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR", 48, "Validacion")
	Cancel
Endif

Use In Select("mwkServEspec")
mret = SQLExec(mcon1, "select CodAmbito, Codesp, NroServicio FROM Zapservespec "+;
	" where Fecpasiva ='1900-01-01' ", "mwkServEspec")
If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR", 48, "Validacion")
	Cancel
Endif

Use In Select("mwkciesec")
mret = SQLExec(mcon1, "select * from tabciesec ", "mwkciesecag")
If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR", 48, "Validacion")
	Cancel
Endif
Use In Select('mwkautproto')
mret = SQLExec(mcon1, "select * from tabautProto where APA_fecpasiva = '1900-01-01' order by apa_codigo ", "mwkautproto")
Use In Select('mwkautpdet')

mret = SQLExec(mcon1, "select * from tabautPdet where APD_fecpasiva = '1900-01-01' ", "mwkautpdet")

If mret<0
	Use In Select('mwkautproto')
	Create Cursor mwkautproto (Id N(1),APA_codesp c(4), APA_codigo c(4),APA_codprest c(4), APA_fecpasiva c(4), APA_tipo c(4))
Endif
If mret > 0
	Use In Select("mwkgrupoaisla")
	mret = SQLExec(mcon1, "select * from tabtipoint where id <100000 order by descrip", "mwkgrupoaisla")
Endif


Use In Select("mwkSecEsp")
mret = SQLExec(mcon1, "select ID , Codesp , codsector , codserv  from ZabSecEsp where Fecpasiva = '1900-01-01' ", "mwkSecEsp")
If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR", 48, "Validacion")
	Cancel
Endif

Use In Select("mwkGrupoAisla")
mret = SQLExec(mcon1, "select  Zabgrupoaisla.ID, GA_DiasPrimerPedido,GA_DiasSigtePedido, GA_Duracion, GA_Enfermedades, GA_HabCohorte,"+;
	" GA_HabIndiv, GA_Nombre, GA_TipoAislamiento,descrip  from Zabgrupoaisla "+;
	" inner join tabestados ON (GA_TipoAislamiento = estado and propietario = 25 and tipo = 45) "+;
	"order by Zabgrupoaisla.ID", "mwkGrupoAisla")
If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR", 48, "Validacion")
	Cancel
Endif

Use In Select("mwkGrupoGermen")
mret = SQLExec(mcon1, "select  ID,GG_Germen,GG_IdGrupo from ZabGrupoGermen", "mwkGrupoGermen")
If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR", 48, "Validacion")
	Cancel
Endif
Use In Select("mwkGrupoCohorte")
mret = SQLExec(mcon1, "select  ID,GC_grupo1,GC_grupo2, GC_habilCohorte from Zabgrupocohorte", "mwkGrupoCohorte")
If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR", 48, "Validacion")
	Cancel
Endif

