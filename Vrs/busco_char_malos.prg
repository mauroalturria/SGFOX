SELECT nuevo
scan
IF AT("*",prg_char_mal(nombre))>0
replace malo WITH 1
ENDIF
endscan