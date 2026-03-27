CREATE CURSOR docus (nhc c(10),ctd c(2),numdoc n(12))
APPEND FROM c:\desaguemes\tipodoc.txt DELIMITED WITH tab
DELETE FOR numdoc = 0

Select docus
GO top
Scan
	mhclin = nhc
	mdoc = numdoc
	Requery('regtdoc')
	miti = Left(regtdoc.abrevio,2)
	miti = Iif(miti ="DN","DI",miti)
	mnum = regtdoc.REG_numdocumento
	If mdoc =mnum
		mnum = 0
	ENDIF
	Select docus
	WAIT windows TRANSFORM(RECNO())+"/"+transform(RECCOUNT()) nowait
	Replace numdoc With mnum ,ctd With miti
ENDSCAN
Select docus
SET FILTER TO ctd=''
GO top

SCAN
	mhclin = ALLTRIM(nhc)
	Requery('ctrlunif')
	miti = Left(ctrlunif.REG_tipodocumentoo,2)
	miti = Iif(miti ="DN","DI",miti)
	mnum = ctrlunif.REG_numdocumentoo
	mhclin = ctrlunif.REG_nrohclinicao
	Select docus
	WAIT windows TRANSFORM(RECNO())+"/"+transform(RECCOUNT()) nowait
	Replace nhc WITH mhclin,numdoc With mnum ,ctd With miti
ENDSCAN
