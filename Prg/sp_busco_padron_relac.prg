*********************************************************************************
* BUSCA PACIENTES                                            *
*********************************************************************************
parameter mid,mgrupofam, msql_reg2, msql_reg3

mret = sqlexec(mcon1,"SELECT ID , FechaDesde , FechaHasta , IdPadCabe "+;
	"FROM PadVigencia where IdPadCabe = ?mid " , "mwkPadVig")

mret = sqlexec(mcon1,"SELECT NroAfiliado,ApeyNom,Documento,TipoDocumento  "+;
	"FROM PadCabe where grupofamiliar = ?mgrupofam and id <> ?mid and ?mid>0" , "mwkPadRel")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
else
	msql_reg2 = 'select FechaDesde , '+;
		'iif(FechaHasta=ctod("01/01/2100"),space(10),dtoc(FechaHasta)) as FechaHasta '+;
		' from mwkPadVig ORDER BY FechaDesde desc into cursor mwkPadVig1'

	msql_reg3 = 'select NroAfiliado,ApeyNom,abrevio,Documento '+;
		' from mwkPadRel,mwkdocu'+;
		' where TipoDocumento = codigovax '+;
		'ORDER BY NroAfiliado into cursor mwkPadRel1'
endif
