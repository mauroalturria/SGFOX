
Lparameters xsec,ltipo


Do sp_busco_estados With 25,' and tipo = 48 order by estado ','mwksECESP'

Select mwksECESP
midiesp = 0
mresp = ''
Scan
	If xsec$ Alltrim(mwksECESP.Descrip)
		midiesp = mwksECESP.estado
		Exit
	Endif
Endscan
If midiesp >0
	mRet = SQLExec(mcon1,"SELECT * FROM ZapServEspec "+;
		" WHERE  NroServicio  = ?midiesp ","mwkespxpiso")
	mresp = mwkespxpiso.Codesp
ENDIF
IF ltipo = 2
	mRet = SQLExec(mcon1,"SELECT * FROM ZapServEspec "+;
		" WHERE  codesp =  ?mresp and NroServicio <> ?midiesp ","mwkespxpiso")
	mresp = mwkespxpiso.NroServicio  
ENDIF
RETURN mresp 

		
