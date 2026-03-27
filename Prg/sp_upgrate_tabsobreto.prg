****
** Actualizo tabla de sobreturnos
****

parameters mid, mcanti, mcodmed, mcodpre, mdia, mhorag, mfecdes, mfechas, ;
			mhorad, mhorah, mporce, mtiptur, mtabomed
	
	hhmmD		= val(left(mhorad  ,2)+substr(mhorad  ,4,2))
	hhmmH		= val(left(mhorah  ,2)+substr(mhorah  ,4,2))

if mtabomed = '1'

	mret = sqlexec(mcon1, "update tabsobretoa " + ;
							"set cantidad = ?mcanti, porcentaje = ?mporce, " + ;
								"horadesde = ?mhorad, horahasta = ?mhorah, " + ;
								"fechagraba = ?mhorag, usuario = ?midusu, " + ;
								"fvigend = ?mfecdes, fvigenh = ?mfechas, " + ;
								"hhmmDes = ?hhmmD, hhmmHas = ?hhmmH,   " + ;
								"tipoturno = ?mtiptur " + ;
							"where id = ?mid ")
else
	
	mret = sqlexec(mcon1, "insert into tabsobretoa " + ;
			"values(?mcanti, ?mcodmed, ?mcodpre, ?mdia, ?mhorag, ?mfecdes, ?mfechas, " + ;
					"?hhmmD, ?hhmmH, ?mhorad, ?mhorah, ?mporce, ?mtiptur, ?midusu)")
endif

if mret < 0
	messagebox("ERROR AL ACTUALIZAR SOBRETURNOS" , 16, "Validacion")
	DO sp_desconexion WITH "error"
	cancel
endif

