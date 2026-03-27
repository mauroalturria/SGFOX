USE DBF('ctrl_retipifi') IN 0 AGAIN ALIAS reti
UPDATE reti SET idcodmed = 0
Select reti
GO top
Scan
	mimed = reti.codmed
	mifec = reti.desdefecha
	mihora1 = Val(Left(reti.codespdesbloqueo,At("_",reti.codespdesbloqueo)-1))
	mihora2 = Val(Substr(reti.codespdesbloqueo,At("_",reti.codespdesbloqueo)+1))
	Requery('turnoid')
	Select turnoid
	Go Top
	mient = turnoid.codent
	Select reti
	Replace bloqueo  With turnoid.tipoturno,idcodmed With mient 
WAIT windows TRANSFORM(RECNO()) nowait
Endscan
COPY TO c:\desaguemes\retipo TYPE xl5
