*DO FORM frmfpago
mcon1 = SQLConnect("Bristol")
Set ENGINEBEHAVIOR 70
*!*	*USE b_turno_doble AGAIN IN 0
lcSql = "SELECT codmed, diasem, fecVigend,codesp,"+;
" fecVigenH, hhmmDes, hhmmHas,duracion,codambito,codprest "+;
" FROM Medpresta "+;
" WHERE  Medpresta.fecVigenH > Medpresta.fecVigend"+;
" AND Medpresta.fecVigenH >= {fn curdate()}"+;
" AND Medpresta.GeneraAgen = 1 "

If !prg_ejecutosql(lcSql,"mwkmedprestDI")
	Return .F.
Endif
mret = SQLExec(mcon1, "SELECT Turnos.ID, afiliado, codreserva, fechatomado,horatur,"+;
" fechatur, hhmmTur, diasem,usuario, codent, codesp, codambito,  codprest, codserv, tipotomado,"+;
" usuario, Prestacions.PRE_descriprest, Prestacions.PRE_duracion,  usuariosector, codmed,pre_turnosmultip"+;
" FROM Turnos INNER JOIN Prestacions   ON  codprest = PRE_codprest"+;
" WHERE  fechatur >= {fn curdate()}   and tipoturno not in (1,2)    "+;
" ORDER BY codmed, horatur, codreserva ","b_turno_doble")
Set Step On
Select * From b_turno_doble Group By codmed,fechatur, codreserva Having Count(Id)>1 Into Cursor dobles
Select dobles.*,mwkmedprestDI.duracion;
From mwkmedprestDI,dobles;
WHERE mwkmedprestDI.codmed =  dobles.codmed And mwkmedprestDI.codambito=  dobles.codambito;
AND mwkmedprestDI.diasem =  dobles.diasem And hhmmDes <=  dobles.hhmmTur ;
AND hhmmHas>=  dobles.hhmmTur And fecVigend <=  dobles.fechatur ;
AND mwkmedprestDI.codprest =  dobles.codprest And  fecVigenH>=  dobles.fechatur ;
ORDER By  dobles.Id  ;
Into Cursor mwkturnocambio
*!*	*SELECT * FROM b_turno_doble WHERE codreserva in (SELECT codreserva FROM dobles) AND pa_duracion <pre_duracion
Select * From mwkturnocambio  Into Cursor estanmal
mcDir_Docs ="c:\tempdoc\"
mfecha=DATE()

If Reccount('estanmal')>0
	mcArch = mcDir_Docs + "doble_" + Dtos(mfecha) + ".txt"
	Do While File(mcArch)
		i = i + 1
		mcArch = mcDir_Docs + "doble_" + Dtos(mfecha) + "_" + Alltrim(Str(i,2,0)) + ".txt"
	ENDDO
	mnarch = Fcreate(mcArch)
	Select estanmal
	Scan
		mambito  =codambito
		mprest = codprest
		mdura = Val(Substr(Ttoc(duracion,2),4,2))
		mret = SQLExec(mcon1, "SELECT PA_codiprest, PA_duracion, PA_retiroestudios,PA_turnosmultip"+;
		" FROM  Tabprestambito "+;
		" WHERE  PA_codambito = ?mambito  AND PA_codiprest= ?mprest AND  PA_fecpasiva='1900-01-01'  ","durapres")
		If Reccount("durapres")>0
			If mdura<PA_duracion
				mccad = 'DXA'
				mccad =  mccad + Chr(9) + estanmal.codreserva
 				mccad = mccad + Chr(9) + Transform(mdura)
				mccad = mccad + Chr(9) + Transform(PA_duracion)
				mccad = mccad + Chr(9) +Transform(estanmal.codambito)
				mccad = mccad + Chr(9) + Transform(estanmal.codprest)
				Fputs(mnarch, mccad)
				Loop
			Endif
		Else
			Select * From b_turno_doble Where codreserva = estanmal.codreserva Order By horatur Into Cursor controhora
			Select controhora
			mihora = horatur
			Skip 1
			duratur = (horatur-mihora)/60
			If duratur<estanmal.PRE_duracion
				mccad = 'DXT'
				mccad =  mccad + Chr(9) + estanmal.codreserva
 				mccad = mccad + Chr(9) + Transform(duratur)
				mccad = mccad + Chr(9) + Transform(estanmal.PRE_duracion)
				mccad = mccad + Chr(9) +Transform(estanmal.codambito)
				mccad = mccad + Chr(9) + Transform(estanmal.codprest)
				Fputs(mnarch, mccad)
				Loop
			Endif
		Endif
		Select estanmal

		mid = Id
*!*			mret = SQLExec(mcon1, "Update turnos Set afiliado = 0, usuario = '', codprest = 0, UsuarioSector =0"+;
*!*			",  codreserva = '',codent = 0, codserv = 0, codesp = ''	, tipotomado =0 Where Id =?mid")
	Endscan
Endif
Fclose(mnarch)
Do sp_desconexion
