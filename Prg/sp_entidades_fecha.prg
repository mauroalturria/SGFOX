****
**  Busco entidades
****
lparameters mfechad,mfechah
 
mret = sqlexec(mcon1,"select ENT_codent, ENT_descrient,ENT_nroprestadorexterno from entidades " + ;
					" where ENT_fecpas is null or ENT_fecpas>= ?mfechad  "+;
					" order by ENT_descrient", "mwkentidad")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion") 
	do prg_cancelo
endif	