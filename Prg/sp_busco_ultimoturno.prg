*
* Busca el ultimo turno del profesional
*

parameters mfechatur, mcodmed, msala

if vartype(msala) <> "C"
	mjoin = "N"
else
	mjoin = "S"
endif

if mjoin = "S"
	mdia    = dow(mfechatur)

	mccpoamb = ''
	if mxambito >1
		mccpoamb = "  and turnos.codambito = ?mxambito "
	endif

	mccpoambtm = ''
	if mxambito >1
		mccpoambtm = "  and turnos.codambito = ?mxambito and medpresta.codambito = ?mxambito "
	endif
	lultimotur = .f.
	mihora = 0
	if used('mwkturnos2')
		mihora = val(strtran(mwkturnos2.hora,":",""))
	else
		if used('mwkseparo')
			mihora = val(strtran(left(ttoc(mwkseparo.horatur,2),5),":",""))
		endif

	endif
	mret = sqlexec(mcon1, "select hhmmdes,hhmmhas,max(turnos.hhmmtur) as ultimoTur,sala "+;
		" from turnos"+;
		" join medpresta on medpresta.codmed = turnos.codmed"+;
		" and medpresta.sala = ?msala and medpresta.diasem = ?mdia"+;
		" and medpresta.fecvigend <= ?mfechatur and medpresta.fecvigenh > ?mfechatur"+;
		" and medpresta.hhmmdes <= turnos.hhmmtur and medpresta.hhmmhas > turnos.hhmmtur "+;
		" and medpresta.fecvigend < medpresta.fecvigenh"+;
		" where turnos.fechatur = ?mfechatur and medpresta.hhmmhas>?mihora "+;
		" and (turnos.tipoturno < 8 or turnos.tipoturno >=13) and turnos.afiliado <> 1 "+;
		" and turnos.codmed = ?mcodmed"+mccpoambtm +;
		" group by hhmmdes","mwkUtimoTurn")

	if reccount('mwkUtimoTurn')>1
		select mwkUtimoTurn
		mlimsup = mwkUtimoTurn.hhmmhas
		skip
		lultimotur = (hhmmdes = mlimsup )
	endif

	if !lultimotur and mihora >0
		select  ultimoTur from mwkUtimoTurn where hhmmdes<mihora into cursor mwkUtimoTurn
	else
		mret = sqlexec(mcon1, "select max(turnos.hhmmtur) as ultimoTur"+;
			" from turnos"+;
			" join medpresta on medpresta.codmed = turnos.codmed"+;
			" and medpresta.sala = ?msala and medpresta.diasem = ?mdia"+;
			" and medpresta.fecvigend <= ?mfechatur and medpresta.fecvigenh > ?mfechatur"+;
			" and medpresta.hhmmdes <= turnos.hhmmtur and medpresta.hhmmhas > turnos.hhmmtur "+;
			" and medpresta.fecvigend < medpresta.fecvigenh"+;
			" where turnos.fechatur = ?mfechatur"+;
			" and (turnos.tipoturno < 8 or turnos.tipoturno >=13) and turnos.afiliado <> 1 "+;
			" and turnos.codmed = ?mcodmed"+mccpoambtm ,"mwkUtimoTurn")
	endif

else

	mret = sqlexec(mcon1, " select max(hhmmtur) as ultimoTur FROM turnos" +;
		" where fechatur = ?mfechatur" +mccpoamb +;
		" and (turnos.tipoturno < 8 or turnos.tipoturno >=13) and afiliado<>1 and codmed = ?mcodmed ","mwkUtimoTurn")
endif
if mret < 0
	=aerror(eros)
	messagebox(eros(3), 48, "Validación")
else
	menoseste = mwkutimoturn.ultimotur
	mret = sqlexec(mcon1, " select max(hhmmtur) as ultimoTur FROM turnos" +;
		" where fechatur = ?mfechatur" +mccpoamb +;
		" and hhmmtur< ?menoseste and (turnos.tipoturno < 8 or turnos.tipoturno >=13) and afiliado<>1 and codmed = ?mcodmed ","mwkPenUltTurn")

	if mret < 0
		=aerror(eros)
		messagebox(eros(3), 48, "Validación")
	endif

endif

