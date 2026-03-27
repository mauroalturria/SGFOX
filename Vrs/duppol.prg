MODIFY VIEW b_medpresta
MODIFY VIEW b_medprestambito
SELECT * FROM b_medprestambito WHERE pa_duracion>VAL(duracion)
SELECT * FROM b_medprestambito WHERE pa_duracion>VAL(SUBSTR(duracion,4,2)))
SELECT * FROM b_medprestambito WHERE pa_duracion>VAL(SUBSTR(duracion,4,2))
MODIFY VIEW b_prestambito
SELECT 6
BROWSE LAST
LOCATE FOR pa_duracion>VAL(SUBSTR(duracion,4,2))
REQUERY('b_medprestambito ')
REQUERY('b_medprestambito')
LOCATE FOR pa_duracion>VAL(SUBSTR(duracion,4,2))
REQUERY('b_medprestambito')
LOCATE FOR pa_duracion>VAL(SUBSTR(duracion,4,2))
REQUERY('b_medprestambito')
LOCATE FOR pa_duracion>VAL(SUBSTR(duracion,4,2))
REQUERY('b_medprestambito')
LOCATE FOR pa_duracion>VAL(SUBSTR(duracion,4,2))
REQUERY('b_medprestambito')
LOCATE FOR pa_duracion>VAL(SUBSTR(duracion,4,2))
LOCATE FOR pa_duracion>VAL(SUBSTR(duracion,4,2)) AND pre_codprest<>   42010140
REQUERY('b_medprestambito')
LOCATE FOR pa_duracion>VAL(SUBSTR(duracion,4,2)) AND pre_codprest<>   42010140
REQUERY('b_medprestambito')
LOCATE FOR pa_duracion>VAL(SUBSTR(duracion,4,2)) AND pre_codprest<>   42010140
REQUERY('b_medprestambito')
LOCATE FOR pa_duracion>VAL(SUBSTR(duracion,4,2)) AND pre_codprest<>   42010140
REQUERY('b_medprestambito')
LOCATE FOR pa_duracion>VAL(SUBSTR(duracion,4,2)) AND pre_codprest<>   42010140
REQUERY('b_medprestambito')
LOCATE FOR pa_duracion>VAL(SUBSTR(duracion,4,2)) AND pre_codprest<>   42010140
REQUERY('b_medprestambito')
LOCATE FOR pa_duracion>VAL(SUBSTR(duracion,4,2)) AND pre_codprest<>   42010140
SELECT codprest FROM b_medpresta WHERE codprest NOT in (SELECT pre_codprest FROM b_medprestambito)
SELECT codprest,predescriprest,duracion FROM b_medpresta WHERE codprest NOT in (SELECT pre_codprest FROM b_medprestambito)
SELECT codprest,pre_descriprest,duracion FROM b_medpresta WHERE codprest NOT in (SELECT pre_codprest FROM b_medprestambito)
SELECT codprest,pre_descriprest,duracion,pre_duracion FROM b_medpresta WHERE codprest NOT in (SELECT pre_codprest FROM b_medprestambito)
SELECT * FROM b_medpresta WHERE codprest NOT in (SELECT pre_codprest FROM b_medprestambito)
SELECT codprest,pre_descriprest,duracion,pre_duracion FROM b_medpresta WHERE codprest NOT in (SELECT pre_codprest FROM b_medprestambito)
REQUERY('b_medprestambito')
LOCATE FOR pa_duracion>VAL(SUBSTR(duracion,4,2))  
LOCATE FOR pa_duracion>VAL(SUBSTR(duracion,4,2))
SELECT 8
BROWSE LAST
SELECT 3
BROWSE LAST
TABLEREVERT(.t.)
BROWSE LAST
SELECT pa_codambito,codprest as pa_codiprest,VAL(SUBSTR(duracion,4,2)) as pa_duracion,pa_fecpasiva,pa_retiroestudios,pa_turnosmultip FROM b_prestambito,query int ocursor nuevos
SELECT pa_codambito,codprest as pa_codiprest,VAL(SUBSTR(duracion,4,2)) as pa_duracion,pa_fecpasiva,pa_retiroestudios,pa_turnosmultip;
 FROM b_prestambito,query INTO cursor nuevos
SELECT pa_codambito,codprest as pa_codiprest,VAL(SUBSTR(duracion,4,2)) as pa_duracion,pa_fecpasiva,pa_retiroestudios,pa_turnosmultip;
 FROM b_prestambito,query GROUP BY pa_codiprest INTO cursor nuevos
SELECT 8
SELECT 7
SELECT pa_codambito,codprest as pa_codiprest,VAL(SUBSTR(duracion,4,2)) as pa_duracion,pa_fecpasiva,pa_retiroestudios,pa_turnosmultip;
 FROM b_prestambito,query INTO cursor nuevos
BROWSE LAST
SELECT * FROM nuevos GROUP BY pa_codiprest INTO CURSOR agrego
SELECT 7
SELECT 8
SELECT codprest,pre_descriprest,duracion,pre_duracion FROM b_medpresta WHERE codprest NOT in (SELECT pre_codprest FROM b_medprestambito);
into CURSOR faltas
SELECT * FROM faltas GROUP BY codprest HAVING COUNT(codprest)>1 INTO CURSOR dobles
BROWSE LAST
SELECT * FROM faltas WHERE  codprest in (SELECT codprest FROM dobles) INTO CURSOR dobless
BROWSE LAST
SELECT * FROM faltas WHERE  pre_duracion>VAL(SUBSTR(duracion,4,2)) AND codprest in (SELECT codprest FROM dobles) INTO CURSOR dobless
SELECT 12