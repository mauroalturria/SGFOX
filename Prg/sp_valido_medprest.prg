*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
*MODIFICADO:19/08/2004
*******************************
****************************************************************
* Trae apartir de un médicos lo que se encuentran en medpresta *
****************************************************************
If Type('mthrdes')= "N"
	hr1 = mthrdes
	hr2 = mthrhas
Else
	hr1 = Val(Left(Strtran(mthrdes,":",""),4))
	hr2 = Val(Left(Strtran(mthrhas,":",""),4))
Endif
mccpoamb = ''
if mxambito >1
	mccpoamb = "  and medpresta.codambito = ?mxambito "
endif

mret=SQLExec(mcon1,"SELECT * FROM Medpresta "+;
	" WHERE codmed=?mncodmed and diasem =?mndia and fecvigend <> fecvigenH "+;
	" AND fecvigend <=?mdfecVigend "+;
	" AND fecvigenh >=?mdfecVigenH "+;
	" AND codprest = ?mncodprest  " + mccpoamb+ ;
	" AND ((hhmmdes >?mthrDes "+;
	" AND hhmmhas < ?mthrHas) "+;
	" Or (hhmmdes BETWEEN ?mthrDes  AND ?mthrHas) "+;
	" Or (hhmmhas BETWEEN ?mthrDes   AND ?mthrHas)) "+;
	" AND NOT id in (SELECT id FROM medpresta "+;
	" WHERE codmed=?mncodmed AND fecvigend <=?mdfecVigenH "+;
	" AND diasem =?mndia "+;
	" AND fecvigenh >=?mdfecVigenH and fecvigend <> fecvigenH "+;
	" AND (hhmmdes = ?mthrHas OR hhmmhas =?mthrDes ))"+mccpoamb +;
	" GROUP BY codprest,diasem, duracion","MwkMediPrest")



If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR MwkMediPrest, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
Endif
