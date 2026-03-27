***
***  busqueda de las entidades
***
Use In Select("mwkptosvt1")
Use In Select("mwkptosvta")

mret = SQLExec(mcon1,"select Descripcion, FechaAlta, FechaPasiva,PuntodeVenta " + ;
	" from Puntosdeventa where TipoPuntoVenta = 1 ", "mwkptosvt1")
Select *,Iif(At('Ambulatorio',Descripcion)>0,"0016",Iif(At('Guardia',Descripcion)>0,"0017","0019")) As origen ;
	from mwkptosvt1 Into Cursor mwkptosvta

mret = SQLExec(mcon1,"select descrip, abrevio, ID, codafip " + ;
	" from tabformularios where id<=5 and abrevio<>'' ", "mwkTCte")

mret = SQLExec(mcon1,"select ENT_codent, ENT_descrient, ENT_turnoshabilit,ent_capita ,ENT_tipo,ENT_nroprestadorexterno from entidades " + ;
	"where ENT_fecpas is null order by ENT_descrient", "mwkentidad")

mret = SQLExec(mcon1,"select ENT_codent, ENT_descrient,ENT_capita,ENT_tipo,ENT_nroprestadorexterno,ENT_codagrup  from entidades " + ;
	"where ENT_fecpas is null and (ENT_turnoshabilit is null or ENT_turnoshabilit <> 'S') " + ;
	"order by ENT_descrient", "mwkentidad2")
If !Used('mwkcodpostal')
	mret = SQLExec(mcon1,"SELECT codpostal,Tabloca1.descrip,idprovincia , Tabpcia1.descrip as desprov,Tabloca1.id FROM Tabloca1 "+;
		"  INNER JOIN Tabpcia1 ON Tabloca1.idprovincia = Tabpcia1.ID "+;
		" ","mwkcodpostal")
Endif
minivel = mwkusuario.nivel
Do sp_especialidad
mret = SQLExec(mcon1,"select * from tabnivel where nivel = ?minivel " ,"mwkNivel")

Use In Select('mwkTXN')
mret = SQLExec(mcon1, "select tabnivel.tipoturno,TabTipoTurno.grupo " + ;
	" from tabnivel,TabTipoturno  "+;
	" where tabnivel.tipoturno = TabTipoTurno.tipoturno and nivel = ?minivel ", "mwkTXN")
Select Distinct grupo From mwkTXN Into Cursor mwkTXNG
Use In Select('mwkXTT')
mret = SQLExec(mcon1, "select * from  TabTipoturno" , "mwkXTT")

Use In Select("mwkentidad1")
mret = SQLExec(mcon1,"select ENT_codent, ENT_descrient ,ENT_tipo,ENT_nroprestadorexterno from entidades " + ;
	"where ENT_fecpas is null and (ENT_capita is null or ENT_capita <> 'S') and " + ;
	"(ENT_turnoshabilit is null or ENT_turnoshabilit <> 'S') order by ENT_descrient", "mwkentidad1")

Use In Select("mwkentidadbris")
If !Used('mwktabambito')
	mret = SQLExec(mcon1,"select * from TabAmbito", "mwktabambito")
Endif
Select mwktabambito
Locate For Id = mxambito

mcenti = " ENT_codagrup in("+Alltrim(mwktabambito.tipoent)+") "
mret = SQLExec(mcon1,"select ENT_codent, ENT_descrient ,ENT_tipo,ENT_nroprestadorexterno from entidades " + ;
	"where &mcenti  and ENT_fecpas is null and (ENT_capita is null or ENT_capita <> 'S') and " + ;
	"(ENT_turnoshabilit is null or ENT_turnoshabilit <> 'S') order by ENT_descrient", "mwkentidadbris")

mret = SQLExec(mcon1,"select abrevio, descrip, codigovax, id from tabdocumentos " + ;
	" where id <100000 order by id", "mwkdocu")

mret = SQLExec(mcon1," SELECT TDE_CodigoDoc , TDE_CodEnt , TDE_DescripEnt , "+;
	"TDE_IdTabDocumentos,abrevio,descrip FROM TabDocEnt,tabdocumentos "+;
	" where TDE_IdTabDocumentos = tabdocumentos.id ","mwkdocent")

