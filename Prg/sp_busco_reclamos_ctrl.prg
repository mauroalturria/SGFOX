*****
***** busco reclamos
*****
lparameters mpend, mbusco
if type ('mbusco')#"C"
	mbusco = ""
endif
mbusco = mbusco + ' and estado in ( 0, 1, 5 ) '
if !empty(mbusco)
	mbusco = iif(at("Where",mbusco)=0," Where 1=1 ","") + mbusco
endif

mret = sqlexec(mcon1,'select nroreclamo,estado,AsignadoA,FechaActiva,PrevCorrec,atendiorec '+;
	' from TabReclamos ' + ;
	+ mbusco, 'mwkreclactr')

if mret < 0
	messagebox("ERROR AL CREAR EL CURSOR, AVISAR A SISTEMAS", 16, "Validación")
endif
