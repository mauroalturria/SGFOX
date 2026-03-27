Parameters tnOpcion, tnId,mfechaQuiro,mturno,mservicio ,mduracEst,mestado,mquiro,mihora, mTipoPac,tnhabST

tnfechah = sp_busco_fecha_serv("DT")
mfecnul= Ctod("01/01/1900")
tnpasivado = tnfechah
If Vartype(tnhabST )<>"N"
	tnhabST =0
Endif

Do Case
Case tnOpcion = 1
	mret = SQLExec(mcon1, "update Tabpqquiro set PQQ_referencia=0, PQQ_estado = 0 "+;
		" Where PQQ_referencia = ?tnId ")
	mdia = Dow(mfechaQuiro )
	mret = SQLExec(mcon1, "select PQF_duracion,PQF_turnoLimpieza from Tabpqfran"+;
		" Where PQF_fecvigend<= ?mfechaQuiro and PQF_fecvigenh>= ?mfechaQuiro and PQF_quirofano = ?mquiro and "+;
		" PQF_servicio = ?mservicio and PQF_horaInicio <= ?mihora and pqf_dia = ?mdia ","mwkpqFran")
	If Reccount("mwkpqFran")= 0
		mret = SQLExec(mcon1, "select PQF_duracion,PQF_turnoLimpieza from Tabpqfran"+;
			" Where PQF_fecvigend<= ?mfechaQuiro and PQF_fecvigenh>= ?mfechaQuiro and PQF_quirofano = ?mquiro and "+;
			" PQF_servicio = ?mservicio and pqf_dia = ?mdia ","mwkpqFran")
	Endif
	If Reccount("mwkpqFran")= 0
		mret = SQLExec(mcon1, "select PQF_duracion,PQF_turnoLimpieza,pqf_especialidad from Tabpqfran"+;
			" Where PQF_fecvigend<= ?mfechaQuiro and PQF_fecvigenh>= ?mfechaQuiro and PQF_quirofano = ?mquiro and "+;
			" pqf_dia = ?mdia ","mwkpqFran")
		Select mwkpqFran
		Locate For At(Alltrim(Transform(mservicio )),pqf_especialidad)>0
		If Eof()
			Go Top
		Endif
	Endif
	If tnhabST = 1&& es ST
		lcSQL = "insert into tabpqquiro (pqq_estado,pqq_fecha,pqq_quirofano,pqq_referencia,pqq_turno,pqq_servicio,PQQ_hora,UserDbUpd) "+;
			" values (?mestado,?mfechaQuiro,?mquiro,?tnId,?mturno,?mservicio,?mihora,'ST')"
		mret = SQLExec(mcon1,lcSQL)
		If mret < 0
		*	cmensa = cmensa + "ERROR AL GENERAR LA AGENDA"
		Endif
	Else
		mduratur = mwkpqFran.PQF_duracion
		mcanti = mduracEst+ Nvl(mwkpqFran.PQF_turnoLimpieza,0)*mduratur
		Do While mcanti >0
			mret = SQLExec(mcon1, "select id from Tabpqquiro "+;
				" Where PQQ_fecha=?mfechaQuiro and PQQ_quirofano= ?mquiro and "+;
				"PQQ_referencia=0 and PQQ_servicio = ?mservicio and PQQ_hora >= ?mihora order by PQQ_hora","mwkpqxvac")
			If Reccount("mwkpqxvac")>0

				Select mwkpqxvac
				Go Top
				Do While mcanti >0 And !Eof()

					mid = mwkpqxvac.Id
					mret = SQLExec(mcon1, "Update Tabpqquiro set  " + ;
						"  PQQ_estado = ?mestado, PQQ_referencia= ?tnId "+;
						" Where id = ?mid and PQQ_referencia=0 ")
					mcanti  = mcanti - mduratur
					Select mwkpqxvac
					Skip
				Enddo
			Else
				If mcanti>0
*set step on
					mcanti=0
				Endif
			Endif
		Enddo

		mret = SQLExec(mcon1, "select id from Tabpqquiro "+;
			" Where PQQ_fecha=?mfechaQuiro and PQQ_quirofano= ?mquiro and "+;
			"PQQ_referencia= ?tnId and PQQ_servicio = ?mservicio  ","mwkpqxref")
		If !Inlist(mwkexe.nomexe,"PISOS","GUARDIA")
			If ( Reccount("mwkpqxref")*mduratur < mduracEst + Nvl(mwkpqFran.PQF_turnoLimpieza,0)*mduratur) And tnhabST =0
				mret = SQLExec(mcon1, "update Tabpqquiro set PQQ_referencia=0, PQQ_estado = 0 "+;
					" Where PQQ_referencia = ?tnId ")
				Messagebox("NO HAY TURNOS SUFICIENTES, u OTRO PROFESIONAL ACABA DE UTILIZAR ESTAS HORAS. TIENE QUE REPROGRAMAR",48,"Control de horario")
				Return .F.
			Endif

			If (mTipoPac = 4) And !sp_busco_camasiqb_disp(mfechaQuiro,mihora)
				Messagebox("NO HAY CAMAS IQB DISPONIBLES EN ESE HORARIO.",48,"Control de horario")
				Return .F.
			Endif
		Endif

	Endif
	Return .T.
Case tnOpcion = 2
	mret = SQLExec(mcon1, "update Tabpqquiro set PQQ_referencia=0, PQQ_estado = 0 "+;
		" Where PQQ_referencia = ?tnId ")
Otherwise
	Return .T.
Endcase

*!*	if !Prg_EjecutoSql(lcSql,'',.f.)
*!*		return .f.
*!*	endif

