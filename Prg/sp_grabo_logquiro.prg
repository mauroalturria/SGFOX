***********
** grabo datos de quirofano
***********
mfechaHora	= sp_busco_fecha_serv('DT')
select mwkusuario
musuario = codigovax
			mret = sqlexec(mcon1,"INSERT INTO TabQuirofano ( Anestesista ,Ayudante , BiopsiaIntraOp , BiopsioDiferida , Cardiologo , "+;
				" values" +;
				" ?mPacNombre , ?mRayos,?mcodmed,?mcirujano,?mDiagnostico,?mfechaHora,?musuario)")
			if mret<1
				=aerr(eros)
				messagebox(eros(2))
 SELECT ID , Dato , FechaMod , IdTabQuirofano , UsuarioQ , ValorActual , ValorAnterior FROM SQLUser . TabQuirofLog