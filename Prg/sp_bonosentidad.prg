*******************
*Claudia Antoniow
*******************
* Fecha 22/11/2003
*******************
parameters vr_identi

mhoy =sp_busco_fecha_serv('DD')

mret =sqlexec(mcon1," SELECT denominacion,tabbono.id FROM Tabbono, Tabbonoenti "+;
	" WHERE tabbono.id =idbono AND codent=?vr_identi " +;
	" AND  tabbono.Fecvigenh >= ?mhoy ","MWKBonos")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR Bonos, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
endif

mret =sqlexec(mcon1," SELECT tabBonoasig.*, denominacion FROM tabBonoasig, Tabbono, Tabbonoenti  "+;
	" WHERE tabbono.id = tabBonoasig.idbono " +;
	" AND tabbono.id = tabbonoenti.idbono AND codent=?vr_identi " +;
	" AND tabbono.Fecvigenh >= ?mhoy order by idbono,bonoserie,bonodesde "+;
	"","MWKBonoasign")

if mret < 0
	messagebox("ERROR EN LA GENERACION DEL CURSOR Bonos Asignados, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
else
	mret =sqlexec(mcon1," SELECT tabBonorec.*, denominacion FROM tabBonorec,Tabbonoenti,tabbono  "+;
		" WHERE tabBonorec.idbono = Tabbonoenti.idbono " +;
		" AND tabbono.id = tabbonoenti.idbono AND codent=?vr_identi " +;
		" AND tabbono.Fecvigenh >= ?mhoy order by idbono,bonoserie,bonodesde ","MWKBonorec")
	
	select MWKBonorec

	do while !eof('MWKBonorec')
		CREATE CURSOR mwkbonopend (denominacion char(50), idbono int(4),;
			serie c(1),Nrodesde char(10),Nrohasta char(10))
		mden 	= denominacion
		mdeso 	= nrodesde
		mhaso 	= nrohasta
		mserie	= bonoserie
		mid 	= idbono
		select * from MWKBonoasign where idbono = mid and bonoserie = mserie;
			into cursor mwkbasi
		select mwkbasi				
		scan
			mhas = nrodesde -1
			mdes = mdeso 
			mdeso = nrohasta + 1
			if mdes < mhas
				insert into mwkbonopend (denominacion,idbono,serie,nrodesde,nrohasta);
					values (mden,mid,mserie,mdes,mhas)
			endif
		endscan
		if mdeso < mhaso
			insert into mwkbonopend (denominacion,idbono,serie,nrodesde,nrohasta);
				values (mden,mid,mserie,mdeso,mhaso)
		endif
		select MWKBonorec
		skip
	enddo	
endif
