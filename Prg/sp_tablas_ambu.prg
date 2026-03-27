****
** Tablas para Ambulatorio
****

*!*	mret = sqlexec(mcon1,"select descrip, abrevio, ID, codafip " + ;
*!*		" from tabformularios where id<=5 and abrevio<>'' ", "mwkTCte")

If Used("mwkdocu")
	Use In mwkdocu
Endif
mret = SQLExec(mcon1,"select abrevio, descrip, codigovax, id " + ;
	"from tabdocumentos where id<100000 order by id", "mwkdocu")

Use In Select('mwkdocent')

mret = sqlexec(mcon1," SELECT TDE_CodigoDoc , TDE_CodEnt , TDE_DescripEnt , "+;
	"TDE_IdTabDocumentos,abrevio,descrip FROM TabDocEnt,tabdocumentos "+;
	" where TDE_IdTabDocumentos = tabdocumentos.id ","mwkdocent")

*!*	mret = sqlexec(mcon1,"select descrip, codesp, atiendeen from guardiaespecialid " + ;
*!*		"where id<100000 order by descrip", "mwkespe")

Use In Select('mwkentidad1')
mret = SQLExec(mcon1,"select ENT_codent, ENT_descrient,ENT_nroprestadorexterno from entidades " + ;
	"where ENT_fecpas is null and (ENT_capita is null or ENT_capita <> 'S') and " + ;
	"(ENT_turnoshabilit is null or ENT_turnoshabilit <> 'S') " + ;
	"order by ENT_descrient", "mwkentidad1")

Use In Select('mwkentexg')
mret = SQLExec(mcon1, "select fecpasiva,codent as codentexc,tpopac  from entidexclu "+;
	"where tpopac = 'GUA' union select fecpasiva,codent as codentexc,tpopac  from entidexclu "+;
	"where tpopac = 'INT' and codent not in ( select codent from entidexclu "+;
	"where tpopac = 'GUA')","mwkentexg")

Use In Select('mwkentidad2')
mret = SQLExec(mcon1,"select ENT_codent, ENT_descrient,ENT_capita,ENT_tipo,ENT_nroprestadorexterno,ENT_codagrup from entidades " + ;
	"where ENT_fecpas is null and (ENT_turnoshabilit is null or ENT_turnoshabilit <> 'S') " + ;
	"order by ENT_descrient", "mwkentidad2")

If Used("mwktaltas")
	Use In mwktaltas
Endif
mret = SQLExec(mcon1,"select descrip, id, sector,tipoest from tabtipoaltas " + ;
	"where (sector <3 or sector = 7 ) and id<100000 and ambito in (2,3) " + ;
	"order by descrip", "mwktaltas")

Use In Select('mwkserv')
mret = SQLExec(mcon1, "select ser_codserv, ser_descripserv from servicios, servcargval " + ;
	"where ser_ambulatorio = 'S' and ser_codserv = servcargval.scv_codservicio " + ;
	"and scv_mnemonico is not null order by ser_descripserv", "mwkserv")

*!*	mret = sqlexec(mcon1, "select * from  tabCIE10 ", "mwkCie9")

*!*	mret = sqlexec(mcon1, "select * from tabsectorint where grupo <2 and id<100000  order by descrip", "mwksecint")
If !Used("mwkCiap2e")
	mret = SQLExec(mcon1, "select ID , Capitulo , Letra from TabCiapCap ", "mwkTCiapCap")
	mret = SQLExec(mcon1, "select ID , Nombre  from TabCiapCom ", "mwkTCiapCom")
	mfecnul  = Ctod("01/01/1900")
	If mxambito = 1
		mret = SQLExec(mcon1, "select ID , Codigo,Componente , "+;
			"cast(nvl(Criterio,'') as char(254)) as Criterio,"+;
			"cast(nvl(trim(Incluye),'')as char(254)) as Incluye, "+;
			"cast(nvl(trim(Excluye),'')as char(254)) as Excluye, "+;
			"cast(nvl(trim(DescrAbrev),'')as char(50)) as DescrAbrev, "+;
			"cast(nvl(trim(Descripcion),'')as char(150)) as Descripcion,fecanula "+;
			" from  TabCiap2E where id>=1  ", "mwkCiap2ea")
		Select  Id , Codigo , Componente , Criterio , DescrAbrev , Descripcion , Excluye , Incluye,fecanula;
			from  mwkCiap2ea Where fecanula = Ctod('01/01/1900') Order By DescrAbrev  Into Cursor mwkCiap2e

	Else
		mret = SQLExec(mcon1, "Select ean_evolnurse from Tabambevolnurse where ean_proto = '1'","cAux")

		mresu = Alltrim(cAux.ean_evolnurse )
		Xmltocursor(mresu ,"mwkCiap2ea",4)
		Select  Id , Codigo , Componente , Criterio , DescrAbrev , Descripcion , Excluye , Incluye,fecanula;
			from  mwkCiap2ea Order By DescrAbrev  Into Cursor mwkCiap2e
	Endif
