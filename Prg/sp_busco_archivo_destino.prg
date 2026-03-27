*
* Query para listas : Archivo de Iternados ( Ingreso / Egreso )
*
Parameters mtipo, mljoin

*!* LstEgreso
*!*	frmarchivo26
*!*	frmarchivo55
*!*	frmarchivo66

*!* LstIngreso
*!*	frmarchivo29
*!*	frmarchivo56
MIFECHA = SP_BUSCO_FECHA_SERV("DD")
MIORDEN = '' &&IIF(MIFECHA =CTOD("01/02/2019")," DESC ","")
mretorno = ''

If mtipo = 'E'

	If vartype(mljoin)<>"C"
		mljoin = ""
	Endif

	mretorno = " Select pac_codadmision,pac_fechaalta,"+;
		"iif(pac_motivoalta=6,'OBITO ','ADMISION ')+iif(isnull(hca_estado),'NO INGRESADA'"+;
		",ALLTRIM(nvl(hce_descrip,'EN ARCHIVO'))) as hca_estado2,"+;
		"iif(isnull(hca_estado),space(34),"+;
		"iif(hca_orden>0,iif(hca_estado>0,' Caja '+alltrim(str(nvl(mwkcaja.caja,space(4))))+'-'+"+;
		"Alltrim(nvl(hcmdestino,space(34))),"+;
		"'CAJA NRO.: '+alltrim(str(nvl(mwkcaja.caja,space(4))))),"+;
		"iif(hca_estado=0,space(34),Alltrim(nvl(hcmdestino,space(34))))))+" +;
		"iif(hca_depurab>0 and hca_depurab < 11,' OBITO DEPURADO',iif(hca_depurab>10,iif(hca_depurab=11,' DEPURADO A',' DEPURADO B'),''))"+;
		" AS hcmdestino,nvl(hca_estado,0) as hca_estado,pac_nombrepaciente,pac_fechaadmision, "+;
		"pac_codhci,hca_codbarra ,reg_nroRegistrac,reg_nrohclinica,hca_orden,idtarch,pac_motivoalta,"+;
		" hca_depurab from mwkhistoria "+ mljoin +;
		" group by pac_codadmision ORDER by pac_codadmision "+ MIORDEN+" into cursor Mwkhist2"
Else

	mretorno = "Select pac_codadmision,IIF(ISNULL(pac_fechaalta),{//},pac_fechaalta) AS pac_fechaalta,"+;
		"iif(pac_motivoalta=6,'OBITO ','ADMISION ')+iif(isnull(hca_estado),'NO INGRESADA'"+;
		",ALLTRIM(nvl(hce_descrip,'EN ARCHIVO')))  as hca_estado2,"+;
		"iif(isnull(hca_estado),space(34),"+;
		"iif(hca_orden>0,iif(hca_estado>0,' Caja '+alltrim(str(nvl(mwkcaja.caja,space(4))))+'-'+"+;
		"Alltrim(nvl(hcmdestino,space(34))),"+;
		"'CAJA NRO.: '+alltrim(str(nvl(mwkcaja.caja,space(4))))),"+;
		"iif(hca_estado=0,space(34),Alltrim(nvl(hcmdestino,space(34))))))+" +;
		"iif(hca_depurab>0 and hca_depurab < 11,' OBITO DEPURADO',iif(hca_depurab>10,iif(hca_depurab=11,' DEPURADO A',' DEPURADO B'),''))"+;
		" AS hcmdestino,"+;
		"IIF(!ISNULL(pac_fechaalta),'NO','SI') AS internado,"+;
		"pac_nombrepaciente,pac_fechaadmision, pac_fechaalta as falta,"+;
		"pac_codhci,hca_orden,hca_codbarra,reg_nrohclinica, nvl(hca_estado,0) as hca_estado "+;
		" from mwkhistoria"+;
		" left join mwkcaja on mwkcaja.lid=nvl(mwkhistoria.hca_orden,0)"+;
		" group by pac_codadmision ORDER by pac_codadmision "+ MIORDEN+;
		" into cursor mwkhist4 "

Endif

Return mretorno

