fechades = ctod("01/01/2006")

mret=SQLExec(mcon1,"SELECT * FROM Tabbonorec WHERE id>1497","tabbonorec")
set step on
select tabbonorec
scan
	mdesde = Nrodesde
	mhasta = NroHasta
	mserie = nvl(BonoSerie,'')
	mipobono = idbono
	musuario = ''
	for mnrobono = mdesde to mhasta
										
		mret=SQLExec(mcon1,"insert into TabbonoDet (BonoSerie, NroBono,TipoBono,usuario) "+;
			" values ( ?mserie, ?mnrobono, ?mipobono ,?musuario)")
		if mret<0 
			=aerr(eros)
			set step on
		endif			
	
	next
	select tabbonorec
endscan
set step on
mret=SQLExec(mcon1,"SELECT BonoDesde, BonoHasta,BonoSerie, TipoBono,nrofactura "+;
			" FROM Tabdetallefac where nrofactura > 594133 and ptovta=1 ","Tabdetallefac")
SELECT Tabdetallefac
scan
	mdesde = BonoDesde
	mhasta = BonoHasta
	mserie = nvl(BonoSerie,'')
	mipobono = tipobono
	if nvl(mdesde,0)>0
		mret=SQLExec(mcon1,"delete from TabbonoDet "+;
				" where TipoBono= ?mipobono and NroBono>=?mdesde and NroBono<=?mhasta ")
		if mret<0 
				=aerr(eros)
				set step on
		endif			
	endif			
	sELECT Tabdetallefac
endscan	