************************
* AUTOR: Claudia Antoniow
************************
* Fecha : 20/06/2003
************************
*Fecha Ultima Modif: 20/06/2003
*******************************

*************************************************************
* Trae Tabla  ,el where ae ingresa por parametro
* vr_condicion y el nombre de la tabla tambien
**************************************************************
Parameter vr_codent, vr_cursor,vr_fecha

if used(vr_cursor)
	use in &vr_cursor
endif
mret = sqlexec(mcon1," SELECT BO.id, BO.denominacion, BE.codent, BO.Importe, "+;
					 " BE.idbono, BO.idbonoasoc, BO.tipobono,Bo.CodMotivo "+;
					 " FROM TabBonoEnti as BE, TabBono as BO "+;
					 " WHERE BE.codent = ?vr_codent "+;
				 	 " AND ?vr_fecha between BE.fecvigend and BE.fecvigenh "+;
				 	 " AND BE.idbono = BO.id "+;
				     " ORDER BY BO.denominacion ", vr_cursor)

if mret < 0
	messagebox('ERROR DE CURSOR '+ vr_cursor + ', REINTENTE',16,'VALIDACION')
	mret  = 0
endif
