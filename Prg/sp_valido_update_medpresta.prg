*******************************
* AUTOR:Claudia Antoniow
* FECHA:18/01/2002
*******************************
* Modificado:27/06/2003
*********************************************************************************
* valido el insert de medico prestación
*********************************************************************************
Lparameters lmemo
If Vartype (lmemo)#"N"
	lmemo = 0
Endif

mccpoamb = ''
If mxambito >1
	mccpoamb = "  and medpresta.codambito = ?mxambito "
Endif

If Type('mthrdes')= "N"
	vr_horad = mthrdes
	vr_horah = mthrhas
Else
	vr_horad = Val(Left(Strtran(mthrdes,":",""),4))
	vr_horah = Val(Left(Strtran(mthrhas,":",""),4))
Endif
*!*	if !used('mwkHabmemo')
*!*		do sp_busco_estados with 7,' and tipo = 2 ','mwkHabmemo'&& habilita memo electronico
*!*	endif
If mxambito >1
	mccpoamb = "  and codambito = ?mxambito "
Endif
mret=SQLExec(mcon1," SELECT * FROM medpresta WHERE codmed = ?mncodmed " + ;
	" AND codesp  = ?mccodesp AND codprest = ?mncodprest  " + ;
	" AND codserv = ?mncodserv AND diasem = ?mndia   "+;
	" AND hhmmdes = ?vr_horad AND hhmmhas = ?vr_horah " + ;
	" AND fecvigend <> fecvigenH "+;
	" AND not ( fecvigenH  <= ?mdfecvigend or fecvigend > ?mdfecVigenh  ) "+;
	mccpoamb ,"MWKmedprestaUnico")

If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR MWKmedprestaUnico, REINTENTE",16, "Validacion")
	mret = 0
Endif
mbexiste = 0
If !Eof('MWKmedprestaUnico') And !Bof('MWKmedprestaUnico')
	Messagebox("Esta Prestación ya Existe" + Chr(13) +;
		" Debe Dar de baja la Existente",16,'Validación')
	mbexiste=1
Endif

If mbexiste <> 1
	mccpoamb = ''
	If mxambito >1
		mccpoamb = "  and medpresta.codambito = ?mxambito "
	Endif

	mret=SQLExec(mcon1,"SELECT * FROM Medpresta WHERE codmed=?mncodmed AND "+;
		" duracion<>?mtdura AND diasem = ?mndia and fecvigend <> fecvigenH  "+mccpoamb +;
		"AND hhmmdes = ?vr_horad AND hhmmhas = ?vr_horah " + ;
		"AND ( ?mdfecvigend BETWEEN fecvigend AND fecvigenH  " + ;
		"OR ?mdfecVigenh BETWEEN fecvigend AND fecvigenH ) ","MwkMedDura" )

	If mret < 0
		Messagebox("ERROR EN LA GENERACION DEL CURSOR DURACION, REINTENTE",16, "Validacion")
		mret=0
	Endif
	If !Eof('mwkMedDura') And !Bof('mwkMedDura')
		mthoraexiste = Strtran(Str(Hour(mwkmeddura.duracion),2),' ','0') + ":" +;
			strtran(Str(Minute(mwkmeddura.duracion),2),'','0')
		If	Messagebox("Hay prestaciones con Duración " +mthoraexiste +  Chr(13)+ ;
				" Es diferente a la ingresada " + ;
				transform(mtdura),4+32+256,'Control de duraciones')<> 6
			mbexiste = 1
		Endif
	Endif
Endif

If mbexiste <> 1
	mccpoamb = ''
	If mxambito >1
		mccpoamb = "  and medpresta.codambito = ?mxambito "
	Endif

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

	If !Eof('mwkMediprest')
*!*			sele mwkMediprest
*!*			scan
*!*				locate for diasem = mndia and (mthrdes >ttoc(horadesde,2) and mthrdes < ttoc(horahasta,2))
*!*				if found()
		Messagebox("Error No puede superponer Horarios ",16,'Validación')
		mbexiste = 1
*!*					exit
*!*
*!*				endif
*!*			endscan
	Endif
Endif








