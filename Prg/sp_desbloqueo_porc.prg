Lparameters mfechat,nporce,mrango ,mfiltratipo
Select mwkctrmed
mitiempo1 = Seconds()
If Vartype(mfiltratipo )<>"C"
	mfiltratipo =''
Endif
If mxambito >1
	mccpoamb = "  codambito = ?mxambito and "
Else
	mccpoamb = ''
Endif

Scan
	Wait Windows "DESBLOQUEANDO... " + mwkctrmed.nombre Nowait
	munmed = codmed

	mret=SQLExec(mcon1,"select id from turnos where &mccpoamb afiliado = 1 "+;
		"and codmed = ?munmed  and fechatur = ?mfechat "+mfiltratipo +mrango +" order by horatur","mwkturblock")
	ixx=1
	Select mwkturblock
	Do While !Eof()
		If Mod(ixx,nporce)=0
			mid = mwkturblock.Id
			mret=SQLExec(mcon1,"update turnos set afiliado= 0 where id = ?mid "+mfiltratipo )
		Endif
		Skip
		ixx = ixx + 1
	Enddo
	If mret < 0
		=Aerr(eros)
		Wait Windows eros(3)
	Else
		Select mwkctrmed
		Delete
	Endif
Endscan
mitiempo2 = Seconds()
*messagebox(transform(mitiempo2 -mitiempo1))
