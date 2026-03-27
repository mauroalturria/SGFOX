*
* Grabo de encuetas
*
Lparameters mform

With mform

	mfmov = sp_busco_fecha_serv('DD')
	muser = Alltrim(mwkusuario.idusuario)
	mv3   = Alltrim(.edtencu.value)

	If .ltipo = "A"

		mv1 = .lorig
		mv2 = .txtprotocolo.value

		mret = sqlexec(mcon1,"INSERT INTO TabEncuestas"+;
			" (TEC_origen, TEC_protocolo, TEC_encuesta, TEC_fecmov, TEC_usuario)"+;
			" values "+;
			" (?mv1, ?mv2, ?mv3, ?mfmov, ?muser)")

	Else

		mlid = mwkencues.id
		
		mret = sqlexec(mcon1,"UPDATE TabEncuestas SET "+;
			" TEC_encuesta = ?mv3, "+;
			" TEC_fecmov = ?mfmov, "+;
			" TEC_usuario = ?muser "+;
			" where id = ?mlid")

	Endif

	If mret < 0
		Messagebox("ERROR EN ACTUALIZACION DE ENCUESTAS",26,"ERROR")
		Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
		Return .F.
	Endif

Endwith

Return .T.