Use In Select("mwkpcia")
mret = SQLExec(mcon1,"select descrip, id from tabpcia " + ;
	" where id <100000 order by descrip", "mwkpcia")

Use In Select("mwkloca")
mret = SQLExec(mcon1, "select descrip, id from tabloca " + ;
	"where id<100000 order by descrip", "mwkloca")


mret = SQLExec(mcon1,"select id, descrip, sector from tabmotivos " + ;
	" where sector = 0 and id <100000 order by descrip", "mwkmotivos")

mret = SQLExec(mcon1,"select descrip, id, sector from tabmotivos " + ;
	" where sector = 1 and id <100000 order by descrip", "mwkmotCose")

mret = SQLExec(mcon1,"select Descripcion , ID , TipoAten  from CosegurosTipoAtencion " , "mwktipoaten")

mret = SQLExec(mcon1,"select ser_codserv, ser_descripserv from servicios " + ;
	"where ser_ambulatorio = 'S' and not ser_ambulatorio is null " + ;
	"order by ser_descripserv ", "mwkservicios")

mret = SQLExec(mcon1,"select ser_codserv,ser_descripserv " + ;
	"from servicios, servcargval " + ;
	"where ser_fechapasiva is null and " + ;
	"ser_ambulatorio = 'S' and " + ;
	"ser_codserv = scv_codservicio and scv_mnemonico is not null " + ;
	"order by ser_descripserv", "mwkservicio1" )

mfecpas = Ctod('01/01/1900')
mret = SQLExec(mcon1, "select codent, tipoturno from entidexclu " + ;
	"where id <100000 and fecpasiva = '1900-01-01' and tpopac = 'AMB' and tipoturno = 7 " , "mwkentexc")

mret = SQLExec(mcon1, "select codent, tipoturno from entidexclu " + ;
	"where id <100000 and fecpasiva = '1900-01-01' and tpopac = 'AMB' and tipoturno in(6,7) " , "mwkentexcPS")

mret = SQLExec(mcon1, "select codambito,codent, Abreviatura,entidexclu.tipoturno,fecvigend,fecvigenh from entidexclu,TabTipoturno " + ;
	"where entidexclu.tipoturno = TabTipoturno.tipoturno and fecpasiva = '1900-01-01' and tpopac = 'AMB' " , "mwkenturno")


mret = SQLExec(mcon1, "select codent, tipoturno, tpopac,tpopamb, tpopgua, tpopint from entidexclu  " + ;
	"where fecpasiva = '1900-01-01' and tpopac = 'TRA' " , "mwktraditum")

mret = SQLExec(mcon1," SELECT distinct gerenciadora FROM TabMedExterno where gerenciadora = 373", "mwkTabGeren" )
If mret<0
	mret = SQLExec(mcon1," SELECT distinct cast(0 as integer) as gerenciadora FROM tabformularios ", "mwkTabGeren" )
Endif


mret = SQLExec(mcon1, "select entidad from coseguros  " + ;
	" where fechahasta>={fn curdate()} and tipopac = 'AMB' "+;
	" group by entidad " , "mwkentcose")


mret = SQLExec(mcon1, "select Descripcion,TipoAten from CosegurosTipoAtencion  " , "mwktipoatcose")

Use In Select("mwktipotel")

mret = SQLExec(mcon1,"SELECT ID, TT_categoria, TT_descrTipo FROM Zabtipotel " + ;
	" where TT_fecpasiva ='1900-01-01' ", "mwktipotel")
If mret<0
	=Aerr(eros)
	Messagebox(eros(3))
Endif

mret = SQLExec(mcon1, "select * from planes where fecpasivaplan = '1900-01-01' ", "mwkplanpre")

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
Endif

Use In Select("mwkMfamEnt")
mret = SQLExec(mcon1," SELECT  EMF_CodEntidad , EMF_DuracPrescripcio "+;
	" FROM ZabEntMedFamilia " + ;
	" where {fn curdate()} between  EMF_FechaVigDesde and  EMF_FechaVigHasta", "mwkMfamEnt")
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
