****
** Busco Contratos para guardia
****

Parameter mcodentid

mfecha= ctod('01/01/1900')

mret = sqlexec(mcon1, "select contrato, CON_descricont " + ;
					"from entidcontr2, contratos " + ;
					"where entidcontr2.contrato = contratos.CON_codcont and " + ;
					"CON_fecpasiva is null and " + ;
					"{fn LEFT(entidcontr2.contrato,3)} = '170' and " + ;
					"entidad = ?mcodentid and " + ;
  					"(tipo = 'GUA' or (tipo is null)) " + ;
					"order by contrato", "mwkcontratos")
If mRet <= 0
	Messagebox("ERROR DE LECTURA DE CB ",16,"ERROR")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif 

