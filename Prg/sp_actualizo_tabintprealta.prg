*!*	sp_actualizo_TabIntprealta
parameters tnOpcion, tnId, tnadmision , tncodmed ,tnprofSegAmb , tnreqCuiDom , tnopcAmbu , tnreqSegAmb ,tnopteduca ;
	, tnverImplem , tnverPacInf , tnverResInf, tndestino ,tnoptdieta,  tnfechah,tndialisis

tnfechah = sp_busco_fecha_serv("DT")
tnpasivado  = tnfechah
if vartype(tnobserva )#"C"
	tnobserva  = ''
endif
tnreqSegAmb = 0
mfecnul = ctod("01/01/1900")
do case
	case tnOpcion = 1
		lcSql = "Insert into TabIntPreAlta " + ;
			" (IPA_admision , IPA_codmed , IPA_fechah , IPA_observa , IPA_pasivado , IPA_profSegAmb , IPA_reqAmbu ,"+;
			" IPA_reqCuiDom , IPA_reqSegAmb , IPA_verImplem , IPA_verPacInf , IPA_verResInf,IPA_destino, IPA_reqDieta, IPA_reqEduca, IPA_dialisis  ) " + ;
			" Values " + ;
			" (?tnadmision , ?tncodmed , ?tnfechah , ?tnobserva , ?mfecnul , ?tnprofSegAmb , ?tnopcAmbu, ?tnreqCuiDom , ?tnreqSegAmb "+;
			" , ?tnverImplem , ?tnverPacInf , ?tnverResInf,?tndestino, ?tnoptdieta,?tnopteduca,?tndialisis ) "

	case tnOpcion = 2

		lcSql = "Insert into TabIntPreAlta " + ;
			" (IPA_admision , IPA_codmed , IPA_fechah , IPA_observa , IPA_pasivado , IPA_profSegAmb , IPA_reqAmbu ,"+;
			" IPA_reqCuiDom , IPA_reqSegAmb , IPA_verImplem , IPA_verPacInf , IPA_verResInf,IPA_dialisis ) " + ;
			" Values " + ;
			" (?tnadmision , ?tncodmed , ?tnfechah , ?tnobserva , ?mfecnul , ?tnprofSegAmb , ?tnopcAmbu, ?tnreqCuiDom , ?tnreqSegAmb "+;
			" , ?tnverImplem , ?tnverPacInf , ?tnverResInf,?tndialisis ) "

	case tnOpcion = 3
		midusu = IIF( USED('mwkusuarios'),mwkusuarios.idusuario,mwkusuario.idusuario)
		lcSql = "Update TabIntPreAlta " + ;
				" Set IPA_pasivado = ?tnpasivado,FecHorDbUpd = ?tnfechah  ,UserDbAdd = ?midusu  " + ;
				" Where  IPA_admision = ?tnadmision and  IPA_pasivado = ?mfecnul "

	otherwise

endcase

if !Prg_EjecutoSql(lcSql,'',.f.)
	return .f.
endif

