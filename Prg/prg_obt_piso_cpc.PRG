PARAMETERS tcCons, tcResu, tcConsR


TEXT TO lcsql NOSHOW TEXTMERGE PRETEXT  7

select piso, numero, salagral, {fn concat({fn CONCAT(TRIM(tu.piso), TRIM(tu.descrip)) },TRIM(tu.numero))} as d
from  SQLUser.TabUbicacion tu 
where tu.centromedico = 3 and tu.codambito = 1 
and {fn concat({fn CONCAT(TRIM(tu.piso), TRIM(tu.descrip)) },TRIM(tu.numero))} = ?tcCons

ENDTEXT

*!*	and (TRIM(tu.salagral) = ?tcCons
*!*	OR  {fn concat({fn CONCAT(tu.piso, tu.descrip) },tu.numero)} = ?tcCons)



If !prg_ejecutoSql(lcsql, "mwkSalaCPC")
	Return .F.
ENDIF

SELECT mwkSalaCPC
GO top

tcResu = ALLTRIM(TRANSFORM(mwkSalaCPC.Piso))
tcConsR = ALLTRIM(TRANSFORM(mwkSalaCPC.numero))

RETURN .t.