Endif
*!*	mret = sqlexec(mcon1, "select * from  TabCieNanda order by descrip", "mwkCieN")
*!*	If mret < 0
*!*		Messagebox("ERROR EN LA GENERACION DEL CURSOR DE TABLAS, AVISAR A SISTEMAS",16, "Validacion")
*!*		Do sp_desconexion WITH "Err sp_tablas_guardia"
*!*		Cancel
*!*	Endif

Use In Select("mwkplanpre")
mret = SQLExec(mcon1, "select * from planes where fecpasivaplan = '1900-01-01' ", "mwkplanpre")

Use In Select('mwktabmail')
mret = SQLExec(mcon1, "select * from tabmail", "mwktabmail")
Use In Select('mwkautproto')
mret = SQLExec(mcon1, "select * from tabautProto where APA_fecpasiva = '1900-01-01' order by apa_codigo ", "mwkautproto")
Use In Select('mwkautpdet')

mret = SQLExec(mcon1, "select * from tabautPdet where APD_fecpasiva = '1900-01-01' ", "mwkautpdet")

If mret<0
	Use In Select('mwkautproto')
	Create Cursor mwkautproto (Id N(1),APA_codesp c(4), APA_codigo c(4),APA_codprest c(4), APA_fecpasiva c(4), APA_tipo c(4))
Endif
Use In Select("mwkMfamEnt")
mret = SQLExec(mcon1," SELECT  EMF_CodEntidad , EMF_DuracPrescripcio "+;
	" FROM ZabEntMedFamilia " + ;
	" where {fn curdate()} between  EMF_FechaVigDesde and  EMF_FechaVigHasta  ", "mwkMfamEnt")
If mret<0
	=Aerr(eros)
	Messagebox(eros(3))
Endif
mfecpas  = Ctod("01/01/1900")
mret = SQLExec(mcon1, "select codambito,codent, Abreviatura,entidexclu.tipoturno,fecvigend,fecvigenh from entidexclu,TabTipoturno " + ;
	"where entidexclu.tipoturno = TabTipoturno.tipoturno and fecpasiva = '1900-01-01' and tpopac = 'AMB' " , "mwkenturno")
If mret<0
	=Aerr(eros)
	Messagebox(eros(3))
Endif
Use In Select("mwkExcEsp")
mret = SQLExec(mcon1," select CodAmbito, EXE_CodEntidad, EXE_CodEspecialidad,  EXE_TipoExclusion"+;
	',EXE_VigenciaDesde ,EXE_VigenciaHasta'+;
	" FROM Zabespecexcluentidad "+;
	" where EXE_VigenciaHasta>{fn curdate()}  ", "mwkExcEsp")
If mret<0
	=Aerr(eros)
	Messagebox(eros(3))
Endif
Use In Select("mwkExcPres")
mret = SQLExec(mcon1," select CodAmbito,PXE_CodEntidad, PXE_CodPrestacion, PXE_TipoExclusion"+;
	',PXE_VigenciaDesde,PXE_VigenciaHasta'+;
	" FROM Zabprestacexcluentidad "+;
	" where PXE_VigenciaHasta> {fn curdate()} ", "mwkExcPres")
If mret<0
	=Aerr(eros)
	Messagebox(eros(3))
Endif

