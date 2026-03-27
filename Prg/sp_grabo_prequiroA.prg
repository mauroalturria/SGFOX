parameters tnOpcion, tnId,mfechaQuiro,mturno,mservicio ,mduracEst,mestado,mquiro,mihora

tnfechah = sp_busco_fecha_serv("DT")
mfecnul= ctod("01/01/1900")
tnpasivado = tnfechah
do case
	case tnOpcion = 1
		mret = sqlexec(mcon1, "update Tabpqquiro set PQQ_referencia=0, PQQ_estado = 0 "+;
			" Where PQQ_referencia = ?tnId ")
		mdia = dow(mfechaQuiro )
		mret = sqlexec(mcon1, "select PQF_duracion from Tabpqfran"+;
			" Where PQF_fecvigend<= ?mfechaQuiro and PQF_fecvigenh>= ?mfechaQuiro and PQF_quirofano = ?mquiro and "+;
			" PQF_servicio = ?mservicio and PQF_horaInicio <= ?mihora and pqf_dia = ?mdia ","mwkpqFran")
		if reccount("mwkpqFran")= 0
			mret = sqlexec(mcon1, "select PQF_duracion from Tabpqfran"+;
				" Where PQF_fecvigend<= ?mfechaQuiro and PQF_fecvigenh>= ?mfechaQuiro and PQF_quirofano = ?mquiro and "+;
				" PQF_horaInicio <= ?mihora and pqf_dia = ?mdia ","mwkpqFran")
		endif
		mduratur = mwkpqFran.PQF_duracion
		mcanti = mduracEst
		do while mcanti >0
			mret = sqlexec(mcon1, "select id from Tabpqquiro "+;
				" Where PQQ_fecha=?mfechaQuiro and PQQ_quirofano= ?mquiro and "+;
				"PQQ_referencia=0 and PQQ_servicio = ?mservicio and PQQ_hora >= ?mihora order by PQQ_hora","mwkpqxvac")
			if reccount("mwkpqxvac")>0

				select mwkpqxvac
				go top
				do while mcanti >0 and !eof()

					mid = mwkpqxvac.id
					mret = sqlexec(mcon1, "Update Tabpqquiro set  " + ;
						"  PQQ_estado = ?mestado, PQQ_referencia= ?tnId "+;
						" Where id = ?mid and PQQ_referencia=0 ")
					mcanti  = mcanti - mduratur
					select mwkpqxvac
					skip
				enddo
			else
				if mcanti>0
*set step on
					mcanti=0
				endif
			endif
		enddo
		mret = sqlexec(mcon1, "select id from Tabpqquiro "+;
			" Where PQQ_fecha=?mfechaQuiro and PQQ_quirofano= ?mquiro and "+;
			"PQQ_referencia= ?tnId and PQQ_servicio = ?mservicio  ","mwkpqxref")
		if reccount("mwkpqxref")*mduratur < mduracEst
			mret = sqlexec(mcon1, "update Tabpqquiro set PQQ_referencia=0, PQQ_estado = 0 "+;
				" Where PQQ_referencia = ?tnId ")
			messagebox("NO HAY TURNOS SUFICIENTES, u OTRO PROFESIONAL ACABA DE UTILIZAR ESTAS HORAS. TIENE QUE REPROGRAMAR",48,"Control de horario")
			return .f.
		endif
		return .t.
	case tnOpcion = 2
		mret = sqlexec(mcon1, "update Tabpqquiro set PQQ_referencia=0, PQQ_estado = 0 "+;
			" Where PQQ_referencia = ?tnId ")
	otherwise
		return .t.
endcase

*!*	if !Prg_EjecutoSql(lcSql,'',.f.)
*!*		return .f.
*!*	endif

