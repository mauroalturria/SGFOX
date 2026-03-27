*
* Proma : Insuficiencia Cardiaca, ver si queremos aplicar PROTOCOLO
*
Parameters mregistrac &&, mprotocolo

lcSql = "select * from TabProma where TPR_registracio = ?mregistrac order by TPR_fecha desc"

If !Prg_EjecutoSql(lcSql, "mwkproma")
	Return .F.
Endif

Select mwkproma
Go Top
Scan All

	mtxt = mtxt + ;
		"Fecha: " + Ttoc(mwkproma.TPR_fecha) +;
		", Registrado por: "+Alltrim(mwkproma.TPR_usuarioreg)+Chr(10)+;
		"Peso: " + Alltrim(Transform(mwkproma.TPR_peso/1000, "@R 999.999"))+;
		", Presión Sistólica: "+Alltrim(Transform(mwkproma.TPR_sistolica))+;
		", Diastólica: "+Alltrim(Transform(mwkproma.TPR_diastolica))+;
		", Frec. Cardíaca: " + Alltrim(Transform(mwkproma.TPR_frecard))+;
		", Liquido Diario: "+Alltrim(Transform(mwkproma.TPR_liquidia/1000, "@R 999.999"))+;
		", Adhesión a la dieta: "

	Do Case
	Case mwkproma.TPR_adhedieta = 1
		mtxt = mtxt + "SI "
	Case mwkproma.TPR_adhedieta = 2
		mtxt = mtxt + "NO "
	Otherwise
		mtxt = mtxt + "NO DETERMINADO "
	Endcase

	mtxt = mtxt + ", Betabloqueantes: "

	Do Case
	Case mwkproma.TPR_betabloq = 1

		mtxt = mtxt + "SI "

		mbusca = mwkproma.TPR_betacual
		Do sp_busco_estados With 38,' and tipo = 1 and estado = '+Alltrim(Transform(mbusca)),'mwklista'
		If Used("mwklista")
			If Reccount("mwklista")>0
				mtxt = mtxt + Alltrim(mwklista.Descrip) + ", dosis "+ Alltrim(mwkproma.TPR_betadosis)
			Endif
		Endif
		Use In Select("mwklista")

	Case TPR_betabloq = 2
		mtxt = mtxt + "NO "
	Otherwise
		mtxt = mtxt + "NO DETERMINADO "
	Endcase

	mtxt = mtxt + ", Inhibidores de la enzima convertidora de angiotensina o antagonistas del receptor de angiotensina: "
	Do Case
	Case mwkproma.TPR_angiotensina = 1
		mtxt = mtxt + "SI "

		mbusca = mwkproma.TPR_angiocual
		Do sp_busco_estados With 38,' and tipo = 2 and estado = '+Alltrim(Transform(mbusca)),'mwklista'
		If Used("mwklista")
			If Reccount("mwklista")>0
				mtxt = mtxt + Alltrim(mwklista.Descrip) + ", dosis "+ Alltrim(mwkproma.TPR_angiodosis)
			Endif
		Endif
		Use In Select("mwklista")

	Case mwkproma.TPR_angiotensina = 2
		mtxt = mtxt + "NO "
	Otherwise
		mtxt = mtxt + "NO DETERMINADO "
	Endcase

	mtxt = mtxt + ", Furosemida: "
	Do Case
	Case mwkproma.TPR_furosemida = 1
		mtxt = mtxt + "SI" + ", dosis "+Alltrim(Transform(mwkproma.TPR_furodosis))
	Case mwkproma.TPR_furosemida = 2
		mtxt = mtxt + "NO "
	Otherwise
		mtxt = mtxt + "NO DETERMINADO "
	Endcase

	mtxt = mtxt + ", Antialdosterónico: "
	Do Case
	Case mwkproma.TPR_antialdos = 1
		mtxt = mtxt + "SI"

		mbusca = mwkproma.TPR_anticual
		Do sp_busco_estados With 38,' and tipo = 3 and estado = '+Alltrim(Transform(mbusca)),'mwklista'
		If Used("mwklista")
			If Reccount("mwklista")>0
				mtxt = mtxt + Alltrim(mwklista.Descrip) + ", dosis "+ Alltrim(mwkproma.TPR_antidosis)
			Endif
		Endif
		Use In Select("mwklista")

	Case mwkproma.TPR_antialdos = 2
		mtxt = mtxt + "NO "
	Otherwise
		mtxt = mtxt + "NO DETERMINADO "
	Endcase

