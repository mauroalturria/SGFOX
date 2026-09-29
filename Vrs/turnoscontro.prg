Select turnoidm.*,medprestalima.fecVigenH;
From medprestalima,turnoidm;
WHERE medprestalima.codmed =  turnoidm.codmed  ;
AND medprestalima.diasem =  turnoidm.diasem And hhmmDes <=  turnoidm.hhmmTur ;
AND hhmmHas>=  turnoidm.hhmmTur And fecVigend <=  turnoidm.fechatur ;
AND medprestalima.codprest =  turnoidm.codprest And  fecVigenH>=  turnoidm.fechatur AND turnoidm.ambcentro=1;
 Into Cursor mwkturnooklima
 SELECT * FROM turnoidm WHERE id NOT in (SELECT id FROM mwkturnooklima)  AND turnoidm.ambcentro=1 INTO CURSOR franjaSG