Parameters lnIdProto 

*!*	clear
*!*	Set Step On
*lnIdProto = 89255
*!*	lnIdProto = 90071
*!*	lnIdProto = 90072

If Vartype(lnIdProto) <> "N"
	Return .f.
Endif 	


lcSql = "Select * from tabquiroproto where id = ?lnIdProto"

If !Prg_EjecutoSql(lcSql,"mwkqpaaux1")
	Return .f.
Endif

Select mwkqpaaux1
lnIdQuiro = mwkqpaaux1.TQP_Quirofano

lcSql = "Select * from Tabquirofano where id = ?lnIdQuiro"

If !Prg_EjecutoSql(lcSql,"mwkquiraaux1")
	Return .f.
Endif

Select mwkquiraaux1
*Edit

lcSql = "Select * from tabquiroproto where TQP_Quirofano = ?lnIdQuiro  AND TQP_Estado = 3 "

If !Prg_EjecutoSql(lcSql,"mwkqpTaaux1")
	Return .f.
Endif

Select ;
	MAX(TQP_HoraFin) as fin, MIN(TQP_HoraIni) as ini  ;
From mwkqpTaaux1 ;
Into Cursor mwkQUpdaaux1

*!*	?mwkQUpdaaux1.ini
*!*	?mwkQUpdaaux1.fin

minic = Val(Strtran(Left(ttoc(mwkQUpdaaux1.ini,2),5),":",""))
mfini = Val(Strtran(Left(ttoc(mwkQUpdaaux1.fin,2),5),":",""))

nSAux = mwkQUpdaaux1.fin - mwkQUpdaaux1.ini
*?minic
*?mfini

nS = Int(nSAux)   
cTime = Padl(Alltrim(Transform(Int(nS/3600),"9999")),2,"0") + Padl(Alltrim(Transform(Mod(Int(nS/60),60),"99")),2,"0")
cTime = Val(cTime) 

Use In select("mwkqpaaux1")
Use In select("mwkquiraaux1")
Use In select("mwkqpTaaux1")
Use In select("mwkQUpdaaux1")

lcSql = "UPDATE TABQUIROFANO SET HoraFin = ?mfini, HoraInic = ?minic, DuracEst = ?cTime where TABQUIROFANO.ID = ?lnIdQuiro"
If !Prg_EjecutoSql(lcSql,"")
	Return .f.
Endif

