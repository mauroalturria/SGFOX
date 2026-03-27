****
** busco consumo por paciente
****

Parameters mproto,mncodprest, mfecdes
mret = SQLExec(mcon1, "select VAL_codadmision  " + ;
	" from Guardia INNER JOIN Guardiavale ON  Guardia.protocolo = Guardiavale.protocolo "+;
	"INNER JOIN  Valesasist ON  Guardiavale.nrovale = Valesasist.VAL_codvaleasist"+;
	" where   Guardia.protocolo =?mproto ", "mwkconscta")

Select * From mwkconscta Group By VAL_codadmision Into Cursor mwkconsctas

micta = " VAL_codadmision  in ('"
Select mwkconsctas
Scan
	micta =micta +Alltrim(VAL_codadmision)+"','"
Endscan
micta = Left(micta,Len(micta )-2)+")"

mret = SQLExec(mcon1, "select  VAL_FHSolicitud, VAL_codvaleasist, presinsuvas.pia_codprest " + ;
	"from  valesasist  "+;
	" inner join presinsuvas on presinsuvas.pia_valesasist  = valesasist.VAL_codpun "+;
	" where  &micta and VAL_fechasolicitud>=?mfecdes and pia_codprest =?mncodprest  " , "mwkcons")
If Used("mwkcons")
	Return  mwkcons.VAL_codvaleasist
Else
	
	Return 0
Endif
