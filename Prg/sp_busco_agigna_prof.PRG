*
* Cuidados Domiciliarios : Localización de Profesionales Asignados
*
Lparameters mlid

mfnull = Ctod("01/01/1900")

* Asignacion de Profesionales
* TabCuiDomPasig

* Profesionales Disponibles
* TabCuiDomProf

Use In Select("mwkProAsig")

mret = SQLExec(mcon1,"select TDP_tipo, TDP_prestador, TabCuiDomPasig.ID as lidAsig, TCA_idprofe,"+;
	" TabCuiDomProf.id as lprofid, TabCuiDomProf.TDP_email "+;
	" from TabCuiDomPasig"+;
	" Join TabCuiDomProf on TabCuiDomProf.ID = TCA_idprofe"+;
	" and TabCuiDomProf.TDP_pasivado = ?mfnull"+;
	" where TCA_pasivado = ?mfnull and TCA_idsolic = ?mlid","mwkProAsig")

If mret < 0
	MTABLA = "PROFESIONALES ASIGNADOS"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Select Iif(TDP_tipo=1,"MEDICO   ",Iif(TDP_tipo=2,"ENFERMERO","EXTERNO  ")) As ltipo,;
	TDP_prestador, lidAsig, 0 As lestado, lprofid, TDP_email as lmail;
	FROM mwkProAsig;
	INTO Cursor mwkProAsig Readwrite

Use In Select("mwkagendaG")
mret = SQLExec(mcon1,"SELECT TabCuiDomPagend.TPA_fecha, TabCuiDomPagend.TPA_hora,"+;
	" TabCuiDomPagend.TPA_idprocab, TabCuiDomPagend.id as lid, TabCuiDomPasig.TCA_idprofe as lidp"+;
	" FROM TabCuiDomPagend"+;
	" Join TabCuiDomPasig on TabCuiDomPasig.ID = TabCuiDomPagend.TPA_idprocab"+;
	" and TabCuiDomPasig.TCA_idsolic = ?mlid"+;
	" where TPA_pasivado = ?mfnull","mwkagendaG")

If mret < 0
	MTABLA = "C.D. PROFESIONALES ASIGNADOS AGENDA"
	Do LOG_ERRORES With Error(), Message(), Message(1), Program(), Lineno()
	Messagebox("EN LA TABLA " + MTABLA + Chr(10)+"AVISE A SISTEMAS",16,"ERROR")
	Return .F.
Endif

Select TPA_fecha As lfecha, _bdias(TPA_fecha) As ldia, TPA_hora As lhora,;
	lid, TPA_idprocab As lidprocab, 0 As lestado, lid as lid2, lidp;
	FROM mwkagendaG;
	INTO Cursor mwkagendaG Readwrite

Use In Select("mwkagendaBK")
Select * From mwkagendaG;
 Where lestado = 1;
  Into Cursor mwkagendaBK Readwrite

Return .T.

Function _bdias(mfc)
mdia   = Dow(mfc)
mretor = Space(10)
Do Case
Case mdia = 1
	mretor = "Domingo  "
Case mdia = 2
	mretor = "Lunes    "
Case mdia = 3
	mretor = "Martes   "
Case mdia = 4
	mretor = "Miércoles"
Case mdia = 5
	mretor = "Jueves   "
Case mdia = 6
	mretor = "Viernes  "
Case mdia = 7
	mretor = "Sabado   "
Endcase
Return mretor


* GROUP By TCA_idprofe;
*, TDP_idmaestro
*, Iif(TDP_tipo=1,_busespe(TDP_idmaestro),Space(30)) As lespe
* 	"  TCA_fecha, TCA_hora"+;
