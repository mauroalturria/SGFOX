*
* Grabo Log Citostáticos
*
Lparameters mpartida,mcodigo,mtotals,mmotivo,mtipo,mfechamov,midusua,mvencio,mlotes,mtgtin,mtserie

*!*	If vartype(mtgtin) <> 'C'
*!*		mtgtin = ''
*!*	Endif
*!*	If vartype(mtserie) <> 'C'
*!*		mtserie = ''
*!*	Endif

If vartype(midusua) <> "C"
	mfechamov = sp_busco_fecha_serv("DT")
	midusua   = mwkusuario.idusuario
Endif

mret = sqlexec(mcon1, "insert into TabFarmLog" + ;
	"(TFL_fechamov,TFL_idusuario,TFL_partida,TFL_insumocodigo,TFL_potencia,"+;
	"TFL_motivo,TFL_tipo,TFL_vence,TFL_lote,TFL_gtin,TFL_serie)"+;
	" values (?mfechamov,?midusua,?mpartida,?mcodigo,?mtotals,?mmotivo,?mtipo,"+;
	"?mvencio,?mlotes,?mtgtin,?mtserie)")

If mret < 0
	Messagebox("ERROR EN MAESTRO DE REGISTRO DE MOVIMIENTOS"+chr(10)+;
		"AVISE A SISTEMAS",0,"Validacion")
	Do log_errores With ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()
	Return .F.
Endif

Return .T.
