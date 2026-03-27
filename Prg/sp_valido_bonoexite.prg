******************************
* AUTOR: Claudia C. Antoniow
******************************
* Fecha :09/10/2003
********************
parameter v_idbono,v_codent,v_fecdesde, v_fechasta


mret = sqlexec(mcon1," SELECT * FROM TabBonoEnti WHERE codent =?v_codent " +;
					 " AND idbono = ?v_idbono "+;
					 " AND (?v_fecdesde BETWEEN fecvigend AND fecvigenh " +;
					 " OR  ?v_fechasta BETWEEN fecvigend AND fecvigenh) ","MWKEBonoEnti")

if mret < 0
	messagebox('ERROR DE CURSOR MWKEBonoEnti, AVISAR A SITEMAS',16,'VALIDACION')
	mret = 0

ENDIF
					  