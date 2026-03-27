****
** Tablas para Admision
****
Lparameters ntipoagrup
Use In Select("mwkSecagrup")
Do sp_busco_estados With 57," and tipo = 53  order by subestado ","mwkhabcmsec"
mwcm = ''
If mwkhabcmsec.estado = 1
	mwcm = 	" and TSA_Sector  in (select sec_codsector from sectores where sec_centromedico = ?mxcentromedico) " 
Endif
mret = SQLExec(mcon1, "select TSA_Sector as sector,AGS_descripcion as descripcion, AGS_secagrup as SectorAgrup,TSA_Agrupa "+ ;
" FROM Tabagrup, Tabsecagrup WHERE TSA_Agrupa = Tabagrup.ID"+mwcm+;
 " AND TSA_Tipo = 3 ", "mwkSecagrup")
Use In Select("mwkSecagrpan")
mret = SQLExec(mcon1, "select TSA_Sector as sector,AGS_descripcion as descripcion, AGS_secagrup as SectorAgrup,TSA_Agrupa "+ ;
" FROM Tabagrup, Tabsecagrup WHERE TSA_Agrupa = Tabagrup.ID"+mwcm+;
 " AND TSA_Tipo = 4 ", "mwkSecagrpan")
Use In Select("mwkSecagrdc")
mret = SQLExec(mcon1, "select TSA_Sector as sector,AGS_descripcion as descripcion, AGS_secagrup as SectorAgrup,TSA_Agrupa "+ ;
" FROM Tabagrup, Tabsecagrup WHERE TSA_Agrupa = Tabagrup.ID"+mwcm+;
 " AND TSA_Tipo = 1 ", "mwkSecagrdc")
Use In Select("mwktabagrupacion")
mret = SQLExec(mcon1, "select * FROM Tabagrup "+;
" order by AGS_descripcion ", "mwktabagrupacion")


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
*!*		mret = sqlexec(mcon1, "SELECT Sector, SectorAgrup,SEC_codsector,Descripcion "+ ;
*!*			"  FROM Secagrup, Sectores WHERE SEC_codsector = Sector "+;
*!*			" AND SEC_internacion = 1  ", "mwkSecagruppanel")

If mret > 0
	Use In Select("mwkentexc_int")
	mret = SQLExec(mcon1, "select fecpasiva,codent from entidexclu where tpopac='INT'  and tipoturno = 0 ","mwkentexc_int")
Else
	Messagebox("ERROR EN LA GENERACION DEL CURSOR DE TABLAS, AVISAR A SISTEMAS",16, "Validacion")
	Do sp_desconexion With "error"
	Cancel
Endif

