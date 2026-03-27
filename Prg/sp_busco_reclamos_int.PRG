Lparameters mInterno, mfecDes, mfecHas

mret = Sqlexec(mcon1, "select Sector, Usuario, InternoTE, FechaGraba, Detalle, CodSector " + ;
	"from TabReclamos " + ;
	"where InternoTE = ?mInterno and " + ;
	"FechaGraba between ?mfecdes and ?mfechas " + ;
	"order by %Id desc","mwkReclaver")

If mret <= 0
	Messagebox("ERROR AL CONSULTAR RECLAMOS POR INTERNO",48,"VALIDACION")
	Return .f.
Endif 	
