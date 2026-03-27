mcon1 = Sqlconnect("172.16.5.60")
*!*	mcon1 = Sqlconnect("172.16.1.2")


Do sp_busco_estados With 1, " and tipo = 122 order by Descrip", "mwkEdif"

mCodProp = 120

Select mwkEdif
Scan All
	mId = mwkEdif.Id
	
	mRet = Sqlexec(mcon1,"Update TabEstados Set Propietario = ?mCodProp Where Id = ?mId ")
	
	Select mwkEdif
Endscan 

*!*	------------------------------------------------------
Do sp_busco_estados With 1, " and tipo = 121 order by Descrip", "mwkRacks"

Select mwkRacks
Scan All
	mId = mwkRacks.Id
	
	mRet = Sqlexec(mcon1,"Update TabEstados Set Propietario = ?mCodProp Where Id = ?mId ")
	
	Select mwkRacks
Endscan 
