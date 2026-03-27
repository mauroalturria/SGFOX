Lparameters nOpcion, nIDdel

* Sp_Grabo_Tablas_Calidad
* Julio 2016 - Fabián
*************************

Local mConsulta, mMensaje

mfecha = sp_busco_fecha_serv("DD")
mfechapasiva = "1900-01-01"

Do Case

Case nOpcion = 1 && Insert (Agrego)

	mConsulta = "insert into tabexegrupo (teg_fechaalta,teg_fechabaja,teg_codvaxalta,teg_idtabexe,teg_idtabgc)" +;
		" values (?mfecha,?mfechapasiva,?mwkusuario.codigovax,?mwkejecunoasig.id,?mwktabgcgrupo.id)"
	mMensaje = "Error al insertar el registro nuevo."
	If !prg_ejecutosql(mConsulta)
	Return .F.
	Endif

*	GrabarTabla(mConsulta,mMensaje,0)

Case nOpcion = 2 && Update (Borro)

	mConsulta = "Update TabExeGrupo Set teg_codvaxbaja = ?mwkusuario.codigovax, teg_fechabaja = ?mfecha, teg_fechaalta = ?mfecha Where TabExeGrupo.id = ?" + Alltrim(Str(nIDdel))
	mMensaje = "Error al borrar registro."
	If !prg_ejecutosql(mConsulta)
	Return .F.
	Endif

*	GrabarTabla(mConsulta,mMensaje,nIDdel)

Endcase

Return .F.