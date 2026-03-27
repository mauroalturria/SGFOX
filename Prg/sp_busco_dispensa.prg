** Pasamos filtro.
Lparameters mFiltro

*!*	mret = SQLExec(mcon1,"select c.ins_codinsumo,c.ins_descriinsumo, b.tgt_des,a.ttm_gtin,a.ttm_serie,a.ttm_lote, a.ttm_vence, a.ttm_afiliado, "+ ;
*!*		"a.ttm_partida, a.ttm_transcod,a.ttm_nropof,a.ttm_fechorini, a.ttm_transcod, a.ttm_tipomov,a.ttm_fechormov,e.reg_nroregistrac,e.reg_nombrepac,e.reg_nrohclinica,"+ ;
*!*		"e.registracio, " + ;
*!*		"NVL(f.Ent_descrient,'') as Ent_descrient, NVL(f.Ent_codent,0) as Ent_codent " + ;
*!*		"from tabtramov as a " + ;
*!*		"left join tabtragtin as b on a.ttm_gtin = b.tgt_gtin " + ;
*!*		"left join insumos as c on b.tgt_inscod = c.ins_codinsumo " + ;
*!*		"left join afiliacion as d on a.ttm_afiliado = d.afi_nroafiliado " + ;
*!*		"left join registracio as e on d.registracio = e.registracio " + ;
*!*		"left join ENTIDADES as f on f.ENT_codent = d.AFI_codentidad " + ;
*!*		"where "+ mFiltro  ,"mwkConsuDispensa")

**SET STEP ON

mret = SQLExec(mcon1,"select c.ins_codinsumo,c.ins_descriinsumo, b.tgt_des,a.ttm_gtin,a.ttm_serie,a.ttm_lote, a.ttm_vence, a.ttm_afiliado, "+ ;
	"a.ttm_partida, a.ttm_transcod,a.ttm_nropof,a.ttm_fechorini, a.ttm_transcod, a.ttm_tipomov,a.ttm_fechormov, a.ttm_remitoint, " + ;
	"d.TCE_fechapasiva " + ;	
	"from tabtramov as a " + ;
	"left join tabtragtin as b on a.ttm_gtin = b.tgt_gtin " + ;
	"left join insumos as c on b.tgt_inscod = c.ins_codinsumo " + ;	
	"left join TabFarmCitosE as d on a.ttm_nropof = d.TCE_nropof " + ;
	"where " + mFiltro + " and d.tce_fechapasiva is null" ,"mwkConsuDispensa")
	**"where " + mFiltro + " and a.ttm_nropof exist in (select top 1 d.tce_nropof from tabfarmcitose as d where a.ttm_nropof = d.tce_nropof and d.tce_fechapasiva is null)" ,"mwkConsuDispensa")
	
	**"left join TabFarmCitose as d on a.ttm_nropof = d.TCE_nropof " + ;
	**"where " + mFiltro + " and d.tce_fechapasiva is null" ,"mwkConsuDispensa")
    
    ** + " and d.afi_fechabaja is null "
If mRet<=0
	Messagebox("ERROR EN LA LECTURA DE MOVIMIENTOS TRAZADOS",26,"ERROR")
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
ELSE

** agrupo porque el join contra TabFarmCitosE duplica los registros.
    SELECT * FROM mwkConsuDispensa GROUP BY ttm_tipomov,ttm_transcod1,ttm_fechormov,ttm_nropof,ttm_serie,ttm_afiliado INTO CURSOR mwkConsuDispensa
   
	Return .T.
Endif

