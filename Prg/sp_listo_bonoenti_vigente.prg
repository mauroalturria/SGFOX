************************
* AUTOR: Claudia Antoniow
************************
* Fecha : 30/10/2003
************************
*Fecha Ultima Modif: 30/10/2003
*******************************

*************************************************************
* 
**************************************************************
Parameter vr_idbono, vr_cursor,vr_fecha


mret = sqlexec(mcon1," SELECT  * FROM TabBonoEnti "+;
					 " WHERE idbono = ?vr_idbono "+;
				 	 " AND ?vr_fecha between fecvigend and fecvigenh "+;
				 	 " ORDER BY fecvigend desc,fecvigenh desc ", vr_cursor)

if mret < 0
	messagebox('ERROR DE CURSOR '+ vr_cursor + ', REINTENTE',16,'VALIDACION')
	mret  = 0
	Cancel
endif