*!*  Otros Insumos

	mbusca = mwkproma.Id
	lcSql = "select * from TabPromaOtros where TPO_promaid = ?mbusca"

	Use In Select("mwkpromaOtro")
	If !Prg_EjecutoSql(lcSql, "mwkpromaOtro")
		Return .F.
	Endif

	mpaso = 0

	Select mwkpromaOtro
	Go Top
	Scan All

		If mpaso = 0
			mtxt = mtxt + Chr(10) + "Otros insumos"+ Chr(10)
			mpaso = 1
		Endif

		mtxt = mtxt + Alltrim(mwkpromaOtro.TPO_Insumo)+ ", dosis "+Alltrim(mwkpromaOtro.TPO_dosis) + Chr(10)

	Endscan

	Select mwkproma

	mtxt = mtxt + Chr(10)

	mtxt = mtxt + "Cambios en el tratamiento: " + Alltrim(mwkproma.TPR_cambios)

	mtxt = mtxt + ", Clase funcional (Clasificación New York Heart Association): "

	If TPR_classny > 0
		mtxt = mtxt + Transform(mwkproma.TPR_classny)
	Else
		mtxt = mtxt + "NO DETERMINADO "
	Endif

	mtxt = mtxt + ", Disnea paroxística nocturna: "
	Do Case
	Case mwkproma.TPR_disnea = 1
		mtxt = mtxt + "SI "
	Case mwkproma.TPR_disnea = 2
		mtxt = mtxt + "NO "
	Otherwise
		mtxt = mtxt + "NO DETERMINADO "
	Endcase

	mtxt = mtxt + ", Ortopnea: "
	Do Case
	Case mwkproma.TPR_ortopnea = 1
		mtxt = mtxt + "SI "
	Case mwkproma.TPR_ortopnea = 2
		mtxt = mtxt + "NO "
	Otherwise
		mtxt = mtxt + "NO DETERMINADO "
	Endcase

	mtxt = mtxt + ", Progresión de los edemas: "
	Do Case
	Case mwkproma.TPR_progredema = 1
		mtxt = mtxt + "SI "
	Case mwkproma.TPR_progredema = 2
		mtxt = mtxt + "NO "
	Otherwise
		mtxt = mtxt + "NO DETERMINADO "
	Endcase

	mtxt = mtxt + ", Edemas: "
	Do Case
	Case mwkproma.TPR_edemas = 1
		mtxt = mtxt + "SI "
	Case mwkproma.TPR_edemas = 2
		mtxt = mtxt + "NO "
	Otherwise
		mtxt = mtxt + "NO DETERMINADO "
	Endcase

	mtxt = mtxt + ", Grado de edemas: "

	If mwkproma.TPR_gredema > 0
		mtxt = mtxt + Transform(mwkproma.TPR_gredema - 1)
	Else
		mtxt = mtxt + "NO DETERMINADO "
	Endif

	mtxt = mtxt + ", Ingurgitación yugular: "

	If mwkproma.TPR_ingyug > 0
		mtxt = mtxt + Transform(mwkproma.TPR_ingyug - 1)
	Else
		mtxt = mtxt + "NO DETERMINADO "
	Endif

	mtxt = mtxt + ", Hepatomegalia: "
	Do Case
	Case mwkproma.TPR_hepatom = 1
		mtxt = mtxt + "SI "
	Case mwkproma.TPR_hepatom = 2
		mtxt = mtxt + "NO "
	Otherwise
		mtxt = mtxt + "NO DETERMINADO "
	Endcase

	mtxt = mtxt + ", Rales crepitantes: "
	Do Case
	Case mwkproma.TPR_ralescrep = 1
		mtxt = mtxt + "SI "
	Case mwkproma.TPR_ralescrep = 2
		mtxt = mtxt + "NO "
	Otherwise
		mtxt = mtxt + "NO DETERMINADO "
	Endcase
	mtxt = mtxt + Alltrim(mwkproma.TPR_ralescrepobs)

	If mwkproma.TPR_muere <> 1

		mtxt = mtxt + ", Estable: "
		Do Case
		Case mwkproma.TPR_estable = 1
			mtxt = mtxt + "SI "
		Case mwkproma.TPR_estable = 2
			mtxt = mtxt + "NO "
		Otherwise
			mtxt = mtxt + "NO DETERMINADO "
		Endcase

		mtxt = mtxt + ", Reinternación: "
		Do Case
		Case mwkproma.TPR_reinterna = 1
			mtxt = mtxt + "SI "
		Case mwkproma.TPR_reinterna = 2
			mtxt = mtxt + "NO "
		Otherwise
			mtxt = mtxt + "NO DETERMINADO "
		Endcase

	Endif

	If mwkproma.TPR_muere > 0

		mtxt = mtxt + ", Muere: "
		If mwkproma.TPR_muere = 1
			mtxt = mtxt + "SI "
		Else
			mtxt = mtxt + "NO "
		Endif

	Endif


	If !Empty(Alltrim(mwkproma.TPR_otros))
		mtxt = mtxt + Chr(10) + "Otros hallazgos: " + Alltrim(mwkproma.TPR_otros)
	Endif


	If !Empty(Alltrim(mwkproma.TPR_estudios))
		mtxt = mtxt + Chr(10) + "Estudios complementarios: " + Alltrim(mwkproma.TPR_estudios)
	Endif

	If !Empty(Alltrim(mwkproma.TPR_comentarios))
		mtxt = mtxt + Chr(10) + "Comentarios: " + Alltrim(mwkproma.TPR_comentarios)
	Endif

	mtxt = mtxt + Chr(10) + Chr(10)
Endscan

Return .T.
