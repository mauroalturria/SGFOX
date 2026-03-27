*****
***** busco reclamos
*****
lparameters mpend, mbusco
if type ('mbusco')#"C"
	mbusco = ""
endif
mbusco = mbusco + iif(mpend=1, ' and estado in ( 0, 1, 5,4 ) ', ' ')
if !empty(mbusco)
	mbusco = iif(at("Where",mbusco)=0," Where 1=1 ","") + mbusco
endif

mret = sqlexec(mcon1,'select TabMantenimiento.*,TabMantEst.descrip '+;
	' from TabMantenimiento' + ;
	' left join TabMantEst on TabMantenimiento.estado = TabMantEst.codest ' + ;
	+ mbusco, 'mwkrecla')

msql_rec = 'select NroReclamo,FechaGraba,left(ttoc(FechaGraba,2),5),Usuario, '+;
	'InternoTE, Sector,left(Detalle,200) as  Detalle,descrip,AtendioRec, '+;
	'nvl(AsignadoA,space(20)) as AsignadoA,FechaPrevista,IDPuesto,Prioridad, ' + ;
	' AtendioSol,Estado, FechaSolucion,Solucion,motivo '+;
	' from mwkrecla into cursor mwkreclamo'
if mret < 0
	messagebox("ERROR AL CREAR EL CURSOR, AVISAR A SISTEMAS", 16, "Validación")
endif
