lparameters mfechat,nhorades,nhorahas,mfiltratipo 
If Vartype(mfiltratipo )<>"C"
	mfiltratipo =''
Endif
select mwkturbloque
mirec = reccount()
scan
	mid = mwkturbloque.id
	wait windows "DESBLOQUEANDO... " + transform(regi)+"/"+transform(mirec)  nowait
	mret=sqlexec(mcon1,"update turnos set afiliado= 0 where id = ?mid "+mfiltratipo )

endscan
