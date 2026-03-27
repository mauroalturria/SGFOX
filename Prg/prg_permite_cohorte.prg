Lparameters caisla1,caisla2
Local lsigo,ccodais1,ccodais2
lsigo = .t.
nais1 = At("A x",caisla1)
nais2 = At("A x",caisla2)
If nais1 >0
	ccodais1 = Strtran(Substr(caisla1,4),"-",",")
Else
	ccodais1 ='0'
Endif
If nais2 >0
	ccodais2 = Strtran(Substr(caisla2,4),"-",",")
Else
	ccodais2 ='0'
ENDIF
IF !USED('mwkGrupoCohorte')
mret = sqlexec(mcon1, "select  ID,GC_grupo1,GC_grupo2, GC_habilCohorte from Zabgrupocohorte", "mwkGrupoCohorte")
if mret < 0
	messagebox("ERROR AL CALCULAR COHORTE. AVISE A SISTEMAS", 48, "Validacion")
	RETURN .f.
ENDIF
endif
SELECT GC_habilCohorte FROM mwkGrupoCohorte WHERE INLIST(GC_grupo1,&ccodais1 )  AND  INLIST(GC_grupo2,&ccodais2 ) INTO CURSOR mwkhabilch

SELECT  mwkhabilch  
LOCATE FOR GC_habilCohorte =0
lsigo = !FOUND()
Return (lsigo)
