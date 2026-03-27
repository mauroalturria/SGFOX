Parameters lnRegPac, lnCodMed, lnResp1, lnResp2

* Grabo en tabla TabVacunacion

v1=lnCodMed
v2=sp_busco_fecha_serv('DT')
v3=lnRegPac
v4=lnResp1
v5=lnResp2

lcSQL = "Insert into TabVacunacion (VAC_codmed,VAC_fechora,VAC_regpac,VAC_respvag,VAC_respvanc) values (?v1,?v2,?v3,?v4,?v5)"

If !Prg_EjecutoSql(lcSQL,'',.F.)
	Return .F.
Endif
