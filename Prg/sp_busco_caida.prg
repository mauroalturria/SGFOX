lparameters codadmision
do sp_busco_evol_int_red with alltrim(codadmision)
select mwkEvolIntred
go bottom
midevol = id
use in select('mwkcaida')
text To lcsql Textmerge Noshow Pretext 7
	SELECT  EIS_valor,IH_admision
		FROM TabIntScorNur
		inner join TabintHCE on  tabintHCE.id = TabIntScorNur.EIS_idevol
		inner join pacinternad on pin_codadmision  = TabintHCE.IH_admision
		inner join pacientes on pin_codadmision  = pac_codadmision
		where pac_codadmision = ?codadmision
		order by tabintHCE.id,EIS_fechaH
		group by tabintHCE.id,EIS_fechaH

ENDTEXT
use in select("mwkcaida")
if !Prg_EjecutoSql(lcSql,"mwkcaida")
	return "    "
endif
SELECT mwkcaida
GO bott
mrc = IIF(NVL(EIS_valor,99)<=1,"Bajo",IIF(NVL(EIS_valor,99)<99,"ALTO","    ")) 
RETURN mrc 


