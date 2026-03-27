mret=SQLExec(mcon1,"select id,tai_descripcion as descrip from"+;
	" TabAuditIACS","mwkiacs")

If mret<1
	=Aerror(eros)
	Messagebox(eros(3))
	Return .F.
Endif
Append Blank In mwkiacs

mret = SQLExec(mcon1,"SELECT pre_descriprest,''  as  numero,pre_codprest"+;
	" FROM PRESTACIONS where pre_codservicio=8900 "+;
	" AND pre_fechapasiva IS NULL","MWKESPEIC")

If mret<1
	=Aerror(eros)
	Messagebox(eros(3))
	Return .F.
Endif

Select pre_descriprest,Cast(numero As N) As numero,pre_codprest ;
	FROM MWKESPEIC;
	ORDER By pre_descriprest;
	INTO Cursor MWKESPEIC Readwrite

Update MWKESPEIC Set numero = 0