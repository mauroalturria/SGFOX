PARAMETERS mtipo 

DO sp_busco_estados WITH 7, " and tipo = ?mtipo ", "mwkestatje"

lbresu = (mwkestatje.Estado=1)

USE IN SELECT("mwkestatje")

RETURN lbresu 