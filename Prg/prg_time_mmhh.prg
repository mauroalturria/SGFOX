LPARAMETERS tfechora
IF VARTYPE(tfechora)<>"T"
RETURN 0
ELSE
mihora = VAL(STRTRAN(LEFT(TTOC(tfechora,2),5),":",""))
RETURN mihora