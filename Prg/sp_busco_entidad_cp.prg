***
***  busqueda de las entidades con padron
***
**** para auditoria muestra las entidades pasivadas 
mfecha = sp_busco_fecha_serv("DD")
if used ('mwkexe')
	mfecha = iif (mwkexe.nomexe="AUDITORIA",Ctod("01/01/1900"),mfecha)
endif
if used ("mwkenticap")
	use in mwkenticap
endif
mret = sqlexec(mcon1,"select distinct ENT_codent, ENT_descrient from PadCabe,entidades " + ;
	"where  entidad = ENT_codent and (ENT_fecpas is null or ENT_fecpas > ?mfecha )" ,"mwkenticap")
if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR, REINTENTE",16, "Validacion")
	=aerr(eros)

	do prg_cancelo
endif
